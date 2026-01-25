import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;

        return Container(
          height: 90,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// MENU
              IconButton(
                icon: const Icon(Icons.menu, size: 26),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),

              /// LOGO CENTRÉ
              Expanded(
                child: Center(
                  child: Image.network(
                    "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/logo.png",
                    height: isMobile ? 42 : 48,
                  ),
                ),
              ),

              /// CONTACT PREMIUM
              _PremiumContactCard(isMobile: isMobile),
            ],
          ),
        );
      },
    );
  }
}

/* ---------------- CONTACT CARD ---------------- */

class _PremiumContactCard extends StatelessWidget {
  final bool isMobile;

  const _PremiumContactCard({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF6B400),
              ),
              child: const Icon(
                Icons.phone,
                size: 16,
                color: Colors.white,
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 10),
              const Text(
                '+41 79 807 92 25',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
