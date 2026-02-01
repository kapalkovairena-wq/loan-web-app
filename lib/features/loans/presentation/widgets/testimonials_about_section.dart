import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../l10n/app_localizations.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  late List<_Testimonial> testimonials;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (testimonials.isEmpty) return;

      _currentIndex = (_currentIndex + 1) % testimonials.length;
      _controller.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    testimonials = [
      _Testimonial(
        text: l10n.testimonial1Text,
        name: l10n.testimonial1Name,
        role: l10n.testimonial1Role,
      ),
      _Testimonial(
        text: l10n.testimonial2Text,
        name: l10n.testimonial2Name,
        role: l10n.testimonial2Role,
      ),
      _Testimonial(
        text: l10n.testimonial3Text,
        name: l10n.testimonial3Name,
        role: l10n.testimonial3Role,
      ),
      _Testimonial(
        text: l10n.testimonial4Text,
        name: l10n.testimonial4Name,
        role: l10n.testimonial4Role,
      ),
      _Testimonial(
        text: l10n.testimonial5Text,
        name: l10n.testimonial5Name,
        role: l10n.testimonial5Role,
      ),
      _Testimonial(
        text: l10n.testimonial6Text,
        name: l10n.testimonial6Name,
        role: l10n.testimonial6Role,
      ),
      _Testimonial(
        text: l10n.testimonial7Text,
        name: l10n.testimonial7Name,
        role: l10n.testimonial7Role,
      ),
      _Testimonial(
        text: l10n.testimonial8Text,
        name: l10n.testimonial8Name,
        role: l10n.testimonial8Role,
      ),
      _Testimonial(
        text: l10n.testimonial9Text,
        name: l10n.testimonial9Name,
        role: l10n.testimonial9Role,
      ),
    ];

    return Stack(
      children: [
        /// IMAGE DE FOND
        Positioned.fill(
          child: Image.network(
            "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/CRST-6687_Hom.webp",
            fit: BoxFit.cover,
          ),
        ),

        /// OVERLAY
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.75),
                  Colors.black.withOpacity(0.55),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        /// CONTENU
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: [
              Text(
                l10n.testimonialsLabel,
                style: const TextStyle(
                  color: Color(0xFFF6B400),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.testimonialsTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.testimonialsSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 60),

              SizedBox(
                height: 260,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: testimonials.length,
                  itemBuilder: (context, index) {
                    return _TestimonialCard(
                      testimonial: testimonials[index],
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  testimonials.length,
                      (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? const Color(0xFFF6B400)
                          : Colors.white30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/* ---------------- CARD ---------------- */

class _TestimonialCard extends StatelessWidget {
  final _Testimonial testimonial;

  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 25,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              testimonial.text,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFE5E7EB),
                  child: Icon(Icons.person, color: Colors.black54),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      testimonial.role,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  "❝",
                  style: TextStyle(
                    fontSize: 50,
                    color: Color(0xFFF6B400),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- MODEL ---------------- */

class _Testimonial {
  final String text;
  final String name;
  final String role;

  const _Testimonial({
    required this.text,
    required this.name,
    required this.role,
  });
}
