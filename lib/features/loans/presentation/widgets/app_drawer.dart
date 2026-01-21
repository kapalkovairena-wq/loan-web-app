import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/home_page.dart';
import '../pages/loan_simulation_page.dart';
import '../pages/contact_page.dart';
import '../pages/loan_solution_section.dart';
import '../pages/loan_offers_page.dart';
import '../pages/client_profile_page.dart';
import '../pages/loan_history_page.dart';
import '../pages/admin_loan_page.dart';
import '../pages/about_page.dart';
import '../auth/logout_page.dart';
import '../pages/dashboard_page.dart';

import '../auth/supabase_admin_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 40),

              _drawerItem(context, 'Page d\'accueil', () {
                _go(context, const HomePage());
              }),

              if (user != null) ...[
                _drawerItem(context, 'Mon tableau de bord', () {
                  _go(context, const DashboardPage());
                }),
              ],

              _drawerItem(context, 'Découvrir nos offres', () {
                _go(context, const LoanOffersPage());
              }),

              _drawerItem(context, 'Demander un prêt', () {
                _go(context, const LoanSimulationPage());
              }),

              _drawerItem(context, 'Investissement', () {
                _go(context, const LoanSolutionSection());
              }),

              // ===== UNIQUEMENT CONNECTÉ =====
              if (user != null) ...[
                _drawerItem(context, 'Profil', () {
                  _go(context, const ClientProfilePage());
                }),

                _drawerItem(context, 'Voir mes demandes', () {
                  _go(context, const LoanHistoryPage());
                }),

                // ===== ADMIN (SUPABASE) =====
                FutureBuilder<bool>(
                  future: SupabaseAdminService.isAdmin(user.email!),
                  builder: (context, adminSnapshot) {
                    if (adminSnapshot.data == true) {
                      return _drawerItem(context, 'Admins', () {
                        _go(context, const AdminLoanPage());
                      });
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],

              _drawerItem(context, 'Contact', () {
                _go(context, const ContactPage());
              }),

              _drawerItem(context, 'À propos de nous', () {
                _go(context, const LoanExpertiseSection());
              }),

              if (user != null) ...[
                _drawerItem(context, 'Se déconnecter', () {
                  _go(context, const LogoutPage());
                }),
              ],
            ],
          );
        },
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _drawerItem(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
