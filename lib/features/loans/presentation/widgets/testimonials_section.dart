import 'package:flutter/material.dart';

class Testimonial {
  final String text;
  final String name;
  final String role;

  Testimonial(this.text, this.name, this.role);
}

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final List<Testimonial> testimonials = [
    Testimonial(
      "Grâce à ce service de prêt, j’ai pu lancer mon activité sans passer par une banque.",
      "Aïcha M.",
      "Entrepreneure",
    ),
    Testimonial(
      "Les conditions sont claires, les intérêts transparents et le remboursement flexible.",
      "Jean K.",
      "Commerçant",
    ),
    Testimonial(
      "J’ai obtenu un prêt rapidement pour une urgence familiale.",
      "Fatou S.",
      "Particulier",
    ),
    Testimonial(
      "Une plateforme fiable qui met en relation prêteurs et emprunteurs en toute confiance.",
      "Marc D.",
      "Investisseur privé",
    ),
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;
      setState(() {
        currentIndex = (currentIndex + 1) % testimonials.length;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;

    final double cardWidth = isMobile
        ? width * 0.9
        : isTablet
        ? 600
        : 720;

    final testimonial = testimonials[currentIndex];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 60 : 90,
        horizontal: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF061A3A), Color(0xFF0B2B5B)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Témoignages",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Text(
            "Nous bénéficions de la confiance de plus de 50 pays à travers le monde.",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 22 : 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),

          /// =========================
          /// CARTE AVIS
          /// =========================
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey(currentIndex),
              width: cardWidth,
              padding: EdgeInsets.all(isMobile ? 20 : 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ⭐⭐⭐⭐⭐
                  Row(
                    children: List.generate(
                      5,
                          (index) => const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFBBF24),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// TEXTE
                  Text(
                    testimonial.text,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: isMobile ? 14 : 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  /// PROFIL
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFF1E3A8A),
                        child: Text(
                          testimonial.name[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            testimonial.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            testimonial.role,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}