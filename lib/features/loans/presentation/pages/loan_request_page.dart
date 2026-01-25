import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../presentation/auth/auth_loan_gate.dart';
import '../widgets/input_field.dart';
import '../widgets/footer_section.dart';
import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../widgets/app_header.dart';
import '../widgets/hero_banner.dart';

class LoanRequestPage extends StatefulWidget {
  const LoanRequestPage({super.key});

  @override
  State<LoanRequestPage> createState() => _LoanRequestPageState();
}

class _LoanRequestPageState extends State<LoanRequestPage> {
  Map<String, dynamic> profileData = {};
  bool isLoadingProfile = true;

  // ===== Controllers =====
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();

  final amountController = TextEditingController();
  final durationController = TextEditingController();
  final incomeController = TextEditingController();
  final professionController = TextEditingController();

  // ===== Files (WEB SAFE) =====
  Uint8List? identityBytes;
  Uint8List? addressBytes;

  String? identityFileName;
  String? addressFileName;

  // ===== Credit parameters =====
  final double annualRate = 0.03; // 3%

  double calculateInterest(double amount, int months) =>
      amount * annualRate * (months / 12);

  double calculateTotal(double amount, int months) =>
      amount + calculateInterest(amount, months);

  double calculateMonthly(double amount, int months) =>
      calculateTotal(amount, months) / months;

  // ===== Pick file =====
  Future<void> pickFile(bool isIdentity) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        if (isIdentity) {
          identityBytes = result.files.single.bytes!;
          identityFileName = result.files.single.name;
        } else {
          addressBytes = result.files.single.bytes!;
          addressFileName = result.files.single.name;
        }
      });
    }
  }

  // ===== Upload Supabase =====
  Future<String> uploadBytes({
    required Uint8List bytes,
    required String bucket,
    required String path,
  }) async {
    final supabase = Supabase.instance.client;

    await supabase.storage.from(bucket).uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

    return supabase.storage.from(bucket).getPublicUrl(path);
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();

    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthLoanGate()),
        );
      });
    }
  }

  Future<void> _loadProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    // Utilisateur non connecté
    if (firebaseUser == null) {
      setState(() {
        profileData = {'currency': '€'};
        isLoadingProfile = false;
      });
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('currency, language')
          .eq('firebase_uid', firebaseUser.uid)
          .single();

      setState(() {
        profileData = response;
        isLoadingProfile = false;
      });
    } catch (e) {
      // fallback sécurité
      setState(() {
        profileData = {'currency': '€'};
        isLoadingProfile = false;
      });
    }
  }

  String get currency {
    final c = profileData['currency'];
    if (c == null || c.toString().isEmpty) return '€';
    return c;
  }


  @override
  Widget build(BuildContext context) {
    if (isLoadingProfile) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF8F9FB),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const AppHeader(),
                const HeroBanner(),
                const SizedBox(height: 80),

                Center(
                  child: Container(
                    width: 900,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Informations personnelles",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),

                        InputField(label: "Nom complet *", hint: "Votre nom complet", controller: nameController),
                        InputField(label: "Email *", hint: "exemple@email.com", controller: emailController),
                        InputField(label: "Téléphone *", hint: "+49 00000000000", controller: phoneController),
                        InputField(label: "Date de naissance", hint: "JJ/MM/AAAA", controller: dobController),
                        InputField(label: "Adresse *", hint: "", controller: addressController),
                        InputField(label: "Ville", hint: "", controller: cityController),
                        InputField(label: "Pays", hint: "", controller: countryController),

                        const SizedBox(height: 20),

                        const Text(
                          "Documents requis",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),

                        _documentUpload(
                          title: "Pièce d'identité (Carte d'identité / Passeport / Permis)",
                          bytes: identityBytes,
                          onTap: () => pickFile(true),
                        ),

                        _documentUpload(
                          title: "Justificatif de domicile",
                          bytes: addressBytes,
                          onTap: () => pickFile(false),
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          "Informations financières",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),

                        InputField(label: "Montant demandé", hint: "", controller: amountController),
                        InputField(label: "Durée (mois)", hint: "", controller: durationController),
                        InputField(label: "Source de revenus", hint: "", controller: incomeController),
                        InputField(label: "Profession", hint: "", controller: professionController),

                        const SizedBox(height: 30),

                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5B400),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                            ),
                            onPressed: submitForm,
                            child: const Text(
                              "Soumettre la demande",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),
                const FooterSection(),
              ],
            ),
          ),

          const WhatsAppButton(
            phoneNumber: "+4915774851991",
            message: "Bonjour, je souhaite plus d'informations sur vos prêts.",
          ),
        ],
      ),
    );
  }

  Widget _documentUpload({
    required String title,
    required Uint8List? bytes,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(
          bytes == null ? Icons.upload_file : Icons.check_circle,
          color: bytes == null ? Colors.grey : Colors.green,
        ),
        title: Text(title),
        subtitle: Text(bytes == null ? "Aucun fichier sélectionné" : "Document ajouté"),
        trailing: TextButton(
          onPressed: onTap,
          child: const Text("Télécharger"),
        ),
      ),
    );
  }

  Future<void> submitForm() async {
    try {
      if (nameController.text.isEmpty ||
          addressController.text.isEmpty ||
          identityBytes == null ||
          addressBytes == null) {
        showError("Veuillez compléter tous les champs obligatoires");
        return;
      }

      final amount = double.tryParse(amountController.text);
      final months = int.tryParse(durationController.text);

      if (amount == null || months == null || amount <= 0 || months <= 0) {
        showError("Montant ou durée invalide");
        return;
      }

      final supabase = Supabase.instance.client;

      final identityUrl = await uploadBytes(
        bytes: identityBytes!,
        bucket: "identity-documents",
        path: "${DateTime.now().millisecondsSinceEpoch}_$identityFileName",
      );

      final addressUrl = await uploadBytes(
        bytes: addressBytes!,
        bucket: "address-documents",
        path: "${DateTime.now().millisecondsSinceEpoch}_$addressFileName",
      );

      final interest = calculateInterest(amount, months);
      final monthly = calculateMonthly(amount, months);
      final total = calculateTotal(amount, months);

      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        showError("Utilisateur non authentifié");
        return;
      }

      await supabase.from("loan_requests").insert({
        "firebase_uid": firebaseUser.uid,
        "full_name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "date_of_birth": dobController.text,
        "address": addressController.text,
        "city": cityController.text,
        "country": countryController.text,
        "amount": amount,
        "duration_months": months,
        "income_source": incomeController.text,
        "profession": professionController.text,
        "annual_rate": 0.03,
        "monthly_payment": monthly,
        "total_interest": interest,
        "total_amount": total,
        "identity_document_url": identityUrl,
        "address_proof_url": addressUrl,
        "loan_status": "pending",
      });

      if (!mounted) return;

      Future<void> triggerEmailFunction({
        required String clientName,
        required String clientEmail,
        required String phone,
        required String dob,
        required String address,
        required String city,
        required String country,
        required double amount,
        required int duration,
        required String income,
        required String profession,
        required double monthlyPayment,
        required double totalInterest,
        required double totalAmount,
        required String identityUrl,
        required String addressUrl,
      }) async {
        final supabase = Supabase.instance.client;

        await supabase.functions.invoke(
          'send_loan_emails',
          body: {
            "clientName": clientName,
            "clientEmail": clientEmail,
            "phone": phone,
            "dob": dob,
            "address": address,
            "city": city,
            "country": country,
            "amount": amount,
            "duration": duration,
            "income": income,
            "profession": profession,
            "monthlyPayment": monthlyPayment,
            "totalInterest": totalInterest,
            "totalAmount": totalAmount,
            "identityUrl": identityUrl,
            "addressUrl": addressUrl,
          },
        );
      }


      // ===== ENVOI MAILS =====
      await triggerEmailFunction(
        clientName: nameController.text,
        clientEmail: emailController.text,
        phone: phoneController.text,
        dob: dobController.text,
        address: addressController.text,
        city: cityController.text,
        country: countryController.text,
        amount: amount,
        duration: months,
        income: incomeController.text,
        profession: professionController.text,
        monthlyPayment: monthly,
        totalInterest: interest,
        totalAmount: total,
        identityUrl: identityUrl,
        addressUrl: addressUrl,
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Demande envoyée avec succès"),
          content: Text(
            "Merci ${nameController.text},\n\n"
                "Montant : ${amount.toStringAsFixed(0)} $currency\n"
                "Durée : $months mois\n"
                "Taux annuel : 3%\n\n"
                "Mensualité : ${monthly.toStringAsFixed(0)} $currency\n"
                "Total mensualités : ${(monthly * months).toStringAsFixed(0)} $currency\n"
                "Total intérêts : ${interest.toStringAsFixed(0)} $currency\n"
                "Total à rembourser : ${total.toStringAsFixed(0)} $currency",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      showError("Erreur lors de l'envoi : $e");
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }
}
