import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class LoanHistoryPage extends StatefulWidget {
  const LoanHistoryPage({super.key});

  @override
  State<LoanHistoryPage> createState() => _LoanHistoryPageState();
}

class _LoanHistoryPageState extends State<LoanHistoryPage> {
  final supabase = Supabase.instance.client;
  List<dynamic> requests = [];

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final user = supabase.auth.currentUser;

    final data = await supabase
        .from('loan_requests')
        .select()
        .eq('user_id', user!.id)
        .order('created_at', ascending: false);

    setState(() => requests = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Historique des demandes"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: requests.isEmpty
          ? const Center(child: Text("Aucune demande trouvée"))
          : ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: requests.length,
        itemBuilder: (_, i) => _loanCard(requests[i]),
      ),
    );
  }

  Widget _loanCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ===== HEADER =====
            Row(
              children: [
                Expanded(
                  child: Text(
                    data['full_name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _statusBadge(data['loan_status']),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              "Soumise le ${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['created_at']))}",
              style: TextStyle(color: Colors.grey[600]),
            ),

            const Divider(height: 30),

            /// ===== PERSONAL INFO =====
            _section(
              "Informations personnelles",
              {
                "Email": data['email'],
                "Téléphone": data['phone'],
                "Adresse": data['address'],
                "Ville": data['city'],
                "Pays": data['country'],
              },
            ),

            /// ===== FINANCIAL INFO =====
            _section(
              "Informations financières",
              {
                "Profession": data['profession'],
                "Source de revenus": data['income_source'],
                "Montant demandé": "${data['amount']} FCFA",
                "Durée": "${data['duration']} mois",
              },
            ),

            /// ===== CALCUL =====
            _section(
              "Récapitulatif du crédit",
              {
                "Mensualité": "${data['monthly_payment']} FCFA",
                "Intérêts": "${data['interest']} FCFA",
                "Total à rembourser": "${data['total_amount']} FCFA",
              },
            ),

            /// ===== DOCUMENTS =====
            const SizedBox(height: 20),
            const Text(
              "Documents soumis",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _documentPreview(
                  title: "Pièce d'identité",
                  imageUrl: data['identity_document_url'],
                ),
                const SizedBox(width: 16),
                _documentPreview(
                  title: "Justificatif de domicile",
                  imageUrl: data['address_proof_url'],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, Map<String, String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...items.entries.map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(e.key,
                        style: TextStyle(color: Colors.grey[700])),
                  ),
                  Expanded(
                    child: Text(e.value,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentPreview({
    required String title,
    required String imageUrl,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color = Colors.orange;
    String text = "En cours";

    if (status == "approved") {
      color = Colors.green;
      text = "Approuvée";
    } else if (status == "rejected") {
      color = Colors.red;
      text = "Refusée";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
