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
    final testimonial = testimonials[currentIndex];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
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
          const Text(
            "Nous bénéficions de la confiance de plus de 50 pays à travers le monde.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: Container(
              key: ValueKey(currentIndex),
              margin: const EdgeInsets.symmetric(horizontal: 120),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testimonial.text,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    testimonial.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    testimonial.role,
                    style: const TextStyle(color: Colors.black54),
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