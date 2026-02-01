import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../auth/supabase_admin_service.dart';
import '../pages/admin_dashboard_page.dart';
import '../auth/auth_gate.dart';
import '../auth/register_page.dart';
import '../../../../l10n/app_localizations.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1200;

        double height = isMobile ? 350 : isTablet ? 400 : 450;
        double textMaxWidth = isMobile ? constraints.maxWidth * 0.9 : 500;

        return SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// Image de fond
              Image.network(
                'https://images.unsplash.com/photo-1523958203904-cdcb402031fd',
                fit: BoxFit.cover,
              ),

              /// Overlay sombre
              Container(
                color: Colors.black.withOpacity(0.4),
              ),

              /// Texte
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 40,
                  vertical: isMobile ? 16 : 40,
                ),
                child: Align(
                  alignment:
                  isMobile ? Alignment.center : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: textMaxWidth),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.heroTitle,
                          textAlign:
                          isMobile ? TextAlign.center : TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.heroSubtitle,
                          textAlign:
                          isMobile ? TextAlign.center : TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 14 : 16,
                          ),
                        ),
                        const SizedBox(height: 30),

                        StreamBuilder<User?>(
                          stream:
                          FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            final user = snapshot.data;

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (user == null) {
                              return Row(
                                mainAxisAlignment: isMobile
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const AuthGate(),
                                        ),
                                      );
                                    },
                                    child: Text(l10n.heroLogin),
                                  ),
                                  const SizedBox(width: 20),
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                          const RegisterPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      l10n.heroRegister,
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return FutureBuilder<bool>(
                              future: SupabaseAdminService.isAdmin(
                                  user.email!),
                              builder: (context, adminSnapshot) {
                                if (adminSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (adminSnapshot.data == true) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                          const AdminDashboardPage(),
                                        ),
                                      );
                                    },
                                    child: Text(l10n.heroAdminAccess),
                                  );
                                }

                                return ElevatedButton(
                                  onPressed: () =>
                                      context.goNamed('dashboard'),
                                  child: Text(l10n.heroUserAccess),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
