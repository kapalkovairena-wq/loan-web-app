import 'package:flutter/material.dart';
import '../pages/loan_request_page.dart';


class LoanIdeasSection extends StatelessWidget {
  const LoanIdeasSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroImageSection(),
          const SizedBox(height: 80),
          _ContentSection(),
        ],
      ),
    );
  }
}

/// =======================
/// IMAGE + TEXTE (HERO)
/// =======================
class _HeroImageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d',
            fit: BoxFit.cover,
          ),

          Container(color: Colors.black.withOpacity(0.15)),

          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Container(
                width: 520,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '« Un bon prêt ne complique pas votre avenir,\n'
                          'il vous aide à le construire sereinement. »',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Solutions de prêts privés — simples, claires et adaptées '
                          'à vos besoins personnels et professionnels.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// CONTENU PRINCIPAL
/// =======================
class _ContentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      /// GAUCHE
      Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Text(
        'Nos solutions de prêts privés',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      const Text(
        'Nous proposons des solutions de prêts flexibles et transparentes, '
            'adaptées aux besoins des particuliers et des professionnels.',
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 30),

      _bullet('Prêt personnel à court terme'),
      _bullet('Prêt pour activités commerciales'),
      _bullet('Prêt d’urgence'),
      _bullet('Prêt d’investissement'),
      _bullet('Prêt avec remboursement échelonné'),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoanRequestPage()),
              );
            },
            child: const Text('Découvrir nos offres'),
          ),
        ],
      ),
      ),

        const SizedBox(width: 40),

        /// DROITE
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade900,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pourquoi choisir notre service ?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _HighlightItem(
                  title: 'Processus rapide',
                  description:
                  'Décision de prêt rapide et sans procédures complexes.',
                ),
                SizedBox(height: 15),
                _HighlightItem(
                  title: 'Conditions claires',
                  description:
                  'Taux d’intérêt et pénalités définis à l’avance.',
                ),
                SizedBox(height: 15),
                _HighlightItem(
                  title: 'Suivi transparent',
                  description:
                  'Visualisez vos échéances et paiements à tout moment.',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}

/// =======================
/// ITEM DE DROITE
/// =======================
class _HighlightItem extends StatelessWidget {
  final String title;
  final String description;

  const _HighlightItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}