import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

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

  Future<void> sendContract(Map<String, dynamic> loanData, Map<String, dynamic> profileData) async {
    try {
      final pdf = pw.Document();

      final now = DateTime.now();
      final dateOfRequest = DateTime.parse(loanData['created_at']);
      final dateOfPayment = dateOfRequest.add(const Duration(days: 15));
      final startMonth = DateTime(dateOfPayment.year, dateOfPayment.month + 1, 5);

      final flagImage = pw.MemoryImage(
        (await rootBundle.load('assets/pdf/germany_flag.png'))
            .buffer
            .asUint8List(),
      );

      final justiceImage = pw.MemoryImage(
        (await rootBundle.load('assets/pdf/justice_balance.png'))
            .buffer
            .asUint8List(),
      );

      final footerImage = pw.MemoryImage(
        (await rootBundle.load('assets/pdf/courthouse_footer.png'))
            .buffer
            .asUint8List(),
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          footer: (context) => pw.Center(
            child: pw.Text(
              'KreditSch © ${DateTime.now().year} — Page ${context.pageNumber}',
              style: pw.TextStyle(fontSize: 9),
            ),
          ),
          build: (context) => [
            ..._buildContractContent(
              loanData,
              profileData,
              flagImage,
              justiceImage,
              footerImage,
              dateOfPayment,
            ),
          ],
        ),
      );

      Uint8List pdfBytes = await pdf.save();
      final pdfBase64 = base64Encode(pdfBytes);

      final response = await http.post(
        Uri.parse('https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/send_contract_pdf'),
        headers: {
          'Content-Type': 'application/json',
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
        },
        body: jsonEncode({
          "clientName": loanData['full_name'],
          "clientEmail": loanData['email'],
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

  List<pw.Widget> _buildContractContent(
      Map<String, dynamic> loanData,
      Map<String, dynamic> profileData,
      pw.ImageProvider flagImage,
      pw.ImageProvider justiceImage,
      pw.ImageProvider footerImage,
      DateTime dateOfPayment,
      ) {
    return [
      // ===== HEADER =====
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(flagImage, height: 40),
          pw.Image(justiceImage, height: 40),
        ],
      ),

      pw.SizedBox(height: 10),
      pw.Divider(),

      pw.Center(
        child: pw.Column(
          children: [
            pw.Text(
              'PRIVATER DARLEHENSVERTRAG',
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              'Gemäß Bürgerliches Gesetzbuch (BGB)',
              style: pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              'Dieser Vertrag unterliegt dem deutschen Recht (§ 488 BGB).',
              style: pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),

      pw.SizedBox(height: 16),
      pw.Divider(),

      // ================= PARTIES =================
      pw.Text('Zwischen den Unterzeichnenden:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

      pw.SizedBox(height: 10),

      pw.Text('Der Darlehensgeber'),
      pw.Text('Name: ${profileData['receiver_full_name'] ?? ''}'),
      pw.Text('Email: ${profileData['email']}'),
      pw.Text('IBAN: ${profileData['iban'] ?? ''}'),
      pw.Text('BIC: ${profileData['bic'] ?? ''}'),

      pw.SizedBox(height: 10),

      pw.Text('Der Darlehensnehmer'),
      pw.Text('Name: ${loanData['full_name']}'),
      pw.Text('Adresse: ${loanData['address']}, ${loanData['city'] ?? ''}, ${loanData['country']}'),
      pw.Text('Email: ${loanData['email']}'),
      pw.Text('Téléphone: ${loanData['phone']}'),

      pw.SizedBox(height: 16),
      pw.Divider(),

      // ================= ARTICLES =================
      _article('Artikel 1 – Objekt',
          'Dieses Vertragsziel ist die Gewährung eines privaten Darlehens.'
      ),

      _article('Artikel 2 – Darlehensbetrag',
          'Darlehensbetrag: ${loanData['amount']} EUR'
      ),

      _article('Artikel 3 – Auszahlung',
          'Auszahlung per Banküberweisung am ${dateOfPayment.toLocal().toString().split(" ").first}.'
      ),

      _article('Artikel 4 – Laufzeit',
          'Dauer: ${loanData['duration_months']} Monate.'
      ),

      _article('Artikel 5 – Zinssatz',
          'Jährlicher Zinssatz: ${loanData['annual_rate'] ?? 3} %.'
      ),

      _article('Artikel 6 – Rückzahlung',
          'Monatliche Zahlung am 5. jedes Monats.'
      ),

      _article('Artikel 7 – Vorzeitige Rückzahlung',
          'Gemäß § 500 BGB ohne Strafgebühren.'
      ),

      _article('Artikel 8 – Zahlungsverzug',
          'Verzugszinsen gemäß § 288 BGB.'
      ),

      _article('Artikel 9 – Garantien',
          'Keine Garantie vereinbart.'
      ),

      _article('Artikel 10 – Solvenzerklärung',
          'Der Darlehensnehmer erklärt zahlungsfähig zu sein.'
      ),

      _article('Artikel 11 – Vertraulichkeit',
          'Alle Vertragsinformationen bleiben vertraulich.'
      ),

      _article('Artikel 12 – Anwendbares Recht',
          'Ausschließlich deutsches Recht.'
      ),

      _article('Artikel 13 – Gerichtsstand',
          'Gerichtsstand ist der Wohnsitz des Darlehensgebers.'
      ),

      _article('Artikel 14 – Schlussbestimmungen',
          'Der Vertrag wird in zwei Originalen erstellt.'
      ),

      pw.Spacer(),

      // ================= SIGNATURES =================
      pw.Divider(),
      pw.Text('Ort, Datum: ________________________'),
      pw.SizedBox(height: 24),

      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Darlehensgeber\n______________________'),
          pw.Image(footerImage, height: 40),
          pw.Text('Darlehensnehmer\n______________________'),
        ],
      ),
    ];
  }

  pw.Widget _article(String title, String content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 8),
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text(content),
      ],
    );
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
            Text("Montant: ${data['amount']}"),
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

  void _showDetailsDialog(Map<String, dynamic> loanData) async {
    final profile = await supabase
        .from('profiles')
        .select()
        .eq('firebase_uid', loanData['firebase_uid'])
        .single() as Map<String, dynamic>?;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Détails - ${loanData['full_name']}"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _section("Informations personnelles", {
                "Email": loanData['email'],
                "Téléphone": loanData['phone'],
                "Adresse": loanData['address'],
                "Ville": loanData['city'] ?? "",
                "Pays": loanData['country'] ?? "",
              }),
              _section("Informations financières", {
                "Montant demandé": "${loanData['amount']} ${profile?['currency'] ?? 'EUR'}",
                "Durée": "${loanData['duration_months']} mois",
                "Source revenus": loanData['income_source'] ?? "",
                "Profession": loanData['profession'] ?? "",
              }),
              _section("Calculs crédit", {
                "Mensualité": "${loanData['monthly_payment']} ${profile?['currency'] ?? 'EUR'}",
                "Intérêts": "${loanData['total_interest']} ${profile?['currency'] ?? 'EUR'}",
                "Total à rembourser": "${loanData['total_amount']} ${profile?['currency'] ?? 'EUR'}",
              }),
              const SizedBox(height: 12),
              const Text("Documents soumis", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  _documentPreview("Pièce identité", loanData['identity_document_url']),
                  const SizedBox(width: 8),
                  _documentPreview("Justificatif domicile", loanData['address_proof_url']),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () => sendContract(loanData, profile ?? {}),
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
