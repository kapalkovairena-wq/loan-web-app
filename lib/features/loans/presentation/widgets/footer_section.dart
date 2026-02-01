import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/language_selector.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 700;
    final bool isTablet = width >= 700 && width < 1100;

    return Container(
      width: double.infinity,
      color: const Color(0xFF061A3A),
      child: Column(
        children: [
          /// NEWSLETTER
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Container(
                padding: const EdgeInsets.all(30),
                color: Colors.white,
                child: isMobile
                    ? _newsletterMobile(l10n)
                    : _newsletterDesktop(l10n),
              ),
            ),
          ),

          /// FOOTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isMobile
                  ? _footerMobile(context, l10n)
                  : _footerDesktop(context, l10n, isTablet),
            ),
          ),

          /// COPYRIGHT + SÉLECTEUR DE LANGUES
          Container(
            width: double.infinity,
            color: const Color(0xFF04122A),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Sélecteur de langues centré
                LanguageSelector(),

                const SizedBox(height: 10),

                // Texte de copyright
                Text(
                  l10n.footerCopyright,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =======================
  /// NEWSLETTER
  /// =======================
  Widget _newsletterDesktop(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.newsletterTitle,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(l10n.newsletterDescription),
            ],
          ),
        ),
        const SizedBox(width: 30),
        SizedBox(
          width: 360,
          child: TextField(
            decoration: InputDecoration(
              hintText: l10n.newsletterEmailHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5B400),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          ),
          onPressed: () {},
          child: Text(
            l10n.newsletterSubscribe,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _newsletterMobile(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.newsletterTitle,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          l10n.newsletterDescriptionShort,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            hintText: l10n.newsletterEmailHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5B400),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          ),
          onPressed: () {},
          child: Text(
            l10n.newsletterSubscribe,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  /// =======================
  /// FOOTER DESKTOP / TABLET
  /// =======================
  Widget _footerDesktop(
      BuildContext context,
      AppLocalizations l10n,
      bool isTablet,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _brandBlock(context, l10n)),
        const SizedBox(width: 30),
        Expanded(
          child: _linksBlock(
            l10n.footerServices,
            [
              _FooterLink(l10n.footerHome, () => context.goNamed('home')),
              _FooterLink(l10n.footerOffers, () => context.go('/offers')),
              _FooterLink(l10n.footerInvestment, () => context.go('/investment')),
              _FooterLink(l10n.footerContact, () => context.go('/contact')),
              _FooterLink(l10n.footerAbout, () => context.go('/about')),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          child: _linksBlock(
            l10n.footerInformation,
            [
              _FooterLink(l10n.footerPrivacy, () {}),
              _FooterLink(l10n.footerSecurity, () {}),
              _FooterLink(l10n.footerTerms, () {}),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(child: _contactBlock(l10n)),
      ],
    );
  }

  Widget _footerMobile(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _brandBlock(context, l10n),
        const SizedBox(height: 40),
        _linksBlock(
          l10n.footerServices,
          [
            _FooterLink(l10n.footerHome, () => context.goNamed('home')),
            _FooterLink(l10n.footerOffers, () => context.go('/offers')),
            _FooterLink(l10n.footerInvestment, () => context.go('/investment')),
            _FooterLink(l10n.footerContact, () => context.go('/contact')),
            _FooterLink(l10n.footerAbout, () => context.go('/about')),
          ],
        ),
        const SizedBox(height: 30),
        _linksBlock(
          l10n.footerInformation,
          [
            _FooterLink(l10n.footerPrivacy, () {}),
            _FooterLink(l10n.footerSecurity, () {}),
            _FooterLink(l10n.footerTerms, () {}),
          ],
        ),
        const SizedBox(height: 30),
        _contactBlock(l10n),
      ],
    );
  }

  /// =======================
  /// BLOCS
  /// =======================
  Widget _brandBlock(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/favicon.png",
          height: 100,
        ),
        const Text(
          "KreditSch",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.footerBrandDescription,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF5B400),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          onPressed: () => context.goNamed('loan_simulation'),
          child: Text(
            l10n.footerSimulationButton,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _linksBlock(String title, List<_FooterLink> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map(
              (link) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: InkWell(
              onTap: link.onTap,
              hoverColor: Colors.white10,
              child: Text(
                link.label,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactBlock(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.footerContact,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        _ContactRow(Icons.location_on, l10n.footerAddress),
        _ContactRow(Icons.email, "kontakt@kreditsch.de",
            onTap: () => _launchURL("mailto:kontakt@kreditsch.de")),
        _ContactRow(Icons.phone, "+41 798079225",
            onTap: () => _launchURL("tel:+41798079225")),
        _ContactRow(Icons.access_time, l10n.footerOpeningHours),
      ],
    );
  }
}

class _FooterLink {
  final String label;
  final VoidCallback onTap;
  _FooterLink(this.label, this.onTap);
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const _ContactRow(this.icon, this.text, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
