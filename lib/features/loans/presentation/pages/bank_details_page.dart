import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../presentation/auth/auth_gate.dart';

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  @override
  State<BankDetailsPage> createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final String firebaseUid = FirebaseAuth.instance.currentUser!.uid;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController receiverNameCtrl = TextEditingController();
  final TextEditingController ibanCtrl = TextEditingController();
  final TextEditingController bicCtrl = TextEditingController();
  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController bankAddressCtrl = TextEditingController();

  bool loading = false;
  bool initialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBankDetails();

    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthGate()),
        );
      });
    }
  }

  @override
  void dispose() {
    receiverNameCtrl.dispose();
    ibanCtrl.dispose();
    bicCtrl.dispose();
    bankNameCtrl.dispose();
    bankAddressCtrl.dispose();
    super.dispose();
  }

  // ================= LOAD PROFILE =================
  Future<void> _loadBankDetails() async {
    final res = await supabase
        .from('profiles')
        .select(
      'receiver_full_name, iban, bic, bank_name, bank_address',
    )
        .eq('firebase_uid', firebaseUid)
        .maybeSingle();

    if (res != null) {
      receiverNameCtrl.text = res['receiver_full_name'] ?? '';
      ibanCtrl.text = res['iban'] ?? '';
      bicCtrl.text = res['bic'] ?? '';
      bankNameCtrl.text = res['bank_name'] ?? '';
      bankAddressCtrl.text = res['bank_address'] ?? '';
    }

    setState(() => initialLoading = false);
  }

  // ================= SAVE =================
  Future<void> _saveBankDetails() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint("❌ Form validation failed");
      return;
    }

    setState(() => loading = true);
    final stopwatch = Stopwatch()..start();

    debugPrint("🚀 START _saveBankDetails");

    try {
      // ================= GET PROFILE =================
      debugPrint("🔍 Fetching profile");

      final profile = await supabase
          .from('profiles')
          .select('receiver_full_name')
          .eq('firebase_uid', firebaseUid)
          .maybeSingle();

      final bool isFirstUpdate =
          profile == null ||
              profile['receiver_full_name'] == null ||
              profile['receiver_full_name'].toString().isEmpty;

      debugPrint("ℹ️ First update: $isFirstUpdate");

      // ================= UPDATE PROFILE =================
      debugPrint("💾 Updating profiles");

      await supabase.from('profiles').update({
        'receiver_full_name': receiverNameCtrl.text.trim(),
        'iban': ibanCtrl.text.trim(),
        'bic': bicCtrl.text.trim(),
        'bank_name': bankNameCtrl.text.trim(),
        'bank_address': bankAddressCtrl.text.trim(),
      }).eq('firebase_uid', firebaseUid);

      debugPrint("✅ profiles updated");

      // ================= UPDATE LOAN =================
      if (isFirstUpdate) {
        debugPrint("💾 Updating loan_requests");

        await supabase
            .from('loan_requests')
            .update({'my_details_bank': true})
            .eq('firebase_uid', firebaseUid);

        debugPrint("✅ loan_requests updated");

        // ================= CALL EDGE FUNCTION WITH FIREBASE TOKEN =================
        debugPrint("🔥 CALLING EDGE FUNCTION remind_next_payment");

        final edgeTimer = Stopwatch()..start();

        // Récupère le token Firebase actuel
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception("User not logged in");
        final idToken = await user.getIdToken();

        // Appel via http
        final uri = Uri.parse(
          "https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/remind_next_payment",
        );
        final response = await http.post(
          uri,
          headers: {
            "Content-Type": "application/json",
            "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          },
          body: jsonEncode({"firebase_uid": firebaseUid}),
        );

        edgeTimer.stop();

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          debugPrint(
            "✅ EDGE SUCCESS (${edgeTimer.elapsedMilliseconds} ms)",
          );
          debugPrint("📦 EDGE DATA: $data");
        } else {
          debugPrint(
            "❌ EDGE ERROR (${response.statusCode}): ${response.body}",
          );
          throw Exception(
              "Edge Function failed with status ${response.statusCode}");
        }
      }

      debugPrint(
        "🏁 DONE in ${stopwatch.elapsedMilliseconds} ms",
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Coordonnées bancaires enregistrées avec succès"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stack) {
      debugPrint("🔥 ERROR in _saveBankDetails");
      debugPrint("❌ $e");
      debugPrint("📌 STACKTRACE:\n$stack");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Une erreur est survenue : ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      stopwatch.stop();
      if (mounted) setState(() => loading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vos coordonnées bancaires"),
      ),
      body: initialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Informations du compte bancaire",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _field(
                controller: receiverNameCtrl,
                label: "Nom complet du receveur",
                validator: _required,
              ),

              _field(
                controller: ibanCtrl,
                label: "IBAN",
                validator: _required,
              ),

              _field(
                controller: bicCtrl,
                label: "BIC / SWIFT",
                validator: _required,
              ),

              _field(
                controller: bankNameCtrl,
                label: "Nom de la banque",
                validator: _required,
              ),

              _field(
                controller: bankAddressCtrl,
                label: "Adresse de la banque",
                maxLines: 2,
                validator: _required,
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: loading ? null : _saveBankDetails,
                icon: const Icon(Icons.save),
                label: loading
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text("Enregistrer"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================
  Widget _field({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Champ requis";
    }
    return null;
  }
}
