import 'package:flutter/material.dart';
import '../widgets/input_field.dart';

class LoanRequestPage extends StatefulWidget {
  const LoanRequestPage({super.key});

  @override
  State<LoanRequestPage> createState() => _LoanRequestPageState();
}

class _LoanRequestPageState extends State<LoanRequestPage> {
  // Personal info
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  // Financial info
  final TextEditingController amountController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController professionController = TextEditingController();

  double interestRate = 0.05; // 5% par an

  double calculateTotal(double amount, int months) {
    // Intérêt simple
    double totalInterest = amount * interestRate * (months / 12);
    return amount + totalInterest;
  }

  double calculateMonthly(double amount, int months) {
    double total = calculateTotal(amount, months);
    return total / months;
  }

  String? validateEmail(String value) {
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Email invalide";
    }
    return null;
  }

  String? validatePhone(String value) {
    if (!RegExp(r'^\+?\d{8,15}$').hasMatch(value)) {
      return "Téléphone invalide";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          title: const Text("Demande de prêt"),
          backgroundColor: const Color(0xFF061A3A),
        ),
        body: SingleChildScrollView(
            child: Center(
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
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InputField(
                    label: "Nom complet",
                    hint: "Votre nom complet",
                    controller: nameController,
                  ),
                  InputField(
                    label: "Email",
                    hint: "exemple@email.com",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  InputField(
                    label: "Téléphone",
                    hint: "Ex: +229 90 00 00 00",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  InputField(
                    label: "Date de naissance",
                    hint: "JJ/MM/AAAA",
                    controller: dobController,
                    keyboardType: TextInputType.datetime,
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Informations financières",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InputField(
                    label: "Montant du prêt demandé",
                    hint: "FCFA",
                    controller: amountController,
                    keyboardType: TextInputType.number,
                  ),
                  InputField(
                    label: "Durée du prêt (mois)",
                    hint: "Ex: 12",
                    controller: durationController,
                    keyboardType: TextInputType.number,
                  ),
                  InputField(
                    label: "Source de revenus",
                    hint: "Ex: Salaire, Business, Autres",
                    controller: incomeController,
                  ),
                  InputField(
                    label: "Profession",
                    hint: "Ex: Entrepreneur, Employé",
                    controller: professionController,
                  ),
                      SizedBox(height: 20),
                      Builder(builder: (_) {
                        double? amount = double.tryParse(amountController.text);
                        int? months = int.tryParse(durationController.text);

                        if (amount != null && months != null) {
                          double total = calculateTotal(amount, months);
                          double monthly = calculateMonthly(amount, months);

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blueGrey[100]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Résumé de votre prêt",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text("Montant demandé : ${amount.toStringAsFixed(0)} FCFA"),
                                Text("Durée : $months mois"),
                                Text("Intérêt : ${(interestRate*100).toStringAsFixed(2)} % / an"),
                                Text("Montant total à rembourser : ${total.toStringAsFixed(0)} FCFA"),
                                Text("Mensualité : ${monthly.toStringAsFixed(0)} FCFA"),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5B400),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 16,
                            ),
                          ),
                          onPressed: submitForm,
                          child: const Text(
                            "Soumettre la demande",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ),
        ),
    );
  }

  void submitForm() {
    String? emailError = validateEmail(emailController.text);
    String? phoneError = validatePhone(phoneController.text);

    if (nameController.text.isEmpty) {
      showError("Nom obligatoire");
      return;
    }
    if (emailError != null) {
      showError(emailError);
      return;
    }
    if (phoneError != null) {
      showError(phoneError);
      return;
    }

    double? amount = double.tryParse(amountController.text);
    int? months = int.tryParse(durationController.text);

    if (amount == null || months == null || amount <= 0 || months <= 0) {
      showError("Montant ou durée invalide");
      return;
    }

    // Formulaire OK, afficher la confirmation
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Demande envoyée"),
        content: Text(
          "Merci ${nameController.text}, votre demande de prêt a été reçue.\n"
              "Montant: ${amount.toStringAsFixed(0)} FCFA\n"
              "Durée: $months mois\n"
              "Mensualité: ${calculateMonthly(amount, months).toStringAsFixed(0)} FCFA",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }
}