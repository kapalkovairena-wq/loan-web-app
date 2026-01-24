import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/loan_simulation_page.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 700;
    final bool isTablet = width >= 700 && width < 1100;

    return Container(
      width: double.infinity,
      color: const Color(0xFF061A3A),
      child: Column(
        children: [
          /// =======================
          /// NEWSLETTER
          /// =======================
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Container(
                padding: const EdgeInsets.all(30),
                color: Colors.white,
                child: isMobile
                    ? _newsletterMobile()
                    : _newsletterDesktop(),
              ),
            ),
          ),

          /// =======================
          /// FOOTER PRINCIPAL
          /// =======================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isMobile
                  ? _footerMobile(context)
                  : _footerDesktop(context, isTablet),
            ),
          ),

          /// =======================
          /// COPYRIGHT
          /// =======================
          Container(
            width: double.infinity,
            color: const Color(0xFF04122A),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: const Center(
              child: Text(
                "© Copyright 2026 KreditSch. Tous droits réservés.",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// =======================
  /// NEWSLETTER
  /// =======================
  Widget _newsletterDesktop() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Abonnez-vous à notre newsletter",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Restez informé(e) des fonctionnalités et technologies de nos produits en constante évolution.",
              ),
            ],
          ),
        ),
        const SizedBox(width: 30),
        SizedBox(
          width: 360,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Votre adresse e-mail",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5B400),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          ),
          onPressed: () {},
          child: const Text("S'abonner", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget _newsletterMobile() {
    return Column(
      children: [
        const Text(
          "Abonnez-vous à notre newsletter",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          "Restez informé(e) des nouveautés et évolutions.",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            hintText: "Votre adresse e-mail",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5B400),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          ),
          onPressed: () {},
          child: const Text("S'abonner", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  /// =======================
  /// FOOTER DESKTOP / TABLET
  /// =======================
  Widget _footerDesktop(BuildContext context, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _brandBlock(context)),
        const SizedBox(width: 30),
        Expanded(child: _linksBlock("Services", [
          "À propos de nous",
          "Personnel",
          "Crédit",
          "Mobilité bancaire",
          "Contact",
        ])),
        const SizedBox(width: 30),
        Expanded(child: _linksBlock("Information", [
          "Protection des données",
          "Sécurité",
          "Conditions d'utilisation",
          "CGV",
        ])),
        const SizedBox(width: 30),
        Expanded(child: _contactBlock()),
      ],
    );
  }

  /// =======================
  /// FOOTER MOBILE
  /// =======================
  Widget _footerMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _brandBlock(context),
        const SizedBox(height: 40),
        _linksBlock("Services", [
          "À propos de nous",
          "Personnel",
          "Crédit",
          "Contact",
        ]),
        const SizedBox(height: 30),
        _linksBlock("Information", [
          "Protection des données",
          "Sécurité",
          "CGV",
        ]),
        const SizedBox(height: 30),
        _contactBlock(),
      ],
    );
  }

  /// =======================
  /// BLOCS
  /// =======================
  Widget _brandBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "KreditSch",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Nous redonnons aux gens le contrôle de leur argent grâce à des solutions de financement modernes.",
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5B400),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoanSimulationPage()),
            );
          },
          child: const Text("Voir une simulation",
              style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  Widget _linksBlock(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map(
              (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(e, style: const TextStyle(color: Colors.white70)),
          ),
        ),
      ],
    );
  }

  Widget _contactBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Contact",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        _ContactRow(Icons.location_on,
            "Audenstraße 2 – 4, 61348 Bad Homburg"),
        _ContactRow(Icons.email, "kontakt@kreditsch.de"),
        _ContactRow(Icons.phone, "+41 798079225"),
        _ContactRow(Icons.access_time, "Lun - Sam : 9h00 - 17h00"),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child:
            Text(text, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
