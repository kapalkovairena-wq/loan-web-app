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

  Future<void> _load() async {
    final res = await supabase.rpc('get_pending_payment_proofs');
    setState(() {
      proofs = List<Map<String, dynamic>>.from(res);
      loading = false;
    });
  }

  Future<void> _approve(Map proof) async {
    await supabase.from('payment_proofs').update({
      'status': 'approved',
      'reviewed_at': DateTime.now().toIso8601String(),
      'reviewed_by': supabase.auth.currentUser?.email,
    }).eq('id', proof['id']);

    await supabase.from('loan_requests').update({
      'payment_bank': true,
      'loan_status': 'paid',
    }).eq('firebase_uid', proof['firebase_uid']);

    _load();
  }

  Future<void> _reject(Map proof) async {
    await supabase.from('payment_proofs').update({
      'status': 'rejected',
      'reviewed_at': DateTime.now().toIso8601String(),
      'reviewed_by': supabase.auth.currentUser?.email,
    }).eq('id', proof['id']);

    _load();
  }

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
