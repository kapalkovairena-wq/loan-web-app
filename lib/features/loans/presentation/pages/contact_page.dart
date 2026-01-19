import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../widgets/hero_banner.dart';
import '../widgets/footer_section.dart';


class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
          children: [
      SingleChildScrollView(
      child : Container(
      color: const Color(0xFFF8F8F8),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Center(
        child: Column(
            children: [
            const AppHeader(),
        const HeroBanner(),
        const SizedBox(height: 80),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _contactForm(),
              const SizedBox(height: 60),
              _contactInfo(),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: _contactForm()),
              const SizedBox(width: 60),
              Expanded(flex: 5, child: _contactInfo()),
            ],
          ),
        ),
              const SizedBox(height: 80),
              const FooterSection(),
            ],
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

  // ---------------- FORMULAIRE ----------------

  Widget _contactForm() {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        child: Column(
          children: [
            _formField(label: "Nom", hint: "Votre nom"),
            _formField(
              label: "E-mail",
              hint: "Votre adresse e-mail",
              keyboardType: TextInputType.emailAddress,
            ),
            _formField(
              label: "Thème",
              hint: "Demande de prêt, informations, assistance...",
            ),
            _formField(
              label: "Message",
              hint: "Décrivez votre besoin de prêt ou votre question",
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6B400),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  "Envoyer un message",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formField({
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- INFOS CONTACT ----------------

  Widget _contactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 6),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFF6B400), width: 2),
            ),
          ),
          child: const Text(
            "Contactez-nous",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFF6B400),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Contactez KreditSch",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Notre équipe KreditSch est à votre écoute pour toute demande "
              "de prêt personnel, professionnel ou d’urgence. "
              "Nous vous accompagnons à chaque étape de votre financement.",
          style: TextStyle(
            color: Color(0xFF555555),
            height: 1.7,
          ),
        ),
        const SizedBox(height: 30),
        _infoItem(
          icon: "🏢",
          title: "Allemagne",
          text: "Audensstraße 2 – 61348 Bad Homburg v.d. Höhe",
        ),
        _infoItem(
          icon: "📞",
          title: "Téléphone",
          text: "+49 1577 4851991",
        ),
        _infoItem(
          icon: "✉️",
          title: "E-mail",
          text: "contact@kreditsch.de",
        ),
      ],
    );
  }

  Widget _infoItem({
    required String icon,
    required String title,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF6B400),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}