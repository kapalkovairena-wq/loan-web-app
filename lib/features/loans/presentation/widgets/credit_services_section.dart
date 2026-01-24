import 'dart:ui';
import 'package:flutter/material.dart';

class CreditServicesSection extends StatelessWidget {
  const CreditServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    /// Breakpoints
    final bool isMobile = width < 1000;

    /// 1 carte mobile, 2 partout ailleurs
    final int crossAxisCount = isMobile ? 1 : 2;

    return Column(
      children: [
        const SizedBox(height: 80),

        /// =======================
        /// TITRES
        /// =======================
        const Text(
          "Nos dossiers",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        const Text(
          "Nos services de crédit",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: isMobile ? double.infinity : 600,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Nous proposons des solutions de financement flexibles et accessibles, adaptées à vos besoins personnels ou professionnels.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),

        const SizedBox(height: 60),

        /// =======================
        /// GRID RESPONSIVE
        /// =======================
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 80,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: isMobile ? 1.25 : 1.6,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              final card = _cards[index];
              return LoanImageCard(
                imageUrl: card.image,
                overlayTitle: card.title,
                overlayText: card.text,
              );
            },
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }
}

/// =======================
/// DATA SOURCE
/// =======================
class _CardData {
  final String image;
  final String title;
  final String text;

  const _CardData(this.image, this.title, this.text);
}

const List<_CardData> _cards = [
  _CardData(
    "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/financial-services-1536x1152.webp",
    "Prêt personnel",
    "Financez vos projets (voyages, équipements, mariages...) à un prix compétitif et avec une réponse rapide.",
  ),
  _CardData(
    "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/business-team-collaboration-discussing-working-analysis-with-financial-data-and-marketing-growth-1536x1024.webp",
    "Prêt professionnel",
    "Une solution simple et rapide pour soutenir votre entreprise : approvisionnement, trésorerie, développement.",
  ),
  _CardData(
    "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/financial-statistics-1536x1024.webp",
    "Lignes de crédit flexibles",
    "Accès rapide à des fonds immédiatement disponibles, sans obligation d’utilisation immédiate.",
  ),
  _CardData(
    "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/business-team-casual-collaboration-discussing-working-analysis-with-financial-data-and-marketing-1536x864.webp",
    "Simulation et enquête",
    "Estimez votre capacité de crédit et soumettez votre demande directement en ligne.",
  ),
];

/// =======================
/// CARTE IMAGE
/// =======================
class LoanImageCard extends StatefulWidget {
  final String imageUrl;
  final String overlayTitle;
  final String overlayText;

  const LoanImageCard({
    super.key,
    required this.imageUrl,
    required this.overlayTitle,
    required this.overlayText,
  });

  @override
  State<LoanImageCard> createState() => _LoanImageCardState();
}

class _LoanImageCardState extends State<LoanImageCard> {
  bool _isOpen = false;

  void _toggle() => setState(() => _isOpen = !_isOpen);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            /// IMAGE
            Positioned.fill(
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            /// OVERLAY SOMBRE
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),

            /// TEXTE GLASSMORPHISM
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: _isOpen ? 0 : -110,
              left: 0,
              right: 0,
              height: 110,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    color: const Color(0xFF1E3A8A).withOpacity(0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.overlayTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.overlayText,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
