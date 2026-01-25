import 'package:flutter/material.dart';
import 'dart:async';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  final testimonials = const [
    _Testimonial(
      text:
      "Grâce à KreditSch, j’ai obtenu un prêt professionnel en moins de 24 heures. "
          "Les conditions étaient claires et adaptées à ma situation. Une vraie solution fiable.",
      name: "Martin K.",
      role: "Entrepreneur – Berlin",
    ),
    _Testimonial(
      text:
      "J’avais besoin d’un financement urgent pour des frais médicaux. "
          "KreditSch a été rapide, humain et transparent. Je recommande sans hésiter.",
      name: "Sophie L.",
      role: "Salariée – Lyon",
    ),
    _Testimonial(
      text:
      "L’interface est simple et le suivi du prêt est très clair. "
          "KreditSch m’a permis de concrétiser mon projet immobilier sereinement.",
      name: "Julien R.",
      role: "Investisseur – Bruxelles",
    ),
    _Testimonial(
      text:
      "Enfin une plateforme de prêt qui comprend les indépendants. "
          "Aucune surprise, tout est expliqué dès le départ.",
      name: "Nadia B.",
      role: "Freelance – Paris",
    ),
    _Testimonial(
      text:
      "Un service client réactif et des offres adaptées. "
          "KreditSch m’a accompagné du début à la fin.",
      name: "Thomas W.",
      role: "Dirigeant PME – Munich",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
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
    return Stack(
      children: [
        // IMAGE DE FOND
        Positioned.fill(
          child: Image.network(
            "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/CRST-6687_Hom.webp",
            fit: BoxFit.cover,
          ),
        ),

        // OVERLAY (rend l'image discrète)
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

        // CONTENU
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 100),
          child: Column(
            children: [
              const Text(
                "Témoignages",
                style: TextStyle(
                  color: Color(0xFFF6B400),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Nous bénéficions de la confiance de milliers de clients à travers l’Europe.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "La satisfaction de nos clients est notre priorité. "
                    "Découvrez ce qu’ils pensent de leur expérience avec KreditSch.",
                textAlign: TextAlign.center,
                style: TextStyle(
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

// ---------------- CARD ----------------

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
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
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

// ---------------- MODEL ----------------

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