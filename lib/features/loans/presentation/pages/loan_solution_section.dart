import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../widgets/hero_banner.dart';
import '../widgets/footer_section.dart';


class LoanSolutionSection extends StatelessWidget {
  const LoanSolutionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return Scaffold(
        drawer: const AppDrawer(),
        body: Stack(
          children: [
        SingleChildScrollView(
        child: Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeader(),
              const SizedBox(height: 60),
              HeroBanner(),
              const SizedBox(height: 60),
              _heroSection(isMobile),
              const SizedBox(height: 80),
              _whiteCards(isMobile),
              const SizedBox(height: 80),
              _divider(),
              const SizedBox(height: 80),
              _greyCards(isMobile),
              const SizedBox(height: 80),
              FooterSection(),
            ],
          ),
        ),
      ),
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

  // ---------------- HERO ----------------

  Widget _heroSection(bool isMobile) {
    return isMobile
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroImage(),
        const SizedBox(height: 40),
        _heroContent(),
      ],
    )
        : Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _heroImage()),
        const SizedBox(width: 60),
        Expanded(child: _heroContent()),
      ],
    );
  }

  Widget _heroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        'assets/images/loan_team.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _heroContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "L'alternative pour l'ici et maintenant.",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B1B3F),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Dans un contexte économique exigeant, accéder rapidement "
              "à un financement fiable est devenu essentiel. "
              "KreditSch propose des solutions de prêts flexibles, "
              "transparentes et adaptées aux particuliers comme aux entreprises.",
          style: TextStyle(
            color: Color(0xFF555555),
            height: 1.7,
          ),
        ),
        const SizedBox(height: 20),
        const _Bullet(text: "Prêts rapides avec réponse sous 24h."),
        const _Bullet(text: "Durées flexibles de 6 à 60 mois."),
        const _Bullet(
            text:
            "Solutions adaptées aux particuliers et professionnels."),
        const SizedBox(height: 25),
        InkWell(
          onTap: () {},
          child: const Text(
            "Demander un prêt KreditSch Standard >",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B1B3F),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- CARTES BLANCHES ----------------

  Widget _whiteCards(bool isMobile) {
    return GridView.count(
        shrinkWrap: true,
        crossAxisCount: isMobile ? 1 : 3,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
        _Card(
          icon: "☂️",
          title: "Prêt à faible risque",
          text:
          "Des mensualités fixes et transparentes "
              "pour une meilleure maîtrise de votre budget.",
        ),
        _Card(
            icon: "📌",
            title: "Prêts ciblés",
            text:
            "Financement dédié : logement, auto, études, projets personnels ou trésorerie.",
        ),
          _Card(
            icon: "💰",
            title: "Montant flexible",
            text:
            "Empruntez entre 1 000 € et 250 000 € "
                "selon votre profil et votre besoin.",
          ),
        ],
    );
  }

  // ---------------- DIVIDER ----------------

  Widget _divider() {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      color: const Color(0xFFE6E6E6),
      child: const Text(
        "Si cette solution de prêt ne correspond pas à votre situation, "
            "KreditSch vous propose d'autres options de financement.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFF2B1B3F),
        ),
      ),
    );
  }

  // ---------------- CARTES GRISES ----------------

  Widget _greyCards(bool isMobile) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: isMobile ? 1 : 2,
      crossAxisSpacing: 30,
      mainAxisSpacing: 30,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _Card(
          icon: "🎯",
          title: "Prêts personnalisés",
          text:
          "Des offres adaptées à votre situation financière "
              "et à votre capacité de remboursement.",
          grey: true,
        ),
        _Card(
          icon: "🌱",
          title: "Prêts responsables",
          text:
          "Financements pensés pour des projets durables "
              "et à impact positif.",
          grey: true,
        ),
        _Card(
          icon: "🏥",
          title: "Prêts thématiques",
          text:
          "Santé, études, mobilité, logement ou entrepreneuriat : "
              "des prêts dédiés à chaque besoin.",
          grey: true,
        ),
        _Card(
          icon: "🤝",
          title: "Partenaires financiers",
          text:
          "Accès à des solutions issues de partenaires "
              "financiers nationaux et internationaux.",
          grey: true,
        ),
      ],
    );
  }
}

// ---------------- COMPONENTS ----------------

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        "– $text",
        style: const TextStyle(color: Color(0xFF555555)),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String icon;
  final String title;
  final String text;
  final bool grey;

  const _Card({
    required this.icon,
    required this.title,
    required this.text,
    this.grey = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      decoration: BoxDecoration(
        color: grey ? const Color(0xFFF0F0F0) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: grey
            ? []
            : const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B1B3F),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}