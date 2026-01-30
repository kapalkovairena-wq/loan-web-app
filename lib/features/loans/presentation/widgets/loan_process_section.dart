import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoanProcessSection extends StatelessWidget {
  const LoanProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;

    final double maxContentWidth = isMobile
        ? width
        : 800; // FORCÉ à 2 cartes max

    return Column(
      children: [
        SizedBox(height: isMobile ? 60 : 100),

        /// ===== TITRES =====
        const Text(
          "Notre processus de prêt",
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 10),
        Text(
          "Votre prêt en 3 étapes",
          style: TextStyle(
            fontSize: isMobile ? 26 : 34,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: isMobile ? width * 0.9 : 650,
          child: const Text(
            "Que ce soit pour un projet, un besoin de trésorerie ou un investissement, notre objectif est de vous aider à aller de l’avant en toute confiance.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ),

        SizedBox(height: isMobile ? 50 : 80),

        /// ===== ÉTAPES =====
        Center(
          child: SizedBox(
            width: maxContentWidth,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 40,
              runSpacing: 60,
              children: const [
                StepCard(
                  step: "01",
                  title: "Simulez votre prêt",
                  description:
                  "Choisissez le montant et la durée souhaités. Recevez un devis clair et sans engagement en quelques clics.",
                  isDark: false,
                ),
                StepCard(
                  step: "02",
                  title: "Soumettez votre demande",
                  description:
                  "Remplissez le formulaire sécurisé sans aucun document papier. Votre dossier est traité rapidement.",
                  isDark: true,
                ),
                StepCard(
                  step: "03",
                  title: "Recevez les fonds",
                  description:
                  "Une fois votre demande approuvée, le montant est versé directement sur votre compte.",
                  isDark: false,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: isMobile ? 80 : 120),

        /// ===== CTA =====
        const LoanCTASection(),
      ],
    );
  }
}


class StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String description;
  final bool isDark;

  const StepCard({
    super.key,
    required this.step,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 600;

    final bgColor = isDark ? const Color(0xFF061A3A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return SizedBox(
      width: isMobile ? width * 0.9 : 360, // 👈 360 x 2 + spacing = 2 max
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFF5B400),
            child: Text(
              "$step.",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.trending_up,
                  color: Color(0xFFF5B400),
                  size: 28,
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: subTextColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoanCTASection extends StatelessWidget {
  const LoanCTASection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 70 : 100,
        horizontal: 20,
      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF061A3A), Color(0xFF061A3A)],
        ),
      ),
      child: Column(
        children: [
          Text(
            "Démarrez votre projet de prêt dès maintenant",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 22 : 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: isMobile ? width * 0.9 : 700,
            child: const Text(
              "Vous avez un projet en tête ? Nous vous aidons à le concrétiser rapidement grâce à un prêt simple, sécurisé et 100 % en ligne.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5B400),
              padding:
              const EdgeInsets.symmetric(horizontal: 42, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () =>
                context.go('/request'),
            child: const Text(
              "Soumettre une demande",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}