import 'package:flutter/material.dart';

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
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      body: Stack(
          children: [
      SingleChildScrollView(
        child: Column(
          children: const [
            AppHeader(),
            _HeroSection(),
            SizedBox(height: 80),
            _OffersSection(),
            SizedBox(height: 40),
            WhyChooseUsLoanSection(),
            WhyChooseUsSection(),
            _CallToActionSection(),
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

/* ================= HERO SECTION ================= */

class _HeroSection extends StatelessWidget {
  const _HeroSection();

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
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Nos offres de financement",
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 600,
              child: Text(
                "Des solutions de crédit rapides, transparentes et adaptées à vos besoins personnels et professionnels.",
                style: TextStyle(
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

/* ================= OFFERS SECTION ================= */

class _OffersSection extends StatelessWidget {
  const _OffersSection();

  int _getCrossAxisCount(double width) {
    if (width < 700) {
      return 1; // mobile
    }
    return 2; // tablette + desktop
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 700;

        final crossAxisCount = _getCrossAxisCount(width);

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 80,
          ),
          child: Column(
            children: [
              const Text(
                "Nos offres",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Découvrez les solutions de crédit que nous mettons à votre disposition.",
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 32,
                  mainAxisSpacing: 32,
                  childAspectRatio: isMobile ? 1.20 : 0.95,
                ),
                itemBuilder: (context, index) {
                  final offers = [
                    const OfferCard(
                      title: "Prêt personnel",
                      description:
                      "Financez vos projets personnels avec des conditions flexibles et un traitement rapide.",
                      imageUrl:
                      "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/2.png",
                    ),
                    const OfferCard(
                      title: "Prêt entrepreneurial",
                      description:
                      "Un accompagnement financier pour développer et faire grandir votre entreprise.",
                      imageUrl:
                      "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/4.png",
                    ),
                    const OfferCard(
                      title: "Prêt investissement",
                      description:
                      "Investissez dans l’immobilier ou d’autres opportunités rentables.",
                      imageUrl:
                      "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/logo%20(1600%20x%201600%20px)%20(1).png",
                    ),
                    const OfferCard(
                      title: "Prêt d’urgence",
                      description:
                      "Une solution rapide pour faire face aux imprévus financiers.",
                      imageUrl:
                      "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/3.png",
                    ),
                  ];

                  return offers[index];
                },
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
              aspectRatio: 16 / 9, // 👈 contrôle la hauteur proprement
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= CTA SECTION ================= */

class _CallToActionSection extends StatelessWidget {
  const _CallToActionSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 16 : 0,
      ),
      width: double.infinity,
      color: const Color(0xFF061A3A),
      child: Column(
        children: [
          Text(
            "Prêt à faire votre demande ?",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "Contactez-nous dès aujourd’hui et bénéficiez d’un accompagnement personnalisé.",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: isMobile ? double.infinity : null,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                backgroundColor: Colors.amber,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoanRequestPage()),
                );
              },
              child: const Text(
                "Faire une demande",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}