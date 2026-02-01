import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
                        Text(
                          l10n.personalInfoTitle,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),

                        InputField(
                          label: l10n.fullNameLabel,
                          hint: l10n.fullNameHint,
                          controller: nameController,
                        ),
                        InputField(
                          label: l10n.emailLabel,
                          hint: l10n.emailHint,
                          controller: emailController,
                        ),
                        InputField(
                          label: l10n.phoneLabel,
                          hint: l10n.phoneHint,
                          controller: phoneController,
                        ),
                        InputField(
                          label: l10n.dobLabel,
                          hint: l10n.dobHint,
                          controller: dobController,
                        ),
                        InputField(
                          label: l10n.addressLabel,
                          hint: l10n.addressHint,
                          controller: addressController,
                        ),
                        InputField(
                          label: l10n.cityLabel,
                          hint: "",
                          controller: cityController,
                        ),
                        InputField(
                          label: l10n.countryLabel,
                          hint: "",
                          controller: countryController,
                        ),

                        const SizedBox(height: 20),

                        Text(
                          l10n.requiredDocsTitle,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),

                        _documentUpload(
                          title: l10n.identityDoc,
                          bytes: identityBytes,
                          onTap: () => pickFile(true),
                          l10n: l10n,
                        ),

                        _documentUpload(
                          title: l10n.addressProof,
                          bytes: addressBytes,
                          onTap: () => pickFile(false),
                          l10n: l10n,
                        ),

                        const SizedBox(height: 30),

                        Text(
                          l10n.financialInfoTitle,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),

                        InputField(
                          label: l10n.amountLabel,
                          hint: "",
                          controller: amountController,
                        ),
                        InputField(
                          label: l10n.durationLabel,
                          hint: "",
                          controller: durationController,
                        ),
                        InputField(
                          label: l10n.incomeLabel,
                          hint: "",
                          controller: incomeController,
                        ),
                        InputField(
                          label: l10n.professionLabel,
                          hint: "",
                          controller: professionController,
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5B400),
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                            ),
                            onPressed: () => submitForm(l10n),
                            child: Text(
                              l10n.submitRequest,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
    );
  }

  Widget _documentUpload({
    required String title,
    required Uint8List? bytes,
    required VoidCallback onTap,
    required AppLocalizations l10n,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(
          bytes == null ? Icons.upload_file : Icons.check_circle,
          color: bytes == null ? Colors.grey : Colors.green,
        ),
        title: Text(title),
        subtitle: Text(bytes == null ? l10n.noFileSelected : l10n.documentAdded),
        trailing: TextButton(
          onPressed: onTap,
          child: Text(l10n.uploadButton),
        ),
      ),
    );
  }

  Future<void> submitForm(AppLocalizations l10n) async {
    try {
      if (nameController.text.isEmpty ||
          addressController.text.isEmpty ||
          identityBytes == null ||
          addressBytes == null) {
        showError(l10n.fillRequiredFields);
        return;
      }

      final amount = double.tryParse(amountController.text);
      final months = int.tryParse(durationController.text);

      if (amount == null || months == null || amount <= 0 || months <= 0) {
        showError(l10n.invalidAmountOrDuration);
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
        showError(l10n.notAuthenticated);
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
        required String currency,
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
            "currency": currency,
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
        currency: currency,
      );

      final totalPayments = monthly * months;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.requestSuccessTitle),
          content: Text(
            l10n.requestSuccessContent(
              nameController.text,                 // {name}
              amount.toStringAsFixed(2),           // {amount}
              currency,                             // {currency}
              months.toString(),                   // {duration}
              monthly.toStringAsFixed(2),           // {monthly}
              totalPayments.toStringAsFixed(2),    // {totalPayments}
              interest.toStringAsFixed(2),          // {totalInterest}
              total.toStringAsFixed(2),             // {totalAmount}
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.okButton),
            ),
          ],
        ),
      );
    } catch (e) {
      showError("${l10n.errorOccurred}: $e");
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }
}
