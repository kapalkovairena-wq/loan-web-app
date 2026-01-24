import 'package:flutter/material.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    final horizontalPadding = isMobile ? 16.0 : isTablet ? 40.0 : 80.0;
    final blockSpacing = isMobile ? 16.0 : 20.0;
    final blockHeight = isMobile ? 70.0 : 90.0;
    final titleFontSize = isMobile ? 28.0 : 36.0;
    final subtitleFontSize = isMobile ? 14.0 : 16.0;

    return Container(
      width: double.infinity,
      color: const Color(0xFF071C3A),
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          /// =======================
          /// TITRES
          /// =======================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pourquoi nous choisir ?',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Une communauté internationale de milliers de clients\nnous fait confiance.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Particuliers, entrepreneurs et professionnels choisissent '
                      'nos solutions de prêts pour leur simplicité, leur rapidité '
                      'et la clarté de leurs conditions.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: subtitleFontSize,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 60),

          /// =======================
          /// BLOCS JAUNE / BLANC
          /// =======================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                isMobile
                    ? Column(
                  children: [
                    _InfoBox(text: 'Personnel qualifié', isYellow: false, height: blockHeight),
                    SizedBox(height: blockSpacing),
                    _InfoBox(text: 'Consultation gratuite', isYellow: true, height: blockHeight),
                    SizedBox(height: blockSpacing),
                    _InfoBox(text: 'Vous gagnez du temps', isYellow: true, height: blockHeight),
                    SizedBox(height: blockSpacing),
                    _InfoBox(text: 'Qualité de service optimale', isYellow: false, height: blockHeight),
                  ],
                )
                    : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _InfoBox(text: 'Personnel qualifié', isYellow: false, height: blockHeight)),
                        SizedBox(width: blockSpacing),
                        Expanded(child: _InfoBox(text: 'Consultation gratuite', isYellow: true, height: blockHeight)),
                      ],
                    ),
                    SizedBox(height: blockSpacing),
                    Row(
                      children: [
                        Expanded(child: _InfoBox(text: 'Vous gagnez du temps', isYellow: true, height: blockHeight)),
                        SizedBox(width: blockSpacing),
                        Expanded(child: _InfoBox(text: 'Qualité de service optimale', isYellow: false, height: blockHeight)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 80),

          /// =======================
          /// STATISTIQUES
          /// =======================
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: horizontalPadding),
            child: isMobile
                ? Column(
              children: [
                _CounterItem(value: 2245, label: 'Clients satisfaits', icon: Icons.people),
                SizedBox(height: 20),
                _CounterItem(value: 10, label: 'Années d’activité', icon: Icons.timeline),
                SizedBox(height: 20),
                _CounterItem(value: 15, label: 'Experts financiers', icon: Icons.military_tech),
                SizedBox(height: 20),
                _CounterItem(value: 12, label: 'Partenaires actifs', icon: Icons.handshake),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _CounterItem(value: 2245, label: 'Clients satisfaits', icon: Icons.people),
                _CounterItem(value: 10, label: 'Années d’activité', icon: Icons.timeline),
                _CounterItem(value: 15, label: 'Experts financiers', icon: Icons.military_tech),
                _CounterItem(value: 12, label: 'Partenaires actifs', icon: Icons.handshake),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String text;
  final bool isYellow;
  final double height;

  const _InfoBox({
    required this.text,
    required this.isYellow,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isYellow ? Colors.amber : Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified,
            color: isYellow ? Colors.white : Colors.amber,
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: isYellow ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterItem extends StatefulWidget {
  final int value;
  final String label;
  final IconData icon; // <- nouvel attribut

  const _CounterItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  State<_CounterItem> createState() => _CounterItemState();
}

class _CounterItemState extends State<_CounterItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = IntTween(
      begin: 0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 36, color: Colors.amber), // <- icône ajoutée
            const SizedBox(height: 12),
            Text(
              '${_animation.value}+',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF071C3A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ],
        );
      },
    );
  }
}