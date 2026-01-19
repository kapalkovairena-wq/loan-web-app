import 'dart:ui';
import 'package:flutter/material.dart';

class CreditServicesSection extends StatelessWidget {
  const CreditServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        const Text("Nos dossiers", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        const Text(
          "Nos services de crédit",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const SizedBox(
          width: 600,
          child: Text(
            "Nous proposons des solutions de financement flexibles et accessibles, adaptées à vos besoins personnels ou professionnels.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ),
        const SizedBox(height: 60),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              LoanImageCard(
                imageUrl:
                "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/financial-services-1536x1152.webp",
                overlayTitle: "Prêt personnel",
                overlayText:
                "Financez vos projets (voyages, équipements, mariages...) à un prix compétitif et avec une réponse rapide.",
              ),
              LoanImageCard(
                imageUrl:
                "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/business-team-collaboration-discussing-working-analysis-with-financial-data-and-marketing-growth-1536x1024.webp",
                overlayTitle: "Prêt professionnel",
                overlayText:
                "Une solution simple et rapide pour soutenir votre entreprise : approvisionnement en matériel, trésorerie, développement.",
              ),
              LoanImageCard(
                imageUrl:
                "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/financial-statistics-1536x1024.webp",
                overlayTitle: "Lignes de crédit flexibles",
                overlayText:
                "Accès rapide à des fonds immédiatement disponibles, sans obligation de les utiliser immédiatement.",
              ),
              LoanImageCard(
                imageUrl:
                "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/business-team-casual-collaboration-discussing-working-analysis-with-financial-data-and-marketing-1536x864.webp",
                overlayTitle: "Simulation et enquête",
                overlayText:
                "Estimez votre solde créditeur et soumettez votre demande directement depuis notre plateforme, sans aucun document papier.",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            /// IMAGE
            Image.network(
              widget.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            /// OVERLAY SOMBRE LÉGER
            Container(
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

            /// OVERLAY TEXTE BLEU TRANSPARENT
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: _isOpen ? 0 : -120,
              left: 0,
              right: 0,
              height: 120,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color(0xFF1E3A8A).withOpacity(0.75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.overlayTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.overlayText,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4,
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