import 'package:flutter/material.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF071C3A),
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
          children: [
      /// =======================
      /// TITRES
      /// =======================
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Pourquoi nous choisir ?',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Une communauté internationale de milliers de clients\n'
                'nous fait confiance.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
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
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),

    const SizedBox(height: 60),

    /// =======================
    /// BLOCS JAUNE / BLANC
    /// =======================
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 80),
    child: Column(
    children: const [
    Row(
    children: [
    Expanded(
    child: _InfoBox(
    text: 'Personnel qualifié',
    isYellow: false,
    ),
    ),
    SizedBox(width: 20),
    Expanded(
    child: _InfoBox(
    text: 'Consultation gratuite',
    isYellow: true,
    ),
    ),
    ],
    ),
    SizedBox(height: 20),
    Row(
    children: [
    Expanded(
    child: _InfoBox(
    text: 'Vous gagnez du temps',
    isYellow: true,
    ),
    ),
    SizedBox(width: 20),
    Expanded(
    child: _InfoBox(
    text: 'Qualité de service optimale',
    isYellow: false,
    ),
    ),
    ],
    ),
    ],
    ),
    ),

    const SizedBox(height: 80),

    /// =======================
    /// STATISTIQUES
    /// =======================
    Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 60),
    child: const Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    _CounterItem(
    value: 2245,
    label: 'Clients satisfaits',
    ),
    _CounterItem(value: 10,
      label: 'Années d’activité',
    ),
      _CounterItem(
        value: 15,
        label: 'Experts financiers',
      ),
      _CounterItem(
        value: 12,
        label: 'Partenaires actifs',
      ),
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

  const _InfoBox({
    required this.text,
    required this.isYellow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
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
          Text(
            text,
            style: TextStyle(
              color: isYellow ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
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

  const _CounterItem({
    required this.value,
    required this.label,
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
      duration: const Duration(seconds: 2),
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
          children: [
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