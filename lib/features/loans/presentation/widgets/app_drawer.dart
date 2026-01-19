import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/loan_simulation_page.dart';
import '../pages/about_page.dart';
import '../pages/contact_page.dart';
import '../pages/loan_solution_section.dart';
import '../pages/loan_offers_page.dart';
import '../pages/loan_offers_page.dart';
import '../pages/loan_offers_page.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 40),
          _drawerItem(context, 'Page d\'accueil', () {
            Navigator.pop(context); // fermer le drawer
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }),
          _drawerItem(context, 'Découvrir nos offres', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoanOffersPage()),
            );
          }),
          _drawerItem(context, 'Demander un prêt', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoanSimulationPage()),
            );
          }),
          _drawerItem(context, 'Investissement', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoanSolutionSection()),
            );
          }),
          _drawerItem(context, 'Contact', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ContactPage()),
            );
          }),
          _drawerItem(context, 'À propos de nous', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoanExpertiseSection()),
            );
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}