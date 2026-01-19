import 'package:flutter/material.dart';

import '../pages/loan_request_page.dart';

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
          imageUrl:
          "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/CRST-6687_Hom.webp",
        ),
        LoanFeature(
          title: "Soutenez les entrepreneurs et PME",
          description:
          "Investissez ou empruntez pour développer une activité grâce à notre réseau de prêteurs privés vérifiés.",
          imageUrl:
          "https://images.unsplash.com/photo-1556761175-4b46a572b786",
          imageLeft: false,
        ),
        LoanFeature(
          title: "Prêt rapide, sans procédure bancaire lourde",
          description:
          "Validation rapide, pénalités claires et conditions définies à l’avance entre prêteur et emprunteur.",
          imageUrl:
          "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/logo%20(1600%20x%201600%20px).png",
        ),
      ],
    );
  }
}

class LoanFeature extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final bool imageLeft;

  const LoanFeature({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.imageLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imageLeft) _image(),
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoanRequestPage()),
                      );
                    },
                    child: const Text(
                      "Demander un prêt >",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!imageLeft) _image(),
        ],
      ),
    );
  }

  Widget _image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        width: 380,
        height: 260,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 380,
            height: 260,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 380,
            height: 260,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.broken_image, size: 40),
          );
        },
      ),
    );
  }
}