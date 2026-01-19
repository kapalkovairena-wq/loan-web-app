import 'package:flutter/material.dart';

import '../pages/loan_offers_page.dart';

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
                    'https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/top-view-of-businessmen-analyzing-management-statistics-while-working-at-company-investments-r6sdkfa7f0qarcxa8bmgf8ue5mupxbdnt3jijgp1qo.webp',
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
                    'https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/businesswoman-leader-team-conference-on-meeting-presentation-to-planning-investment-project-working-r6sdiewmsrz7xdueyyc6l93weyrggmebv5b4l5od1s.webp',
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
            'https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/Finovobank3-r6tmwcqsy2pvr6gewqegefmemja3rg0y6edjrx0mxc.jpg',
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoanOffersPage()),
                  );
                },
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
        children: [
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
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoanOffersPage()),
              );
            },
            child: const Text(
              'En savoir plus →',
              style: TextStyle(color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }
}