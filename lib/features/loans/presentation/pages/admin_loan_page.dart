import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:typed_data';

class AdminLoanPage extends StatefulWidget {
  const AdminLoanPage({super.key});

  @override
  State<AdminLoanPage> createState() => _AdminLoanPageState();
}

class _AdminLoanPageState extends State<AdminLoanPage> {
  final supabase = Supabase.instance.client;
  List<dynamic> allRequests = [];
  List<dynamic> filteredRequests = [];

  String selectedStatus = "all";
  String selectedCountry = "all";
  String searchQuery = "";

  List<String> statusOptions = ["all", "pending", "approved", "rejected"];
  List<String> countryOptions = ["all"];

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final data = await supabase
        .from('loan_requests')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      allRequests = data;
      filteredRequests = data;

      final countries = data.map((e) => e['country'] as String?).toSet();
      countryOptions = ["all", ...countries.where((e) => e != null).cast<String>()];
    });
  }

  void applyFilters() {
    List<dynamic> tmp = allRequests;

    if (selectedStatus != "all") {
      tmp = tmp.where((e) => e['loan_status'] == selectedStatus).toList();
    }
    if (selectedCountry != "all") {
      tmp = tmp.where((e) => e['country'] == selectedCountry).toList();
    }
    if (startDate != null) {
      tmp = tmp.where((e) => DateTime.parse(e['created_at']).isAfter(startDate!)).toList();
    }
    if (endDate != null) {
      tmp = tmp.where((e) => DateTime.parse(e['created_at']).isBefore(endDate!)).toList();
    }
    if (searchQuery.isNotEmpty) {
      tmp = tmp.where((e) =>
      (e['full_name'] as String)
          .toLowerCase()
          .contains(searchQuery.toLowerCase()) ||
          (e['email'] as String)
              .toLowerCase()
              .contains(searchQuery.toLowerCase())).toList();
    }

    setState(() => filteredRequests = tmp);
  }


  Future<void> sendContract(Map<String, dynamic> data) async {
    try {
      // ================= PDF =================
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(32),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "CONTRAT DE PRÊT",
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  pw.Text("Client :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(data['full_name']),
                  pw.Text(data['email']),
                  pw.SizedBox(height: 16),

                  pw.Text("Détails du prêt :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Montant : ${data['amount']} FCFA"),
                  pw.Text("Durée : ${data['duration_months']} mois"),
                  pw.Text("Taux annuel : 3 %"),
                  pw.SizedBox(height: 16),

                  pw.Text("Conditions générales :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    "• Le remboursement doit être effectué selon l’échéancier.\n"
                        "• Aucun frais d’assurance.\n"
                        "• Tout retard peut entraîner des mesures contractuelles.\n",
                  ),

                  pw.Spacer(),

                  pw.Divider(),
                  pw.Text(
                    "KreditSch © ${DateTime.now().year}",
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            );
          },
        ),
      );

      Uint8List pdfBytes = await pdf.save();
      final pdfBase64 = base64Encode(pdfBytes);

      // ================= CALL EDGE FUNCTION =================
      final response = await http.post(
        Uri.parse('https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/send_contract_pdf'),
        headers: {
          'Content-Type': 'application/json',
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
        },
        body: jsonEncode({
          "clientName": data['full_name'],
          "clientEmail": data['email'],
          "pdfBase64": pdfBase64,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Contrat envoyé avec succès")),
        );
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erreur : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Admin - Gestion des demandes"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          // ===== FILTER BAR =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: "Statut",
                      border: OutlineInputBorder(),
                    ),
                    items: statusOptions
                        .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s == "all"
                          ? "Tous"
                          : s == "pending"
                          ? "En cours"
                          : s == "approved"
                          ? "Approuvée"
                          : "Refusée"),
                    ))
                        .toList(),
                    onChanged: (v) {
                      selectedStatus = v!;
                      applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCountry,
                    decoration: const InputDecoration(
                      labelText: "Pays",
                      border: OutlineInputBorder(),
                    ),
                    items: countryOptions
                        .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c == "all" ? "Tous" : c),
                    ))
                        .toList(),
                    onChanged: (v) {
                      selectedCountry = v!;
                      applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Recherche",
                      border: OutlineInputBorder(),
                      hintText: "Nom ou email",
                    ),
                    onChanged: (v) {
                      searchQuery = v;
                      applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ===== REQUEST LIST =====
          Expanded(
            child: filteredRequests.isEmpty
                ? const Center(child: Text("Aucune demande trouvée"))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredRequests.length,
              itemBuilder: (_, i) => _loanCard(filteredRequests[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loanCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          data['full_name'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email: ${data['email']}"),
            Text("Montant: ${data['amount']} FCFA"),
            Text("Durée: ${data['duration_months']} mois"),
            Text("Pays: ${data['country']}"),
            const SizedBox(height: 6),
            _statusBadge(data['loan_status']),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _showDetailsDialog(data),
        ),
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
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showDetailsDialog(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Détails - ${data['full_name']}"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _section("Informations personnelles", {
                "Email": data['email'],
                "Téléphone": data['phone'],
                "Adresse": data['address'],
                "Ville": data['city'],
                "Pays": data['country'],
              }),
              _section("Informations financières", {
                "Montant demandé": "${data['amount']} FCFA",
                "Durée": "${data['duration_months']} mois",
                "Source revenus": data['income_source'],
                "Profession": data['profession'],
              }),
              _section("Calculs crédit", {
                "Mensualité": "${data['monthly_payment']} FCFA",
                "Intérêts": "${data['total_interest']} FCFA",
                "Total à rembourser": "${data['total_amount']} FCFA",
              }),
              const SizedBox(height: 12),
              const Text("Documents soumis", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  _documentPreview("Pièce identité", data['identity_document_url']),
                  const SizedBox(width: 8),
                  _documentPreview("Justificatif domicile", data['address_proof_url']),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () => sendContract(data),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Envoyer contrat PDF", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fermer")),
        ],
      ),
    );
  }

  Widget _section(String title, Map<String, String> values) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...values.entries.map((e) => Text("${e.key}: ${e.value}")),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _documentPreview(String title, String url) {
    return Expanded(
      child: InkWell(
        onTap: () => _openDocument(context, title, url),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.insert_drive_file),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDocument(BuildContext context, String title, String url) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // ===== CONTENT =====
            Expanded(
              child: InteractiveViewer(
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                  const Center(child: Text("Impossible d'afficher le document")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
