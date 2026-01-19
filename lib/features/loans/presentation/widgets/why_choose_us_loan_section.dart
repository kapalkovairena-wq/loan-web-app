import 'package:flutter/material.dart';

import '../pages/loan_request_page.dart';
import '../pages/loan_offers_page.dart';

class WhyChooseUsLoanSection extends StatelessWidget {
  const WhyChooseUsLoanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopDarkSection(),
        _BottomImageSection(),
      ],
    );
  }
}

/// =======================
/// PARTIE BLEUE (TOP)
/// =======================
class _TopDarkSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
      color: const Color(0xFF061A3A),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TEXTE GAUCHE
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pourquoi nous ?',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Votre partenaire de prêts privés de confiance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nous combinons rapidité, transparence et accompagnement '
                      'personnalisé pour vous offrir des solutions de prêts simples, '
                      'efficaces et adaptées à vos objectifs.',
                  style: TextStyle(color: Colors.white70, height: 1.6),
                ),
                const SizedBox(height: 40),

                _progress('Rapidité de traitement', 0.95),
                const SizedBox(height: 20),
                _progress('Sécurité & fiabilité', 0.98),

                const SizedBox(height: 30),

                _checkItem('Amélioration continue de nos offres'),
                _checkItem('Engagement envers nos clients'),
                _checkItem('Conditions claires et sans surprise'),

                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoanRequestPage()),
                    );
                  },
                  child: const Text(
                    'Faire une demande',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 40),

          /// CARTE JAUNE
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(40),
              color: Colors.amber,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline, size: 40),
                  SizedBox(height: 20),
                  Text(
                    'Vous développez vos projets,\n'
                        'nous finançons votre ambition.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progress(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            Text('${(value * 100).round()}%',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation(Colors.amber),
        ),
      ],
    );
  }

  Widget _checkItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.amber),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

/// =======================
/// IMAGE + TEXTE (BOTTOM)
/// =======================
class _BottomImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          'https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/Screenshot_2026-01-19-04-24-55-829_com.android.chrome-edit.jpg',
          width: double.infinity,
          height: 420,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Nos solutions de financement',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Bien plus qu’un prêt, nous vous accompagnons à chaque étape '
                          'de votre projet personnel ou professionnel.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoanOffersPage()),
                  );
                },
                child: const Text(
                  'Voir les offres',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}