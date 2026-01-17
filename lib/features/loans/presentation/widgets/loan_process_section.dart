import 'package:flutter/material.dart';

class LoanProcessSection extends StatelessWidget {
  const LoanProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),

        // ===== TITRE =====
        const Text(
          "Notre processus de prêt",
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 10),
        const Text(
          "Votre prêt en 3 étapes",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const SizedBox(
          width: 650,
          child: Text(
            "Que ce soit pour un projet, un besoin de trésorerie ou un investissement, notre objectif est de vous aider à aller de l’avant en toute confiance.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ),

        const SizedBox(height: 80),

        // ===== ÉTAPES 1 & 2 =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: StepCard(
                  step: "01",
                  title: "Simulez votre prêt",
                  description:
                  "Choisissez le montant et la durée souhaités. Recevez un devis clair et sans engagement en quelques clics.",
                  isDark: false,
                ),
              ),
              SizedBox(width: 40),
              Expanded(
                child: StepCard(
                  step: "02",
                  title: "Soumettez votre demande en ligne",
                  description:
                  "Remplissez le formulaire sécurisé sans aucun document papier. Votre dossier sera traité rapidement.",
                  isDark: true,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 60),

        // ===== ÉTAPE 3 =====
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 250),
          child: StepCard(
            step: "03",
            title: "Recevez les fonds",
            description:
            "Une fois votre demande approuvée, le montant sera transféré directement sur votre compte. Simple, rapide et fiable.",
            isDark: false,
          ),
        ),

        const SizedBox(height: 120),

        // ===== CTA FINAL =====
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
    final bgColor = isDark ? const Color(0xFF061A3A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Column(
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
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            children: [
              const Icon(Icons.trending_up, color: Color(0xFFF5B400)),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(color: subTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoanCTASection extends StatelessWidget {
  const LoanCTASection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF061A3A).withOpacity(0.9),
            const Color(0xFF061A3A).withOpacity(0.9),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Démarrez votre projet de prêt dès maintenant",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const SizedBox(
            width: 700,
            child: Text(
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
              const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            ),
            onPressed: () {},
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