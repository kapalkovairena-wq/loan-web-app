import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../widgets/footer_section.dart';

class LoanSolutionSection extends StatelessWidget {
  const LoanSolutionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppHeader(),
                    _heroSection(isMobile, l10n),
                    const SizedBox(height: 80),
                    _whiteCards(isMobile, l10n),
                    const SizedBox(height: 80),
                    _divider(l10n),
                    const SizedBox(height: 80),
                    _greyCards(isMobile, l10n),
                    const SizedBox(height: 80),
                    const FooterSection(),
                  ],
                ),
              ),
            ),
          ),
          const WhatsAppButton(
            phoneNumber: "+4915774851991",
          ),
        ],
      ),
    );
  }

  // ---------------- HERO ----------------

  Widget _heroSection(bool isMobile, AppLocalizations l10n) {
    return isMobile
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroImage(),
        const SizedBox(height: 40),
        _heroContent(l10n),
      ],
    )
        : Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _heroImage()),
        const SizedBox(width: 60),
        Expanded(child: _heroContent(l10n)),
      ],
    );
  }

  Widget _heroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        'https://images.unsplash.com/photo-1521737604893-d14cc237f11d',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _heroContent(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.heroTitle2,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B1B3F),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.heroDescription,
          style: const TextStyle(
            color: Color(0xFF555555),
            height: 1.7,
          ),
        ),
        const SizedBox(height: 20),
        _Bullet(text: l10n.bulletFastLoans),
        _Bullet(text: l10n.bulletFlexibleDuration),
        _Bullet(text: l10n.bulletForAll),
        const SizedBox(height: 25),
        InkWell(
          onTap: () {},
          child: Text(
            l10n.heroCTA,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B1B3F),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- CARTES BLANCHES ----------------

  Widget _whiteCards(bool isMobile, AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final itemWidth = isMobile ? maxWidth : (maxWidth - 60) / 3;

        return Wrap(
          spacing: 30,
          runSpacing: 30,
          children: [
            _AnimatedCard(
              width: itemWidth,
              child: _Card(
                icon: "☂️",
                title: l10n.cardLowRisk,
                text: l10n.cardLowRiskDesc,
              ),
            ),
            _AnimatedCard(
              width: itemWidth,
              child: _Card(
                icon: "📌",
                title: l10n.cardTargeted,
                text: l10n.cardTargetedDesc,
              ),
            ),
            _AnimatedCard(
              width: itemWidth,
              child: _Card(
                icon: "💰",
                title: l10n.cardFlexibleAmount,
                text: l10n.cardFlexibleAmountDesc,
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------------- DIVIDER ----------------

  Widget _divider(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      color: const Color(0xFFE6E6E6),
      child: Text(
        l10n.dividerText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          color: Color(0xFF2B1B3F),
        ),
      ),
    );
  }

  // ---------------- CARTES GRISES ----------------

  Widget _greyCards(bool isMobile, AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final itemWidth = isMobile ? maxWidth : (maxWidth - 30) / 2;

        return Wrap(
          spacing: 30,
          runSpacing: 30,
          children: [
            _AnimatedCard(
              width: itemWidth,
              child: _Card(
                icon: "🎯",
                title: l10n.cardPersonalized,
                text: l10n.cardPersonalizedDesc,
                grey: true,
              ),
            ),
            _AnimatedCard(
              width: itemWidth,
              child: _Card(
                icon: "🌱",
                title: l10n.cardResponsible,
                text: l10n.cardResponsibleDesc,
                grey: true,
              ),
            ),
            _AnimatedCard(
              width: itemWidth,
              child: _Card(
                icon: "🏥",
                title: l10n.cardThematic,
                text: l10n.cardThematicDesc,
                grey: true,
              ),
            ),
            _AnimatedCard(
              width: itemWidth,
              child: _Card(
                icon: "🤝",
                title: l10n.cardPartners,
                text: l10n.cardPartnersDesc,
                grey: true,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ----------------- COMPONENTS (_AnimatedCard & _Card & _Bullet) -----------------

class _AnimatedCard extends StatefulWidget {
  final Widget child;
  final double width;

  const _AnimatedCard({required this.child, required this.width});

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(
          position: _offset,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        "– $text",
        style: const TextStyle(color: Color(0xFF555555)),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String icon;
  final String title;
  final String text;
  final bool grey;

  const _Card({
    required this.icon,
    required this.title,
    required this.text,
    this.grey = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      decoration: BoxDecoration(
        color: grey ? const Color(0xFFF0F0F0) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: grey
            ? []
            : const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B1B3F),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
