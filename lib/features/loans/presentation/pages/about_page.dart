import 'package:flutter/material.dart';
import 'dart:async';
import 'package:visibility_detector/visibility_detector.dart';

import '../widgets/app_header.dart';
import '../widgets/hero_banner.dart';
import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../widgets/footer_section.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
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
    return VisibilityDetector(
      key: const Key('about-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.4) {
          _startAnimation();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF071C3A), Color(0xFF020D1F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            _topBoxes(),
            const SizedBox(height: 70),
            _statsRow(),
          ],
        ),
      ),
    );
  }

  Widget _topBoxes() {
    return Wrap(
      spacing: 30,
      runSpacing: 30,
      children: [
        _aboutBox(
          background: Colors.white,
          textColor: Colors.black,
          title: "Notre vision et notre mission",
          content:
          "Chez KreditSch, nous simplifions l’accès au crédit en proposant "
              "des solutions de prêts rapides, transparentes et adaptées "
              "à chaque profil, afin de redonner à chacun le contrôle de ses projets financiers.",
        ),
        _aboutBox(
          background: const Color(0xFFF6B400),
          textColor: Colors.white,
          title: "Solutions de prêts intelligentes",
          content:
          "KreditSch est reconnue pour ses offres de prêts personnels, "
              "professionnels et d’urgence, alliant rapidité, sécurité "
              "et conditions flexibles pour accompagner chaque étape de votre vie.",
        ),
      ],
    );
  }

  Widget _aboutBox({
    required Color background,
    required Color textColor,
    required String title,
    required String content,
  }) {
    return Container(
      width: 520,
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
          const SizedBox(height: 15),
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

  Widget _statsRow() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 50,
          runSpacing: 30,
          children: [
            _stat(stat1.value, "Demandes de prêts approuvées"),
            _stat(stat2.value, "Types de prêts disponibles"),
            _stat(stat3.value, "Années d’expertise financière"),
            _stat(stat4.value, "Experts crédit dédiés"),
          ],
        );
      },
    );
  }

  Widget _stat(int value, String label) {
    return SizedBox(
      width: 220,
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: value.toString(),
                  style: const TextStyle(
                    fontSize: 38,
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
          const SizedBox(height: 10),
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


class LoanExpertiseSection extends StatelessWidget {
  const LoanExpertiseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
      SingleChildScrollView(
      child: Column(
      children: [
        AppHeader(),
        const SizedBox(height: 20),
        HeroBanner(),
        const SizedBox(height: 20),
        // ================= IMAGE SECTION =================
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 420,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/loan_team.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Bouton contact flottant
            Positioned(
              right: 40,
              bottom: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black26,
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.chat, color: Color(0xFFF5B400)),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Écrivez-nous",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("(+49) 1577 4851991"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ================= TEXTE =================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Label
              Row(
                children: const [
                  Text(
                    "Via KreditSch",
                    style: TextStyle(
                      color: Color(0xFFF5B400),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFF5B400),
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Titre
              const Text(
                "Des solutions de prêt adaptées à chaque projet",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1C3E),
                ),
              ),

              const SizedBox(height: 20),

              // Description
              const SizedBox(
                width: 800,
                child: Text(
                  "KreditSch accompagne particuliers et entrepreneurs avec des solutions de prêt fiables, transparentes et rapides, adaptées à vos besoins financiers réels.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // ================= FEATURES =================

              Wrap(
                spacing: 80,
                runSpacing: 40,
                children: const [
                  _FeatureItem(
                    icon: Icons.trending_up,
                    title: "Prêt personnel flexible",
                    description:
                    "Financez vos projets personnels avec des conditions claires et sans surprise.",
                  ),
                  _FeatureItem(
                    icon: Icons.business_center,
                    title: "Prêt professionnel",
                    description:
                    "Un soutien financier solide pour développer votre activité en toute sérénité.",
                  ),
                  _FeatureItem(
                    icon: Icons.schedule,
                    title: "Décaissement rapide",
                    description:
                    "Recevez vos fonds rapidement après validation de votre dossier.",
                  ),
                  _FeatureItem(
                    icon: Icons.verified,
                    title: "Processus sécurisé",
                    description:
                    "Vos données sont protégées selon les normes les plus strictes.",
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
        const AboutPage(),
        const SizedBox(height: 60),
        const TestimonialsSection(),
        const SizedBox(height: 60),
        const TeamSection(),
        const SizedBox(height: 60),
        FooterSection(),
      ],
    ),
      ),
          const WhatsAppButton(
            phoneNumber: "+4915774851991",
            message: "Bonjour, je souhaite plus d'informations sur vos prêts.",
          ),
        ],
      )
    );
  }
}

// ================= FEATURE ITEM =================
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 420,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Color(0xFFF5B400)),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


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
          child: Image.asset(
            "assets/images/loan_team.jpg",
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
                "Nous bénéficions de la confiance de milliers de clients\nà travers l’Europe.",
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

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// IMAGE (gauche)
              Expanded(
                flex: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    'assets/images/loan_team.jpg', // remplace par ton image
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 60),

              /// TEXTE (droite)
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Notre équipe',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B1B5A), // violet foncé
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Fondée par des experts de la finance et du digital, '
                          'KreditSch accompagne depuis plusieurs années des milliers '
                          'de clients dans la réalisation de leurs projets grâce à '
                          'des solutions de prêt simples, rapides et transparentes.\n\n'
                          'Notre équipe internationale travaille chaque jour avec '
                          'une seule ambition : rendre l’accès au crédit plus juste, '
                          'plus humain et accessible à tous.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color: Color(0xFF6B6B6B),
                      ),
                    ),
                    SizedBox(height: 28),
                    _ActionLink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lien CTA (identique au style Finivo)
class _ActionLink extends StatelessWidget {
  const _ActionLink();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // TODO : navigation vers page prêts
          // Navigator.pushNamed(context, '/loans');
        },
        child: Text(
          'Découvrez nos solutions de prêt >',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6A1FD2),
          ),
        ),
      ),
    );
  }
}