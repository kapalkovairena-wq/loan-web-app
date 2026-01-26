import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    // On récupère l'ancien profil pour savoir si c'est la première mise à jour
    final profile = await supabase
        .from('profiles')
        .select('receiver_full_name')
        .eq('firebase_uid', firebaseUid)
        .maybeSingle();

    final bool isFirstUpdate = (profile != null && (profile['receiver_full_name'] == null || profile['receiver_full_name'] == ''));

    // ========== UPDATE PROFILES ==========
    await supabase.from('profiles').update({
      'receiver_full_name': receiverNameCtrl.text.trim(),
      'iban': ibanCtrl.text.trim(),
      'bic': bicCtrl.text.trim(),
      'bank_name': bankNameCtrl.text.trim(),
      'bank_address': bankAddressCtrl.text.trim(),
    }).eq('firebase_uid', firebaseUid);

    // ========== UPDATE loan_requests si première mise à jour ==========
    if (isFirstUpdate) {
      await supabase.from('loan_requests').update({
        'my_details_bank': true,
      }).eq('firebase_uid', firebaseUid);

// 🔥 EDGE FUNCTION — RAPPEL PAIEMENT
    await supabase.functions.invoke(
      'remind_next_payment',
      body: {
        'firebase_uid': firebaseUid,
      },
      headers: {
        "Content-Type": "application/json",
        "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
        "x-edge-secret": "Mahugnon23",
      },
    );
    }


    setState(() => loading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Coordonnées bancaires enregistrées avec succès"),
          backgroundColor: Colors.green,
        ),
      );
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
