import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

import '../pages/loan_request_page.dart';
import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../widgets/footer_section.dart';
import '../widgets/why_choose_us_loan_section.dart';
import '../widgets/why_choose_us_section.dart';

class LoanOffersPage extends StatelessWidget {
  const LoanOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const AppHeader(),
                _HeroSection(l10n: l10n),
                const SizedBox(height: 80),
                _OffersSection(l10n: l10n),
                const SizedBox(height: 40),
                const WhyChooseUsLoanSection(),
                const WhyChooseUsSection(),
                _CallToActionSection(l10n: l10n),
                const FooterSection(),
              ],
            ),
          ),
          const WhatsAppButton(phoneNumber: "+41798079255"),
        ],
      ),
    );
  }
}

/* ================= HERO ================= */

class _HeroSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _HeroSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1523287562758-66c7fc58967f",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        color: Colors.black.withOpacity(0.55),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.loanOffersHeroTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 600,
              child: Text(
                l10n.loanOffersHeroSubtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= OFFERS ================= */

class _OffersSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _OffersSection({required this.l10n});

  int _crossAxis(double width) => width < 700 ? 1 : 2;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 700;

        final offers = [
          OfferCard(
            title: l10n.offerPersonalTitle,
            description: l10n.offerPersonalDesc,
            imageUrl:
            "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/2.png",
          ),
          OfferCard(
            title: l10n.offerBusinessTitle,
            description: l10n.offerBusinessDesc,
            imageUrl:
            "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/4.png",
          ),
          OfferCard(
            title: l10n.offerInvestmentTitle,
            description: l10n.offerInvestmentDesc,
            imageUrl:
            "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/logo%20(1600%20x%201600%20px)%20(1).png",
          ),
          OfferCard(
            title: l10n.offerEmergencyTitle,
            description: l10n.offerEmergencyDesc,
            imageUrl:
            "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/3.png",
          ),
        ];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 80),
          child: Column(
            children: [
              Text(
                l10n.loanOffersTitle,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.loanOffersSubtitle,
                style: const TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: offers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxis(width),
                  crossAxisSpacing: 32,
                  mainAxisSpacing: 32,
                  childAspectRatio: isMobile ? 1.2 : 0.95,
                ),
                itemBuilder: (_, i) => offers[i],
              ),
            ],
          ),
        );
      },
    );
  }
}

class OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const OfferCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(description,
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= CTA ================= */

class _CallToActionSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _CallToActionSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 16 : 0),
      width: double.infinity,
      color: const Color(0xFF061A3A),
      child: Column(
        children: [
          Text(
            l10n.loanOffersCtaTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.loanOffersCtaSubtitle,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoanRequestPage()),
              );
            },
            child: Text(l10n.loanOffersCtaButton),
          ),
        ],
      ),
    );
  }
}
