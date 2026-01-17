import 'package:flutter/material.dart';

class CreditServicesSection extends StatelessWidget {
  const CreditServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        const Text(
          "Nos dossiers",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        const Text(
          "Nos services de crédit",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const SizedBox(
          width: 600,
          child: Text(
            "Nous proposons des solutions de financement flexibles et accessibles, adaptées à vos besoins personnels ou professionnels.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 60),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              LoanImageCard(title: "Prêt personnel"),
              LoanImageCard(title: "Prêt entrepreneurial"),
              LoanImageCard(title: "Prêt investissement"),
              LoanImageCard(title: "Prêt urgence financière"),
            ],
          ),
        ),
      ],
    );
  }
}

class LoanImageCard extends StatelessWidget {
  final String title;

  const LoanImageCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.black54,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

