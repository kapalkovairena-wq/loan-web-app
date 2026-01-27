import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPaymentProofsPage extends StatefulWidget {
  const AdminPaymentProofsPage({super.key});

  @override
  State<AdminPaymentProofsPage> createState() =>
      _AdminPaymentProofsPageState();
}

class _AdminPaymentProofsPageState extends State<AdminPaymentProofsPage> {
  final supabase = Supabase.instance.client;

  bool loading = true;
  List<Map<String, dynamic>> proofs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  /* ================= LOAD ================= */
  Future<void> _load() async {
    debugPrint("📥 [ADMIN] Loading pending payment proofs...");

    try {
      final res = await supabase.rpc('get_pending_payment_proofs');

      debugPrint("📦 [ADMIN] RPC result: ${res.length} proofs");

      setState(() {
        proofs = List<Map<String, dynamic>>.from(res);
        loading = false;
      });
    } catch (e, stack) {
      debugPrint("❌ [ADMIN] Failed to load proofs");
      debugPrint("❌ $e");
      debugPrint("📌 $stack");

      setState(() => loading = false);
    }
  }

  /* ================= APPROVE ================= */
  Future<void> _approve(Map proof) async {
    debugPrint("✅ [APPROVE] Start");
    debugPrint("🆔 proof_id=${proof['id']}");
    debugPrint("👤 firebase_uid=${proof['firebase_uid']}");

    try {
      final res = await supabase.functions.invoke(
        'approve_payment_proof',
        headers: {
          "Content-Type": "application/json",
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
        },
        body: {
          'proof_id': proof['id'],
          'firebase_uid': proof['firebase_uid'],
        },
      );

      debugPrint("📡 [APPROVE] Edge status=${res.status}");
      debugPrint("📡 [APPROVE] Edge data=${res.data}");

      if (res.status != 200) {
        throw Exception(res.data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Paiement approuvé"),
            backgroundColor: Colors.green,
          ),
        );
      }

      await _load();
    } catch (e, stack) {
      debugPrint("🔥 [APPROVE] Error");
      debugPrint("❌ $e");
      debugPrint("📌 $stack");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Erreur approbation"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /* ================= REJECT ================= */
  Future<void> _reject(Map proof) async {
    debugPrint("⛔ [REJECT] Start");
    debugPrint("🆔 proof_id=${proof['id']}");

    try {
      final res = await supabase.functions.invoke(
        'reject_payment_proof',
        headers: {
          "Content-Type": "application/json",
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
        },
        body: {
          'proof_id': proof['id'],
        },
      );

      debugPrint("📡 [REJECT] Edge status=${res.status}");
      debugPrint("📡 [REJECT] Edge data=${res.data}");

      if (res.status != 200) {
        throw Exception(res.data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⛔ Paiement rejeté"),
            backgroundColor: Colors.orange,
          ),
        );
      }

      await _load();
    } catch (e, stack) {
      debugPrint("🔥 [REJECT] Error");
      debugPrint("❌ $e");
      debugPrint("📌 $stack");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Erreur rejet"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preuves de paiement"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : proofs.isEmpty
          ? const Center(child: Text("Aucune preuve en attente"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: proofs.length,
        itemBuilder: (_, i) {
          final p = proofs[i];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p['email'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Montant : ${p['amount']} ${p['currency']}",
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Soumis le : ${DateTime.parse(p['created_at']).toLocal()}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    icon: const Icon(Icons.visibility),
                    label: const Text("Voir le document"),
                    onPressed: () async {
                      final uri = Uri.parse(p['file_url']);
                      if (await canLaunchUrl(uri)) {
                        launchUrl(uri);
                      }
                    },
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () => _approve(p),
                          child: const Text("Approuver"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => _reject(p),
                          child: const Text("Rejeter"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
