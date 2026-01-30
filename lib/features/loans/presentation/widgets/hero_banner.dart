import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:go_router/go_router.dart';
import '../auth/supabase_admin_service.dart';


class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Détecte le type d'appareil
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1200;

        // Hauteur adaptable selon device
        double height = isMobile ? 350 : isTablet ? 400 : 450;

        // Largeur maximale du texte
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
                    vertical: isMobile ? 16 : 40),
                child: Align(
                  alignment: isMobile ? Alignment.center : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: textMaxWidth),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Des services de prêts\npour développer votre entreprise',
                          textAlign: isMobile ? TextAlign.center : TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Une solution moderne, simple et sécurisée pour gérer vos prêts et investissements.',
                          textAlign: isMobile ? TextAlign.center : TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 14 : 16,
                          ),
                        ),
                        const SizedBox(height: 30),

                        StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            final user = snapshot.data;

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (user == null) {
                              return Row(
                                mainAxisAlignment: isMobile
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        context.go('/login'),
                                    child: const Text('Se connecter'),
                                  ),
                                  const SizedBox(width: 20),
                                  OutlinedButton(
                                    onPressed: () =>
                                        context.go('/register'),
                                    child: const Text(
                                      "S'inscrire",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return FutureBuilder<bool>(
                              future: SupabaseAdminService.isAdmin(user.email!),
                              builder: (context, adminSnapshot) {
                                if (adminSnapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (adminSnapshot.data == true) {
                                  return ElevatedButton(
                                    onPressed: () =>
                                        context.goNamed(
                                            'admin_dashboard'),
                                    child: const Text('Accéder à l’espace admin'),
                                  );
                                }

                                return ElevatedButton(
                                  onPressed: () =>
                                      context.goNamed('dashboard'),
                                  child: const Text('Accéder à mon espace'),
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
