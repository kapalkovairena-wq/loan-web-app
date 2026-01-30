import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WhyChooseUsLoanSection extends StatelessWidget {
  const WhyChooseUsLoanSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return Column(
      children: [
        _TopDarkSection(isMobile: isMobile, isTablet: isTablet),
        _BottomImageSection(isMobile: isMobile, isTablet: isTablet),
      ],
    );
  }
}

/// =======================
/// PARTIE BLEUE (TOP)
/// =======================
class _TopDarkSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _TopDarkSection({required this.isMobile, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isMobile ? 16.0 : 60.0;
    final verticalPadding = isMobile ? 30.0 : 80.0;

    // Ajustement de police
    final titleFontSize = isMobile ? 22.0 : 34.0;
    final subtitleFontSize = isMobile ? 14.0 : 20.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      color: const Color(0xFF061A3A),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TextColumn(context, titleFontSize, subtitleFontSize),
          const SizedBox(height: 20),
          _YellowCard(isMobile: isMobile),
        ],
      )
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _TextColumn(context, titleFontSize, subtitleFontSize)),
          const SizedBox(width: 40),
          Expanded(flex: 2, child: _YellowCard(isMobile: isMobile)),
        ],
      ),
    );
  }

  Widget _TextColumn(BuildContext context, double titleFontSize, double subtitleFontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pourquoi nous ?',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Votre partenaire de prêts privés de confiance',
          style: TextStyle(
            color: Colors.white,
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Nous combinons rapidité, transparence et accompagnement '
              'personnalisé pour vous offrir des solutions de prêts simples, '
              'efficaces et adaptées à vos objectifs.',
          style: TextStyle(color: Colors.white70, height: 1.6, fontSize: subtitleFontSize),
        ),
        const SizedBox(height: 40),
        _progress('Rapidité de traitement', 0.95),
        const SizedBox(height: 20),
        _progress('Sécurité & fiabilité', 0.98),
        const SizedBox(height: 30),
        _checkItem('Amélioration continue de nos offres'),
        _checkItem('Engagement envers nos clients'),
        _checkItem('Conditions claires et sans surprise'),
        const SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          ),
          onPressed: () =>
              context.go('/request'),
          child: const Text(
            'Faire une demande',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _YellowCard({required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 40),
      color: Colors.amber,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline, size: 40),
          SizedBox(height: 20),
          Text(
            'Vous développez vos projets,\n'
                'nous finançons votre ambition.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _progress(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            Text('${(value * 100).round()}%', style: const TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation(Colors.amber),
        ),
      ],
    );
  }

  Widget _checkItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.amber),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

/// =======================
/// IMAGE + TEXTE (BOTTOM)
/// =======================
class _BottomImageSection extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _BottomImageSection({required this.isMobile, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isMobile ? 16.0 : 60.0;
    final verticalPadding = isMobile ? 20.0 : 60.0;

    return Column(
      children: [
        Image.network(
          'https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/Screenshot_2026-01-19-04-24-55-829_com.android.chrome-edit.jpg',
          width: double.infinity,
          height: isMobile ? 200 : 420,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          child: isMobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BottomText(),
              const SizedBox(height: 20),
              _BottomButton(),
            ],
          )
              : Row(
            children: [
              Expanded(child: const _BottomText()),
              _BottomButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomText extends StatelessWidget {
  const _BottomText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Nos solutions de financement',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          'Bien plus qu’un prêt, nous vous accompagnons à chaque étape '
              'de votre projet personnel ou professionnel.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}

class _BottomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
      ),
      onPressed: () =>
          context.go('/offers'),
      child: const Text('Voir les offres', style: TextStyle(color: Colors.black)),
    );
  }
}
