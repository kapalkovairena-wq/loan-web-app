import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

import '../widgets/app_header.dart';
import '../widgets/app_drawer.dart';
import '../widgets/whatsApp_button.dart';
import '../widgets/footer_section.dart';
import '../widgets/team_section.dart';
import '../widgets/loan_expertise_section.dart';
import '../widgets/testimonials_about_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;
    final isTablet = width >= 700 && width < 1100;

    double horizontalPadding() {
      if (isMobile) return 16;
      if (isTablet) return 40;
      return 120;
    }

    double featureItemWidth() {
      if (isMobile) return double.infinity;
      if (isTablet) return (width - horizontalPadding() * 2 - 40) / 2;
      return 420;
    }

    return Scaffold(
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const AppHeader(),

                // ================= IMAGE SECTION =================
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: isMobile ? 250 : 420,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1521791136064-7986c2920216',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: isMobile ? 16 : 40,
                      bottom: isMobile ? 16 : 40,
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
                          children: [
                            const Icon(Icons.chat,
                                color: Color(0xFFF5B400)),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.aboutContactUs,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("(+49) 1577 4851991"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // ================= TEXT =================
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding(),
                    vertical: 60,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            t.aboutLabel,
                            style: const TextStyle(
                              color: Color(0xFFF5B400),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFF5B400),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text(
                        t.aboutTitle,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B1C3E),
                        ),
                      ),
                      const SizedBox(height: 20),

                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isMobile ? double.infinity : 800,
                        ),
                        child: Text(
                          t.aboutDescription,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),

                      isMobile
                          ? Column(
                        children: [
                          for (var feature in [
                            _FeatureItem(
                              icon: Icons.trending_up,
                              title: t.aboutFeaturePersonalLoanTitle,
                              description:
                              t.aboutFeaturePersonalLoanDesc,
                            ),
                            _FeatureItem(
                              icon: Icons.business_center,
                              title:
                              t.aboutFeatureBusinessLoanTitle,
                              description:
                              t.aboutFeatureBusinessLoanDesc,
                            ),
                            _FeatureItem(
                              icon: Icons.schedule,
                              title:
                              t.aboutFeatureFastPaymentTitle,
                              description:
                              t.aboutFeatureFastPaymentDesc,
                            ),
                            _FeatureItem(
                              icon: Icons.verified,
                              title:
                              t.aboutFeatureSecurityTitle,
                              description:
                              t.aboutFeatureSecurityDesc,
                            ),
                          ])
                            Padding(
                              padding:
                              const EdgeInsets.only(bottom: 40),
                              child: SizedBox(
                                width: featureItemWidth(),
                                child: feature,
                              ),
                            ),
                        ],
                      )
                          : Wrap(
                        spacing: 40,
                        runSpacing: 40,
                        children: [
                          _FeatureItem(
                            icon: Icons.trending_up,
                            title:
                            t.aboutFeaturePersonalLoanTitle,
                            description:
                            t.aboutFeaturePersonalLoanDesc,
                          ),
                          _FeatureItem(
                            icon: Icons.business_center,
                            title:
                            t.aboutFeatureBusinessLoanTitle,
                            description:
                            t.aboutFeatureBusinessLoanDesc,
                          ),
                          _FeatureItem(
                            icon: Icons.schedule,
                            title:
                            t.aboutFeatureFastPaymentTitle,
                            description:
                            t.aboutFeatureFastPaymentDesc,
                          ),
                          _FeatureItem(
                            icon: Icons.verified,
                            title:
                            t.aboutFeatureSecurityTitle,
                            description:
                            t.aboutFeatureSecurityDesc,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const LoanExpertiseSection(),
                const TestimonialsSection(),
                const TeamSection(),
                const FooterSection(),
              ],
            ),
          ),
          const WhatsAppButton(
            phoneNumber: "+4915774851991",
          ),
        ],
      ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 40, color: const Color(0xFFF5B400)),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
