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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const WhatsAppButton(
              phoneNumber: "+4915774851991",
              message: "Bonjour, je souhaite plus d'informations sur vos prêts.",
            ),
          ],
      )
    );
  }
}