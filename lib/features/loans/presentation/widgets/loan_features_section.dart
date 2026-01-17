import 'package:flutter/material.dart';

class LoanFeaturesSection extends StatelessWidget {
  const LoanFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        LoanFeature(
          title: "Financez vos projets personnels simplement",
          description:
          "Obtenez un prêt privé flexible pour vos besoins personnels avec des intérêts transparents et un remboursement adapté.",
        ),
        LoanFeature(
          title: "Soutenez les entrepreneurs et PME",
          description:
          "Investissez ou empruntez pour développer une activité grâce à notre réseau de prêteurs privés vérifiés.",
          imageLeft: false,
        ),
        LoanFeature(
          title: "Prêt rapide, sans procédure bancaire lourde",
          description:
          "Validation rapide, pénalités claires et conditions définies à l’avance entre prêteur et emprunteur.",
        ),
      ],
    );
  }
}

class LoanFeature extends StatelessWidget {
  final String title;
  final String description;
  final bool imageLeft;

  const LoanFeature({
    super.key,
    required this.title,
    required this.description,
    this.imageLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      child: Row(
        children: [
          if (imageLeft) _imagePlaceholder(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Demander un prêt >",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!imageLeft) _imagePlaceholder(),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 380,
      height: 260,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}