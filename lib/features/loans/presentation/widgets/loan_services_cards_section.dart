import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoanServicesCardsSection extends StatelessWidget {
  const LoanServicesCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    final horizontalPadding = isMobile ? 16.0 : 60.0;
    final cardSpacing = isMobile ? 20.0 : 40.0;
    final centralImageHeight = isMobile ? 250.0 : isTablet ? 380.0 : 480.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          /// =======================
          /// CARTES DU HAUT
          /// =======================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: isMobile
                ? Column(
              children: [
                _LoanCard(
                  imageUrl:
                  'https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/top-view-of-businessmen-analyzing-management-statistics-while-working-at-company-investments-r6sdkfa7f0qarcxa8bmgf8ue5mupxbdnt3jijgp1qo.webp',
                  icon: Icons.savings_outlined,
                  title: 'Prêts personnels',
                  description:
                  'Des solutions de financement souples pour faire face '
                      'à vos besoins personnels et projets du quotidien.',
                  isMobile: true,
                ),
                SizedBox(height: cardSpacing),
                _LoanCard(
                  imageUrl:
                  'https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/businesswoman-leader-team-conference-on-meeting-presentation-to-planning-investment-project-working-r6sdiewmsrz7xdueyyc6l93weyrggmebv5b4l5od1s.webp',
                  icon: Icons.business_center_outlined,
                  title: 'Prêts professionnels',
                  description:
                  'Financement adapté aux entrepreneurs, commerçants '
                      'et porteurs de projets ambitieux.',
                  isMobile: true,
                ),
              ],
            )
                : Row(
              children: [
                Expanded(
                  child: _LoanCard(
                    imageUrl:
                    'https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/top-view-of-businessmen-analyzing-management-statistics-while-working-at-company-investments-r6sdkfa7f0qarcxa8bmgf8ue5mupxbdnt3jijgp1qo.webp',
                    icon: Icons.savings_outlined,
                    title: 'Prêts personnels',
                    description:
                    'Des solutions de financement souples pour faire face '
                        'à vos besoins personnels et projets du quotidien.',
                    isMobile: false,
                  ),
                ),
                SizedBox(width: cardSpacing),
                Expanded(
                  child: _LoanCard(
                    imageUrl:
                    'https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/businesswoman-leader-team-conference-on-meeting-presentation-to-planning-investment-project-working-r6sdiewmsrz7xdueyyc6l93weyrggmebv5b4l5od1s.webp',
                    icon: Icons.business_center_outlined,
                    title: 'Prêts professionnels',
                    description:
                    'Financement adapté aux entrepreneurs, commerçants '
                        'et porteurs de projets ambitieux.',
                    isMobile: false,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 80),

          /// =======================
          /// IMAGE CENTRALE
          /// =======================
          Image.network(
            'https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/Finovobank3-r6tmwcqsy2pvr6gewqegefmemja3rg0y6edjrx0mxc.jpg',
            width: double.infinity,
            height: centralImageHeight,
            fit: BoxFit.cover,
          ),

          SizedBox(height: 60),

          /// =======================
          /// CARTE DU BAS
          /// =======================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: const _BottomCard(),
          ),
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
  final bool isMobile;

  const _LoanCard({
    required this.imageUrl,
    required this.icon,
    required this.title,
    required this.description,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final imageHeight = isMobile ? 300.0 : 400.0;
    final padding = isMobile ? 16.0 : 30.0;

    return Column(
      children: [
        Image.network(
          imageUrl,
          height: imageHeight,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          padding: EdgeInsets.all(padding),
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
              SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () =>
                    context.go('/offers'),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final cardWidth = isMobile ? double.infinity : 520.0;
    final padding = isMobile ? 20.0 : 40.0;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(padding),
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
          const Text(
            'Accompagnement personnalisé',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Un suivi humain, réactif et confidentiel pour vous accompagner '
                'à chaque étape de votre demande de prêt.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () =>
                context.go('/offers'),
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
