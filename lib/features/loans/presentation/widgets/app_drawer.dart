import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../auth/supabase_admin_service.dart';
import '../pages/admin_dashboard_page.dart';
import '../auth/logout_page.dart';
import '../../../../l10n/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 40),

              _drawerItem(
                context,
                l10n.drawerHome,
                    () => _go(context, 'home'),
              ),

              if (user != null) ...[
                _drawerItem(
                  context,
                  l10n.drawerDashboard,
                      () => _go(context, 'dashboard'),
                ),

                // ===== ADMIN (SUPABASE) =====
                FutureBuilder<bool>(
                  future: SupabaseAdminService.isAdmin(user.email!),
                  builder: (context, adminSnapshot) {
                    if (adminSnapshot.data == true) {
                      return _drawerItem(
                        context,
                        l10n.drawerAdminDashboard,
                            () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminDashboardPage(),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],

              _drawerItem(
                context,
                l10n.drawerLoanRequest,
                    () => _go(context, 'loan_simulation'),
              ),

              _drawerItem(
                context,
                l10n.drawerOffers,
                    () => _go(context, 'loan_offers'),
              ),

              _drawerItem(
                context,
                l10n.drawerInvestment,
                    () => _go(context, 'investment'),
              ),

              _drawerItem(
                context,
                l10n.drawerContact,
                    () => _go(context, 'contact'),
              ),

              _drawerItem(
                context,
                l10n.drawerAbout,
                    () => _go(context, 'about'),
              ),

              if (user != null)
                _drawerItem(
                  context,
                  l10n.drawerLogout,
                      () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LogoutPage()),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  /// ===============================
  /// NAVIGATION VIA GO_ROUTER
  /// ===============================
  void _go(BuildContext context, String routeName) {
    Navigator.pop(context);
    context.goNamed(routeName);
  }

  Widget _drawerItem(
      BuildContext context,
      String title,
      VoidCallback onTap,
      ) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}