import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/supabase_admin_service.dart';

import '../../presentation/auth/auth_gate.dart';
import '../../presentation/auth/register_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/admin_dashboard_page.dart';


class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
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
            padding: const EdgeInsets.all(40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Des services de prêts\npour développer votre entreprise',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Une solution moderne, simple et sécurisée pour gérer vos prêts et investissements.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 30),

                    StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        final user = snapshot.data;

                        // ⏳ Chargement
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        // ❌ Utilisateur non connecté
                        if (user == null) {
                          return Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const AuthGate()),
                                  );
                                },
                                child: const Text('Se connecter'),
                              ),
                              const SizedBox(width: 20),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                                  );
                                },
                                child: const Text(
                                  "S'inscrire",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        }

                        // ✅ Utilisateur connecté → on vérifie s’il est admin
                        return FutureBuilder<bool>(
                          future: SupabaseAdminService.isAdmin(user.email!), // email maintenant sûr
                          builder: (context, adminSnapshot) {
                            if (adminSnapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            // 👑 Admin
                            if (adminSnapshot.data == true) {
                              return ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AdminDashboardPage(),
                                    ),
                                  );
                                },
                                child: const Text('Accéder à l’espace admin'),
                              );
                            }

                            // 👤 Utilisateur normal
                            return ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DashboardPage(),
                                  ),
                                );
                              },
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
  }
}