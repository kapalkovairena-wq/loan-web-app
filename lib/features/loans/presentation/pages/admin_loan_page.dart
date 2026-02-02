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

      final dateOfRequest = DateTime.parse(loanData['created_at']);
      final dateOfPayment = dateOfRequest.add(const Duration(days: 15));

      final flagImage = pw.MemoryImage(
        (await rootBundle.load('assets/pdf/flag.png'))
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

      final SigneImage = pw.MemoryImage(
        (await rootBundle.load('assets/pdf/signe.png'))
            .buffer
            .asUint8List(),
      );

      final TimImage = pw.MemoryImage(
        (await rootBundle.load('assets/pdf/tim.png'))
            .buffer
            .asUint8List(),
      );

      final LogoImage = pw.MemoryImage(
        (await rootBundle.load('assets/pdf/logo.png'))
            .buffer
            .asUint8List(),
      );

      final content = await _buildContractContent(
        loanData,
        profileData,
        flagImage,
        justiceImage,
        footerImage,
        SigneImage,
        TimImage,
        LogoImage,
        dateOfPayment,
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(32, 25, 32, 25),
          footer: (context) => pw.Center(
            child: pw.Text(
              'KreditSch © ${DateTime.now().year} - Seite ${context.pageNumber}',
              style: pw.TextStyle(fontSize: 9),
            ),
          ),
          pageTheme: pw.PageTheme(
            buildBackground: (context) {
              return pw.FullPage(
                ignoreMargins: true,
                child: pw.Opacity(
                  opacity: 0.05, // discret
                  child: pw.Image(justiceImage, fit: pw.BoxFit.cover),
                ),
              );
            },
          ),
          build: (context) => content,
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
          "loanRequestId": loanData['id'],
          "firebase_uid": loanData['firebase_uid'],
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

  Future<pw.Font> loadFont(String path) async {
    final data = await rootBundle.load(path);
    return pw.Font.ttf(data);
  }


  Future<List<pw.Widget>> _buildContractContent(
      Map<String, dynamic> loanData,
      Map<String, dynamic> profileData,
      pw.ImageProvider flagImage,
      pw.ImageProvider justiceImage,
      pw.ImageProvider footerImage,
      pw.ImageProvider SigneImage,
      pw.ImageProvider TimImage,
      pw.ImageProvider LogoImage,
      DateTime dateOfPayment,
      ) async {
    final crimsonRegular =
        await loadFont('assets/fonts/CrimsonText-Regular.ttf');

    final crimsonBold =
        await loadFont('assets/fonts/CrimsonText-Bold.ttf');

    final crimsonItalic =
        await loadFont('assets/fonts/CrimsonText-Italic.ttf');

    final crimsonBoldItalic =
        await loadFont('assets/fonts/CrimsonText-BoldItalic.ttf');

    final baseStyle = pw.TextStyle(
      font: crimsonRegular,
      fontSize: 11,
    );

    final titleStyle = pw.TextStyle(
      font: crimsonBold,
      fontSize: 12,
    );

    final titleStyle2 = pw.TextStyle(
      font: crimsonBold,
      fontSize: 15,
    );

    final headerTitleStyle = pw.TextStyle(
      font: crimsonBold,
      fontSize: 20,
    );

    final subtitleStyle = pw.TextStyle(
      font: crimsonItalic,
      fontSize: 15,
    );

    final smallItalicStyle = pw.TextStyle(
      font: crimsonItalic,
      fontSize: 12,
    );

    final startMonth = DateTime(dateOfPayment.year, dateOfPayment.month + 1, 5);
    final now = DateTime.now();

    return [
      // ===== HEADER =====
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(LogoImage, height: 60),
          pw.Image(flagImage, height: 40),
        ],
      ),

      pw.SizedBox(height: 10),
      pw.Divider(),

      pw.Center(
        child: pw.Column(
          children: [
            pw.Text(
              'PRIVATER DARLEHENSVERTRAG',
              style: headerTitleStyle,
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              'Gemäß Bürgerliches Gesetzbuch (BGB)',
              style: subtitleStyle,
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              'Dieser Vertrag unterliegt dem deutschen Recht (§ 488 BGB).',
              style: smallItalicStyle,
            ),
          ],
        ),
      ),

      pw.SizedBox(height: 16),
      pw.Divider(),

      // ================= PARTIES =================
      pw.Center(
        child: pw.Column(
          children: [
            pw.Text('Zwischen den Unterzeichnenden:', style: titleStyle2),
          ],
        ),
      ),

      pw.SizedBox(height: 10),

    pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      _article('Der Darlehensgeber',
          "Vor- und Nachname: Frau NICOLE ASTRID\n"
              "Anschrift: Linienstraße 213, 10119 Berlin, Deutschland\n"
              "Telefonnummer: +49 1577 4851991\n\n"
              "Nachfolgend Darlehensgeber genannt",
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Der Darlehensnehmer',
         'Vor- und Nachname: Herr/Frau ${loanData['full_name']}\n'
             'Anschrift: ${loanData['address']}, ${loanData['city'] ?? ''}, ${loanData['country']}\n'
             'E-Mail: ${loanData['email']}\n'
             'Telefonnummer: ${loanData['phone']}\n\n'
             "Nachfolgend Darlehensnehmer genannt",
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),
    ],
    ),
      pw.SizedBox(height: 16),
      pw.Divider(),

      _article('Präambel',
          '__Der Darlehensgeber erklärt sich bereit, dem Darlehensnehmer ein privates Darlehen zu gewähren, und der Darlehensnehmer erklärt sich bereit, dieses Darlehen zu den nachstehenden Bedingungen anzunehmen, gemäß den Bestimmungen der §§ 488 ff. des Bürgerlichen Gesetzbuches (BGB).__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      pw.SizedBox(height: 16),
      pw.Divider(),

      // ================= ARTICLES =================
      _article('Artikel 1 - Vertragsgegenstand',
          '__Gegenstand dieses Vertrages ist die Gewährung eines privaten Gelddarlehens durch den Darlehensgeber an den Darlehensnehmer, welches der Darlehensnehmer gemäß den nachfolgenden Bestimmungen zurückzuzahlen verpflichtet ist.__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 2 - Darlehensbetrag',
          '__Der Darlehensgeber gewährt dem Darlehensnehmer ein Darlehen in Höhe von:__\n'
          '__Darlehensbetrag: ${loanData['amount']} ${profileData['currency'] ?? 'EUR'}__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 3 - Auszahlung des Darlehens',
          '__Die Auszahlung des Darlehens erfolgt durch Banküberweisung.__\n'
          '__Auszahlungsdatum: ${dateOfPayment.toLocal().toIso8601String().split('T').first}__\n\n'
          '__Die Zahlungen erfolgen auf folgendes Konto des Darlehensnehmer:__\n'
          '__IBAN: ${profileData['iban']}__\n'
          '__BIC: ${profileData['bic']}__\n'
          '__Name der Bank: ${profileData['bank_name']}__\n'
          '__Bankadresse: ${profileData['bank_address']}__\n',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 4 - Laufzeit des Darlehens',
          '__Laufzeit: ${loanData['duration_months']} Monate.__\n'
              '__Beginn: ${dateOfPayment.toLocal().toIso8601String().split('T').first}__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 5 - Zinssatz',
          '__Verzinsliches Darlehen__\n'
          '__Jährlicher Zinssatz: 3 %.__\n'
          '__Die Zinsen werden auf den jeweils verbleibenden Darlehenssaldo berechnet.__\n'
          '__Der Zinssatz entspricht den Vorschriften zur Sittenwidrigkeit und zum Wucher gemäß § 138 BGB.__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 6 - Rückzahlungsmodalitäten',
      '__Die Rückzahlung erfolgt wie folgt:__\n'
          '__- Monatliche Raten__\n'
          '__- Höhe jeder Rate: ${loanData['monthly_payment']} ${profileData['currency'] ?? 'EUR'}__\n'
          '__Zahlungstermin: jeweils am 5 eines Monats__\n'
          '__Beginn : ${startMonth.toLocal().toIso8601String().split('T').first}__\n\n'
        'Die Zahlungen erfolgen auf das Konto des aktuell zuständigen Kundendienstes, der Sie während des laufenden Vorgangs betreut und die jeweilige Transaktion überprüft.\n'
        "Die entsprechenden Zahlungsinformationen sind im Dashboard unserer Website https://www.kreditsch.de abrufbar.",
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 7 - Vorzeitige Rückzahlung',
          '__Gemäß § 500 BGB ist der Darlehensnehmer berechtigt, das Darlehen jederzeit ganz oder teilweise vorzeitig zurückzuzahlen, ohne dass hierfür eine Vorfälligkeitsentschädigung anfällt, sofern nichts anderes schriftlich vereinbart wurde.__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 8 - Zahlungsverzug',
          '__Im Falle des Zahlungsverzugs:__\n'
          '__- können Verzugszinsen gemäß § 288 BGB erhoben werden;__\n'
          '__ist der Darlehensgeber berechtigt, die sofortige Rückzahlung des gesamten noch offenen Darlehensbetrages zu verlangen.__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 9 - Sicherheiten',
          '__Zur Sicherung der Rückzahlung stellt der Darlehensnehmer folgende Sicherheiten:__\n'
          '__Keine Sicherheiten__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 10 - Bonitätserklärung',
          '__Der Darlehensnehmer erklärt:__\n'
          '__- rechtlich voll geschäftsfähig zu sein;__\n'
          '__- sich nicht in einer Situation der Überschuldung zu befinden;__\n'
          '__- sämtliche Angaben wahrheitsgemäß gemacht zu haben.__\n'
          '__Jede falsche Erklärung kann zur sofortigen Kündigung dieses Vertrages führen.__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 11 - Vertraulichkeit',
          '__Die Vertragsparteien verpflichten sich, sämtliche Informationen im Zusammenhang mit diesem Vertrag vertraulich zu behandeln, sofern keine gesetzliche Offenlegungspflicht besteht.__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 12 - Anwendbares Recht',
          '__Dieser Vertrag unterliegt ausschließlich dem Recht der Bundesrepublik Deutschland, insbesondere den Bestimmungen des Bürgerlichen Gesetzbuches (BGB).__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 13 - Gerichtsstand',
          '__Für alle Streitigkeiten aus oder im Zusammenhang mit diesem Vertrag ist - soweit gesetzlich zulässig - ausschließlich das für den Wohnsitz des Darlehensgebers zuständige Gericht zuständig.__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      _article('Artikel 14 - Schlussbestimmungen',
          '__Sollte eine Bestimmung dieses Vertrages ganz oder teilweise unwirksam sein oder werden, bleibt die Wirksamkeit der übrigen Bestimmungen unberührt (§ 306 BGB).__\n'
          '__Dieser Vertrag wird in zwei gleichlautenden Originalausfertigungen erstellt, eine für jede Vertragspartei.__',
        titleStyle: titleStyle,
        normalStyle: baseStyle,
        boldFont: crimsonBold,
        italicFont: crimsonItalic,
        boldItalicFont: crimsonBoldItalic,
      ),

      pw.SizedBox(height: 40),

      // ================= SIGNATURES =================
      pw.Divider(),
      pw.Image(TimImage, height: 150),
      pw.SizedBox(height: 10),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Darlehensgeber'),
          pw.Image(footerImage, height: 40),
          pw.Text('Darlehensnehmer'),
        ],
      ),

      pw.SizedBox(height: 10),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(SigneImage, height: 80),
          pw.Text(''),
          pw.Text(''),
        ],
      ),

      pw.SizedBox(height: 10),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Frau NICOLE ASTRID', style: titleStyle2),
          pw.Text('Herr/Frau ${loanData['full_name']}', style: titleStyle2),
        ],
      ),

      pw.SizedBox(height: 40),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(''),
          pw.Text('Berlin, ${now.toLocal().toIso8601String().split('T').first}'),
        ],
      ),
    ];
  }

  pw.Widget _article(
      String title,
      String content, {
        required pw.TextStyle titleStyle,
        required pw.TextStyle normalStyle,
        required pw.Font boldFont,
        required pw.Font italicFont,
        required pw.Font boldItalicFont,
      }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 8),

        // Titre
        pw.Text(
          title,
          style: titleStyle,
        ),

        pw.SizedBox(height: 4),

        // Contenu formaté
        pw.RichText(
          text: pw.TextSpan(
            children: parseFormattedText(
              content,
              normalStyle: normalStyle,
              boldFont: boldFont,
              italicFont: italicFont,
              boldItalicFont: boldItalicFont,
            ),
          ),
        ),
      ],
    );
  }

  List<pw.TextSpan> parseFormattedText(
      String text, {
        required pw.TextStyle normalStyle,
        required pw.Font boldFont,
        required pw.Font italicFont,
        required pw.Font boldItalicFont,
      }) {
    final spans = <pw.TextSpan>[];

    final regex = RegExp(
      r'\*\*\*(.+?)\*\*\*|\*\*(.+?)\*\*|__(.+?)__',
      dotAll: true,
    );

    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      // Texte normal avant
      if (match.start > lastIndex) {
        spans.add(
          pw.TextSpan(
            text: text.substring(lastIndex, match.start),
            style: normalStyle,
          ),
        );
      }

      // *** GRAS + ITALIQUE ***
      if (match.group(1) != null) {
        spans.add(
          pw.TextSpan(
            text: match.group(1),
            style: normalStyle.copyWith(font: boldItalicFont),
          ),
        );
      }

      // ** GRAS **
      else if (match.group(2) != null) {
        spans.add(
          pw.TextSpan(
            text: match.group(2),
            style: normalStyle.copyWith(font: boldFont),
          ),
        );
      }

      // __ ITALIQUE __
      else if (match.group(3) != null) {
        spans.add(
          pw.TextSpan(
            text: match.group(3),
            style: normalStyle.copyWith(font: italicFont),
          ),
        );
      }

      lastIndex = match.end;
    }

    // Texte restant
    if (lastIndex < text.length) {
      spans.add(
        pw.TextSpan(
          text: text.substring(lastIndex),
          style: normalStyle,
        ),
      );
    }

    return spans;
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

  void _showSetPaymentDialog(
      BuildContext context,
      String firebaseUid,
      dynamic currentPayment,
      ) {
    final controller = TextEditingController(
      text: currentPayment != null ? currentPayment.toString() : "",
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Définir le montant de paiement"),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: "Montant",
            suffixText: "EUR",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final value = double.tryParse(controller.text.trim());

              if (value == null || value <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("❌ Montant invalide"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // ===== UPDATE PROFILE =====
              await supabase
                  .from('profiles')
                  .update({'payment': value})
                  .eq('firebase_uid', firebaseUid);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("✅ Montant défini : $value EUR"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Enregistrer"),
          ),
        ],
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
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.euro),
                      label: const Text("Définir le montant de paiement"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _showSetPaymentDialog(
                          context,
                          loanData['firebase_uid'],
                          profile?['payment'],
                        );
                      },
                    ),

                    // ===== Payment Bank Toggle =====
                    FutureBuilder<Map<String, dynamic>?>(
                      future: supabase
                          .from('loan_requests')
                          .select('payment_bank')
                          .eq('id', loanData['id'])
                          .maybeSingle(),
                      builder: (context, snapshot) {
                        bool paymentBank = snapshot.data?['payment_bank'] ?? false;
                        if (!snapshot.hasData) return const SizedBox();

                        return SwitchListTile(
                          title: const Text("Coordonnées de paiement"),
                          value: paymentBank,
                          onChanged: (val) async {
                            // Met à jour dans la table loan_requests
                            await supabase
                                .from('loan_requests')
                                .update({'payment_bank': val})
                                .eq('id', loanData['id']);

                            setState(() {
                              // Met à jour localement pour refléter le changement
                              loanData['payment_bank'] = val;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  val
                                      ? "✅ Coordonnées de paiement activées"
                                      : "❌ Coordonnées de paiement désactivées",
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // ===== Document Toggle =====
                    FutureBuilder<Map<String, dynamic>?>(
                      future: supabase
                          .from('loan_requests')
                          .select('document')
                          .eq('id', loanData['id'])
                          .maybeSingle(),
                      builder: (context, snapshot) {
                        bool paymentBank = snapshot.data?['document'] ?? false;
                        if (!snapshot.hasData) return const SizedBox();

                        return SwitchListTile(
                          title: const Text("Afficher l'importation de document"),
                          value: paymentBank,
                          onChanged: (val) async {
                            // Met à jour dans la table loan_requests
                            await supabase
                                .from('loan_requests')
                                .update({'document': val})
                                .eq('id', loanData['id']);

                            setState(() {
                              // Met à jour localement pour refléter le changement
                              loanData['document'] = val;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  val
                                      ? "✅ Affichage de l'importation de document activé"
                                      : "❌ Affichage de l'importation de document désactivé",
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // ===== Envoyer contrat PDF =====
                    ElevatedButton(
                      onPressed: () => sendContract(loanData, profile ?? {}),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text(
                        "Envoyer contrat PDF",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
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
