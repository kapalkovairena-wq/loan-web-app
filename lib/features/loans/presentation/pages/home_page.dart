import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../widgets/hero_banner.dart';
import '../widgets/loan_ideas_section.dart';
import '../widgets/why_choose_us_loan_section.dart';
import '../widgets/loan_services_cards_section.dart';
import '../widgets/why_choose_us_section.dart';
import '../widgets/loan_features_section.dart';
import '../widgets/credit_services_section.dart';
import '../widgets/testimonials_section.dart';
import '../widgets/loan_process_section.dart';
import '../widgets/footer_section.dart';

import '../../../../l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: const [
                AppHeader(),
                HeroBanner(),
                LoanIdeasSection(),
                WhyChooseUsLoanSection(),
                LoanServicesCardsSection(),
                WhyChooseUsSection(),
                LoanFeaturesSection(),
                CreditServicesSection(),
                TestimonialsSection(),
                LoanProcessSection(),
                FooterSection(),
              ],
            ),
          ),

          /// Bouton WhatsApp localisé
          WhatsAppButton(
            phoneNumber: "+4915774851991",
          ),
        ],
      ),
    );
  }
}
