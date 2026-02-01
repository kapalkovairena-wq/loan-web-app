import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../l10n/app_localizations.dart';

class LoanExpertiseSection extends StatefulWidget {
  const LoanExpertiseSection({super.key});

  @override
  State<LoanExpertiseSection> createState() => _LoanExpertiseSectionState();
}

class _LoanExpertiseSectionState extends State<LoanExpertiseSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _started = false;

  late Animation<int> stat1;
  late Animation<int> stat2;
  late Animation<int> stat3;
  late Animation<int> stat4;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    stat1 = IntTween(begin: 0, end: 2245).animate(_controller);
    stat2 = IntTween(begin: 0, end: 10).animate(_controller);
    stat3 = IntTween(begin: 0, end: 15).animate(_controller);
    stat4 = IntTween(begin: 0, end: 12).animate(_controller);
  }

  void _startAnimation() {
    if (!_started) {
      _started = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final isTablet = width >= 700 && width < 1100;

    double horizontalPadding() {
      if (isMobile) return 16;
      if (isTablet) return 40;
      return 80;
    }

    double boxWidth() {
      if (isMobile) return double.infinity;
      if (isTablet) return (width - horizontalPadding() * 2 - 30) / 2;
      return 520;
    }

    double statWidth() {
      if (isMobile) return width - horizontalPadding() * 2;
      if (isTablet) return (width - horizontalPadding() * 2 - 30) / 2;
      return 220;
    }

    return VisibilityDetector(
      key: const Key('loan-expertise-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3) {
          _startAnimation();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding(),
          vertical: 60,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF071C3A), Color(0xFF020D1F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // ================= TOP BOXES =================
            Wrap(
              spacing: 30,
              runSpacing: 30,
              children: [
                _aboutBox(
                  width: boxWidth(),
                  background: Colors.white,
                  textColor: Colors.black,
                  title: l10n.loanVisionTitle,
                  content: l10n.loanVisionContent,
                ),
                _aboutBox(
                  width: boxWidth(),
                  background: const Color(0xFFF6B400),
                  textColor: Colors.white,
                  title: l10n.loanSolutionsTitle,
                  content: l10n.loanSolutionsContent,
                ),
              ],
            ),

            const SizedBox(height: 60),

            // ================= STATISTICS =================
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Wrap(
                  alignment:
                  isMobile ? WrapAlignment.center : WrapAlignment.start,
                  spacing: 30,
                  runSpacing: 30,
                  children: [
                    _stat(
                      width: statWidth(),
                      icon: Icons.check_circle_outline,
                      value: stat1.value,
                      label: l10n.loanStatApproved,
                    ),
                    _stat(
                      width: statWidth(),
                      icon: Icons.monetization_on_outlined,
                      value: stat2.value,
                      label: l10n.loanStatTypes,
                    ),
                    _stat(
                      width: statWidth(),
                      icon: Icons.calendar_today_outlined,
                      value: stat3.value,
                      label: l10n.loanStatExperience,
                    ),
                    _stat(
                      width: statWidth(),
                      icon: Icons.person_outline,
                      value: stat4.value,
                      label: l10n.loanStatExperts,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutBox({
    required double width,
    required Color background,
    required Color textColor,
    required String title,
    required String content,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat({
    required double width,
    required IconData icon,
    required int value,
    required String label,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: value.toString(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: "+",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
