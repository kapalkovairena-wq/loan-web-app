import 'package:flutter/material.dart';

import '../pages/loan_request_page.dart';

/// =======================
/// SECTION PRINCIPALE
/// =======================
class LoanFeaturesSection extends StatelessWidget {
  const LoanFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        LoanFeature(
          title: "Financez vos projets personnels simplement",
          description:
          "Obtenez un prêt privé flexible pour vos besoins personnels avec des intérêts transparents et un remboursement adapté.",
          imageUrl:
          "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/CRST-6687_Hom.webp",
        ),
        LoanFeature(
          title: "Soutenez les entrepreneurs et PME",
          description:
          "Investissez ou empruntez pour développer une activité grâce à notre réseau de prêteurs privés vérifiés.",
          imageUrl:
          "https://images.unsplash.com/photo-1556761175-4b46a572b786",
          imageLeft: false,
        ),
        LoanFeature(
          title: "Prêt rapide, sans procédure bancaire lourde",
          description:
          "Validation rapide, pénalités claires et conditions définies à l’avance entre prêteur et emprunteur.",
          imageUrl:
          "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/logo%20(1600%20x%201600%20px).png",
        ),
      ],
    );
  }
}

/// =======================
/// FEATURE RESPONSIVE
/// =======================
class LoanFeature extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final bool imageLeft;

  const LoanFeature({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.imageLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        /// Breakpoints
        final bool isMobile = width < 700;
        final bool isTablet = width >= 700 && width < 1100;

        /// Ratios image / texte
        final int imageFlex = isMobile ? 0 : isTablet ? 5 : 6;
        final int textFlex = isMobile ? 0 : isTablet ? 5 : 4;

        final double titleSize = isMobile ? 22.0 : isTablet ? 26.0 : 32.0;
        final double descriptionSize = isMobile ? 14.0 : 16.0;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20.0 : 80.0,
            vertical: isMobile ? 40.0 : 70.0,
          ),
          child: isMobile
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _image(width),
              const SizedBox(height: 24),
              _textColumn(
                context,
                titleSize,
                descriptionSize,
                TextAlign.center,
              ),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (imageLeft)
                Expanded(
                  flex: imageFlex,
                  child: _image(),
                ),
              Expanded(
                flex: textFlex,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: _textColumn(
                    context,
                    titleSize,
                    descriptionSize,
                    TextAlign.start,
                  ),
                ),
              ),
              if (!imageLeft)
                Expanded(
                  flex: imageFlex,
                  child: _image(),
                ),
            ],
          ),
        );
      },
    );
  }

  /// =======================
  /// TEXTE
  /// =======================
  Widget _textColumn(
      BuildContext context,
      double titleSize,
      double descriptionSize,
      TextAlign align,
      ) {
    return Column(
      crossAxisAlignment:
      align == TextAlign.center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: align,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: align,
          style: TextStyle(
            fontSize: descriptionSize,
            color: Colors.black54,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LoanRequestPage(),
              ),
            );
          },
          child: const Text(
            "Demander un prêt >",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ],
    );
  }

  /// =======================
  /// IMAGE
  /// =======================
  Widget _image([double? containerWidth]) {
    final double imageHeight =
    containerWidth != null ? containerWidth * 0.6 : 300.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: imageHeight,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            height: imageHeight,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (_, __, ___) {
          return Container(
            height: imageHeight,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, size: 40),
          );
        },
      ),
    );
  }
}
