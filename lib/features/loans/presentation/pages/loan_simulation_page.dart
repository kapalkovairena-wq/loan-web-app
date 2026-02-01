import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../l10n/app_localizations.dart';

import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../pages/loan_request_page.dart';
import '../widgets/app_header.dart';
import '../widgets/footer_section.dart';

class LoanSimulationPage extends StatefulWidget {
  const LoanSimulationPage({super.key});

  @override
  State<LoanSimulationPage> createState() => _LoanSimulationPageState();
}

class _LoanSimulationPageState extends State<LoanSimulationPage> {
  Map<String, dynamic> profileData = {};
  bool isLoadingProfile = true;

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
  void initState() {
    super.initState();
    _loadProfile();
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
    final width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 700;
    final bool isTablet = width >= 700 && width < 1100;

    if (isLoadingProfile) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const AppHeader(),
                const SizedBox(height: 80),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isMobile
                          ? double.infinity
                          : isTablet
                          ? 700
                          : 900,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 0,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(isMobile ? 24 : 40),
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
                              l10n.simulationTitle,
                              style: TextStyle(
                                fontSize: isMobile ? 22 : 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.simulationDescription,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: isMobile ? 14 : 16,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              "${l10n.loanAmount}: ${montant.toInt()} $currency",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: isMobile ? 3 : 4,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                              ),
                              child: Slider(
                                value: montant,
                                min: 3000,
                                max: 500000,
                                divisions: 1000,
                                onChanged: (value) {
                                  setState(() => montant = value);
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "${l10n.duration}: $duree ${l10n.months}",
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
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF061A3A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  _resultRow(l10n.monthlyPayment, "${mensualite.toStringAsFixed(2)} $currency", isBold: true),
                                  const Divider(color: Colors.white30),
                                  _resultRow(l10n.annualInterestRate, "3%"),
                                  _resultRow(l10n.monthlyInsurance, "0%"),
                                  _resultRow(l10n.totalPayments, "${totalMensualites.toStringAsFixed(2)} $currency"),
                                  _resultRow(l10n.totalInterests, "${totalInterets.toStringAsFixed(2)} $currency"),
                                  _resultRow(l10n.totalInsurance, "${totalAssurance.toStringAsFixed(2)} $currency"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: SizedBox(
                                width: isMobile ? double.infinity : null,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF5B400),
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const LoanRequestPage()),
                                    );
                                  },
                                  child: Text(
                                    l10n.continueRequest,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _resultRow(String label, String value, {bool isBold = false}) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      )
          : Row(
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
