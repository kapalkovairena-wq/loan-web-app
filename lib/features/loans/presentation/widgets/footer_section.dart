import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pages/loan_simulation_page.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  // Fonction pour ouvrir les liens externes
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF061A3A),
      child: Column(
          children: [
      // Newsletter
      Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(30),
        color: Colors.white,
        child: Column(
          children: [
            const Text(
              "Abonnez-vous à notre newsletter",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Restez informé(e) des fonctionnalités et technologies de nos produits en constante évolution.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Saisissez votre adresse e-mail",
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 18),
                  ),
                  onPressed: () {
                    // TODO: intégrer l'inscription newsletter
                  },
                  child: const Text(
                    "S'abonner",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),

    // Footer principal
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 40),
    child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 1200),
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    // Logo + description + bouton
    Flexible(
    flex: 2,
    child: Column(
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
    const SizedBox(height: 10),
    const SizedBox(
    width: 300,
    child: Text(
    "Nous pensons qu'il est temps de redonner aux gens le contrôle de leur argent et de réinventer leur relation avec la banque.",
    style: TextStyle(color: Colors.white70),
    ),
    ),
    const SizedBox(height: 20),
    ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFF5B400),
    padding: const EdgeInsets.symmetric(
    horizontal: 25, vertical: 18),
    ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoanSimulationPage()),
        );
      },
    child: const Text(
    "Voir une simulation",
    style: TextStyle(color: Colors.black),
    ),
    ),
    ],
    ),
    ),

    const SizedBox(width: 20),

    // Services
    Flexible(
    flex: 1,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    "Services",
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    ),
    ),
    const SizedBox(height: 10),
    _footerLink("À propos de nous"),
    _footerLink("Poursuivre"),
    _footerLink("Personnel"),
    _footerLink("Mobilité bancaire"),
    _footerLink("Crédit"),
    _footerLink("Contact"),
    ],
    ),
    ),

    const SizedBox(width: 20),

    // Informations
    Flexible(
    flex: 1,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    "Information",
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    ),
    ),
    const SizedBox(height: 10),
    _footerLink("Imprimer"),
    _footerLink("Protection des données"),
    _footerLink("Paramètres de consentement"),
    _footerLink("Sécurité"),
    _footerLink("Conditions d'utilisation"),
    _footerLink("CGV"),
    ],
    ),
    ),

    const SizedBox(width: 20),

    // Contact
    Flexible(
    flex: 1,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    "Contact",
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    ),
    ),
      const SizedBox(height: 10),
      _contactRow(Icons.location_on, "Audenstraße 2 – 4 61348 Bad Homburg vd Höhe"),
      _contactRow(Icons.email, "kontakt@kreditsch.de"),
      _contactRow(Icons.phone, "+41 798079225"),
      _contactRow(Icons.access_time, "9h00 - 17h00, du lundi au samedi"),
    ],
    ),
    ),
    ],
    ),
    ),
    ),

            // Copyright
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

  // Widget pour un lien
  Widget _footerLink(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          // TODO: Lien vers la page correspondante
        },
        child: Text(
          title,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  // Widget pour les infos de contact
  Widget _contactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}