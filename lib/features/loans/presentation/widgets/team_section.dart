import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 700;
        final bool isTablet = width >= 700 && width < 1100;

        final double verticalPadding = isMobile ? 60 : 80;
        final double horizontalPadding = isMobile ? 20 : 24;
        final double titleSize = isMobile ? 26 : isTablet ? 32 : 36;

        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isMobile
                  ? _MobileLayout(titleSize: titleSize)
                  : _DesktopLayout(titleSize: titleSize),
            ),
          ),
        );
      },
    );
  }
}

/* ---------------- MOBILE / TABLET ---------------- */

class _MobileLayout extends StatelessWidget {
  final double titleSize;

  const _MobileLayout({required this.titleSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Notre équipe',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF3B1B5A),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Fondée par des experts de la finance et du digital, '
              'KreditSch accompagne depuis plusieurs années des milliers '
              'de clients dans la réalisation de leurs projets grâce à '
              'des solutions de prêt simples, rapides et transparentes.\n\n'
              'Notre équipe internationale travaille chaque jour avec '
              'une seule ambition : rendre l’accès au crédit plus juste, '
              'plus humain et accessible à tous.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.7,
            color: Color(0xFF6B6B6B),
          ),
        ),
        const SizedBox(height: 26),
        const _ActionLink(centered: true),
      ],
    );
  }
}

/* ---------------- DESKTOP ---------------- */

class _DesktopLayout extends StatelessWidget {
  final double titleSize;

  const _DesktopLayout({required this.titleSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// IMAGE
        Expanded(
          flex: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              'https://images.unsplash.com/photo-1521737604893-d14cc237f11d',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 60),

        /// TEXTE
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notre équipe',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3B1B5A),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Fondée par des experts de la finance et du digital, '
                    'KreditSch accompagne depuis plusieurs années des milliers '
                    'de clients dans la réalisation de leurs projets grâce à '
                    'des solutions de prêt simples, rapides et transparentes.\n\n'
                    'Notre équipe internationale travaille chaque jour avec '
                    'une seule ambition : rendre l’accès au crédit plus juste, '
                    'plus humain et accessible à tous.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  color: Color(0xFF6B6B6B),
                ),
              ),
              const SizedBox(height: 28),
              const _ActionLink(),
            ],
          ),
        ),
      ],
    );
  }
}

/* ---------------- CTA LINK ---------------- */

class _ActionLink extends StatelessWidget {
  final bool centered;

  const _ActionLink({this.centered = false});

  @override
  Widget build(BuildContext context) {
    final link = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () =>
        context.go('/offers'),
        child: const Text(
          'Découvrez nos solutions de prêt >',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6A1FD2),
          ),
        ),
      ),
    );

    return centered ? Center(child: link) : link;
  }
}
