import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoanIdeasSection extends StatelessWidget {
  const LoanIdeasSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 30 : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroImageSection(isMobile: isMobile, isTablet: isTablet),
          SizedBox(height: isMobile ? 40 : 80),
          _ContentSection(isMobile: isMobile),
        ],
      ),
    );
  }
}

/// =======================
/// IMAGE + TEXTE (HERO)
/// =======================
class _HeroImageSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _HeroImageSection({required this.isMobile, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    // Hauteur adaptative
    double height = isMobile ? 300 : isTablet ? 450 : 500;

    // Largeur max du texte
    double textWidth = isMobile ? MediaQuery.of(context).size.width * 0.9 : 520;

    // Padding du texte
    double padding = isMobile ? 12 : 40;

    // Taille du texte
    double mainFontSize = isMobile ? 10 : 18;
    double subFontSize = isMobile ? 8 : 14;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1521737604893-d14cc237f11d',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.15)),

          // Texte hero
          Align(
            alignment: isMobile ? Alignment.bottomCenter : Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: textWidth),
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 16 : 0),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '« Un bon prêt ne complique pas votre avenir,'
                            'il vous aide à le construire sereinement. »',
                        textAlign: isMobile ? TextAlign.center : TextAlign.center,
                        style: TextStyle(
                          fontSize: mainFontSize,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 16),
                      Text(
                        'Solutions de prêts privés — simples, claires et adaptées '
                            'à vos besoins personnels et professionnels.',
                        textAlign: isMobile ? TextAlign.center : TextAlign.center,
                        style: TextStyle(
                          fontSize: subFontSize,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
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
  final bool isMobile;

  const _ContentSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    // Sur mobile on empile gauche et droite verticalement
    return isMobile
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LeftContent(),
        SizedBox(height: 30),
        _RightContent(),
      ],
    )
        : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _LeftContent()),
        SizedBox(width: 40),
        Expanded(flex: 2, child: _RightContent()),
      ],
    );
  }
}

class _LeftContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nos solutions de prêts privés',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
          onPressed: () =>
              context.go('/offers'),
          child: const Text('Découvrir nos offres'),
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
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _RightContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            description: 'Décision de prêt rapide et sans procédures complexes.',
          ),
          SizedBox(height: 15),
          _HighlightItem(
            title: 'Conditions claires',
            description: 'Taux d’intérêt et pénalités définis à l’avance.',
          ),
          SizedBox(height: 15),
          _HighlightItem(
            title: 'Suivi transparent',
            description: 'Visualisez vos échéances et paiements à tout moment.',
          ),
        ],
      ),
    );
  }
}

class _HighlightItem extends StatelessWidget {
  final String title;
  final String description;

  const _HighlightItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 5),
        Text(description, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
