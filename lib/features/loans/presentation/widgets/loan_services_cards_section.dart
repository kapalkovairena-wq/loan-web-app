import 'package:flutter/material.dart';

class LoanServicesCardsSection extends StatelessWidget {
  const LoanServicesCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          /// =======================
          /// CARTES DU HAUT
          /// =======================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              children: const [
                Expanded(
                  child: _LoanCard(
                    imageUrl:
                    'https://images.unsplash.com/photo-1604594849809-dfedbc827105',
                    icon: Icons.savings_outlined,
                    title: 'Prêts personnels',
                    description:
                    'Des solutions de financement souples pour faire face '
                        'à vos besoins personnels et projets du quotidien.',
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  child: _LoanCard(
                    imageUrl:
                    'https://images.unsplash.com/photo-1554224155-6726b3ff858f',
                    icon: Icons.business_center_outlined,
                    title: 'Prêts professionnels',
                    description:
                    'Financement adapté aux entrepreneurs, commerçants '
                        'et porteurs de projets ambitieux.',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),

          /// =======================
          /// IMAGE CENTRALE
          /// =======================
          Image.network(
            'https://images.unsplash.com/photo-1523958203904-cdcb402031fd',
            width: double.infinity,
            height: 480,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 60),

          /// =======================
          /// CARTE DU BAS
          /// =======================
          const _BottomCard(),
        ],
      ),
    );
  }
}

/// =======================
/// CARTE INDIVIDUELLE
/// =======================
class _LoanCard extends StatelessWidget {
  final String imageUrl;
  final IconData icon;
  final String title;
  final String description;

  const _LoanCard({
    required this.imageUrl,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// IMAGE
        Image.network(
          imageUrl,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        /// CARTE BLANCHE
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.amber),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'En savoir plus →',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// =======================
/// CARTE DU BAS
/// =======================
class _BottomCard extends StatelessWidget {
  const _BottomCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 520,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: const [
          Icon(Icons.support_agent, size: 40, color: Colors.amber),
          SizedBox(height: 20),
          Text(
            'Accompagnement personnalisé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Un suivi humain, réactif et confidentiel pour vous accompagner '
                'à chaque étape de votre demande de prêt.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 20),
          Text(
            'En savoir plus →',
            style: TextStyle(color: Colors.amber),
          ),
        ],
      ),
    );
  }
}