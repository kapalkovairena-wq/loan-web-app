import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/loan_simulation_page.dart';
import '../pages/home_page.dart';
import '../pages/contact_page.dart';
import '../pages/loan_solution_section.dart';
import '../pages/loan_offers_page.dart';
import '../pages/about_page.dart';

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
        Expanded(child:
        _linksBlock(
          context,
          "Services",
          [
            _FooterLink("Page d'accueil", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
            _FooterLink("Découvrir nos offres", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoanOffersPage()),
              );
            }),
            _FooterLink("Investissement", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoanSolutionSection()),
              );
            }),
            _FooterLink("Contact", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ContactPage()),
              );
            }),
            _FooterLink("À propos de nous", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            }),
          ],
        ),
        ),
        const SizedBox(width: 30),
        Expanded(child:
        _linksBlock(
          context,
          "Information",
          [
            _FooterLink("Protection des données", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
            _FooterLink("Sécurité", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
            _FooterLink("CGV", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
          ],
        ),
        ),
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
        _linksBlock(
          context,
          "Services",
          [
            _FooterLink("Page d'accueil", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
            _FooterLink("Découvrir nos offres", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoanOffersPage()),
              );
            }),
            _FooterLink("Investissement", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const LoanSolutionSection()),
              );
            }),
            _FooterLink("Contact", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ContactPage()),
              );
            }),
            _FooterLink("À propos de nous", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            }),
          ],
        ),
        const SizedBox(height: 30),

        _linksBlock(
          context,
          "Information",
          [
            _FooterLink("Protection des données", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
            _FooterLink("Sécurité", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
            _FooterLink("CGV", () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }),
          ],
        ),
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
        Image.network(
          "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/favicon.png",
          height: 100,
        ),
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

  Widget _linksBlock(
      BuildContext context,
      String title,
      List<_FooterLink> links,
      ) {
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
              (link) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: InkWell(
              onTap: link.onTap,
              hoverColor: Colors.white10,
              child: Text(
                link.label,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        _ContactRow(
          Icons.email,
          "kontakt@kreditsch.de",
          onTap: () {
            _launchURL("mailto:kontakt@kreditsch.de");
          },
        ),
        _ContactRow(
          Icons.phone,
          "+41 798079225",
          onTap: () {
            _launchURL("tel:+41798079225");
          },
        ),
        _ContactRow(Icons.access_time, "Lun - Sam : 9h00 - 17h00"),
      ],
    );
  }
}

class _FooterLink {
  final String label;
  final VoidCallback onTap;

  _FooterLink(this.label, this.onTap);
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ContactRow(this.icon, this.text, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

