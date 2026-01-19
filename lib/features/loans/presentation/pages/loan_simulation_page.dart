import 'dart:math';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../pages/loan_request_page.dart';
import '../widgets/app_header.dart';
import '../widgets/hero_banner.dart';
import '../widgets/footer_section.dart';

class LoanSimulationPage extends StatefulWidget {
  const LoanSimulationPage({super.key});

  @override
  State<LoanSimulationPage> createState() => _LoanSimulationPageState();
}

class _LoanSimulationPageState extends State<LoanSimulationPage> {
  double montant = 3000;
  int duree = 12;

  static const double tauxAnnuel = 0.03;
  static const double assuranceMensuelle = 0;

  double get tauxMensuel => tauxAnnuel / 12;

  double get mensualite {
    return montant *
        tauxMensuel /
        (1 - pow(1 + tauxMensuel, -duree));
  }

  double get totalMensualites => mensualite * duree;
  double get totalInterets => totalMensualites - montant;
  double get totalAssurance => assuranceMensuelle * duree;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        drawer: const AppDrawer(),
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
              padding: const EdgeInsets.all(40),
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
                "Simulez votre prêt",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ajustez les paramètres pour estimer votre crédit.",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 40),

              // ===== MONTANT =====
              Text(
                "Montant du prêt : ${montant.toInt()} €",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Slider(
                value: montant,
                min: 3000,
                max: 500000,
                divisions: 100,
                label: montant.toInt().toString(),
                onChanged: (value) {
                  setState(() => montant = value);
                },
              ),

              const SizedBox(height: 30),

              // ===== DURÉE =====
              Text(
                "Durée : $duree mois",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Slider(
                value: duree.toDouble(),
                min: 6,
                max: 120,
                divisions: 19,
                label: duree.toString(),
                onChanged: (value) {
                  setState(() => duree = value.toInt());
                },
              ),
                  const SizedBox(height: 40),

                  // ===== RÉSULTATS =====
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF061A3A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _resultRow(
                          "Mensualité du crédit",
                          "${mensualite.toStringAsFixed(2)} €",
                          isBold: true,
                        ),
                        const Divider(color: Colors.white30),
                        _resultRow(
                          "Taux d'interêt annuel du crédit",
                          "3%",
                        ),
                        _resultRow(
                          "Assurance mensuelle",
                          "0%",
                        ),
                        _resultRow(
                          "Total des mensualités (hors assurance)",
                          "${totalMensualites.toStringAsFixed(2)} €",
                        ),
                        _resultRow(
                          "Total des intérêts",
                          "${totalInterets.toStringAsFixed(2)} €",
                        ),
                        _resultRow(
                          "Total de l’assurance",
                          "${totalAssurance.toStringAsFixed(2)} €",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5B400),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoanRequestPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Continuer la demande",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _resultRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}