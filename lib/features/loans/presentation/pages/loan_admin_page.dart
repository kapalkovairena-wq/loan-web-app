import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoanAdminPage extends StatefulWidget {
  const LoanAdminPage({super.key});

  @override
  State<LoanAdminPage> createState() => _LoanAdminPageState();
}

class _LoanAdminPageState extends State<LoanAdminPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> requests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    setState(() => loading = true);
    try {
      final data = await supabase
          .from('loan_requests')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        requests = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement : $e")),
      );
    }
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      await supabase.from('loan_requests').update({
        'loan_status': status,
      }).eq('id', id);

      setState(() {
        requests = requests.map((r) {
          if (r['id'] == id) r['loan_status'] = status;
          return r;
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Demande $status avec succès !")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise à jour : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administration des prêts"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(child: Text("Aucune demande trouvée"))
          : RefreshIndicator(
        onRefresh: fetchRequests,
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: requests.length,
          itemBuilder: (context, i) {
            final req = requests[i];
            return _loanCard(req);
          },
        ),
      ),
    );
  }

  Widget _loanCard(Map<String, dynamic> data) {
    Color statusColor = Colors.orange;
    String statusText = "En cours";

    if (data['loan_status'] == 'approved') {
      statusColor = Colors.green;
      statusText = "Approuvé";
    } else if (data['loan_status'] == 'rejected') {
      statusColor = Colors.red;
      statusText = "Refusé";
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    data['full_name'] ?? "—",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Text("Email: ${data['email'] ?? '—'}"),
            Text("Téléphone: ${data['phone'] ?? '—'}"),
            Text("Montant: ${data['amount'] ?? '—'} FCFA"),
            Text("Durée: ${data['duration_months'] ?? '—'} mois"),
            Text("Date: ${data['created_at']?.toString().split('T').first ?? '—'}"),

            const Divider(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (data['loan_status'] == 'pending') ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => updateStatus(data['id'].toString(), 'approved'),
                    child: const Text("Approuver"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => updateStatus(data['id'].toString(), 'rejected'),
                    child: const Text("Refuser"),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
