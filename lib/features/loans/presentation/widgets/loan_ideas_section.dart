import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class LoanIdeasSection extends StatelessWidget {
  const LoanIdeasSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          _HeroImageSection(
            isMobile: isMobile,
            isTablet: isTablet,
            l10n: l10n,
          ),
          SizedBox(height: isMobile ? 40 : 80),
          _ContentSection(isMobile: isMobile, l10n: l10n),
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
  final AppLocalizations l10n;

  const _HeroImageSection({
    required this.isMobile,
    required this.isTablet,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    double height = isMobile ? 300 : isTablet ? 450 : 500;
    double textWidth =
    isMobile ? MediaQuery.of(context).size.width * 0.9 : 520;
    double padding = isMobile ? 12 : 40;

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
                        l10n.loanIdeasHeroQuote,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: mainFontSize,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 16),
                      Text(
                        l10n.loanIdeasHeroSubtitle,
                        textAlign: TextAlign.center,
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
  final AppLocalizations l10n;

  const _ContentSection({
    required this.isMobile,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LeftContent(l10n: l10n),
        const SizedBox(height: 30),
        _RightContent(l10n: l10n),
      ],
    )
        : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _LeftContent(l10n: l10n)),
        const SizedBox(width: 40),
        Expanded(flex: 2, child: _RightContent(l10n: l10n)),
      ],
    );
  }
}

class _LeftContent extends StatelessWidget {
  final AppLocalizations l10n;

  const _LeftContent({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.loanIdeasTitle,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.loanIdeasDescription,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 30),
        _bullet(l10n.loanIdeasBulletPersonal),
        _bullet(l10n.loanIdeasBulletBusiness),
        _bullet(l10n.loanIdeasBulletEmergency),
        _bullet(l10n.loanIdeasBulletInvestment),
        _bullet(l10n.loanIdeasBulletInstallment),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => context.go('/offers'),
          child: Text(l10n.loanIdeasCta),
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
  final AppLocalizations l10n;

  const _RightContent({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.loanIdeasWhyTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _HighlightItem(
            title: l10n.loanIdeasWhyFastTitle,
            description: l10n.loanIdeasWhyFastDesc,
          ),
          const SizedBox(height: 15),
          _HighlightItem(
            title: l10n.loanIdeasWhyClearTitle,
            description: l10n.loanIdeasWhyClearDesc,
          ),
          const SizedBox(height: 15),
          _HighlightItem(
            title: l10n.loanIdeasWhyTrackingTitle,
            description: l10n.loanIdeasWhyTrackingDesc,
          ),
        ],
      ),
    );
  }
}

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
