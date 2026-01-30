import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/loans/presentation/pages/home_page.dart';
import 'features/loans/presentation/pages/dashboard_page.dart';
import 'features/loans/presentation/pages/loan_simulation_page.dart';
import 'features/loans/presentation/pages/loan_offers_page.dart';
import 'features/loans/presentation/pages/loan_solution_section.dart';
import 'features/loans/presentation/pages/contact_page.dart';
import 'features/loans/presentation/pages/about_page.dart';
import 'features/loans/presentation/auth/logout_page.dart';
import 'features/loans/presentation/auth/auth_gate.dart';
import 'features/loans/presentation/auth/register_page.dart';
import 'features/loans/presentation/pages/loan_request_page.dart';
import 'features/loans/presentation/pages/chat_user_page.dart';
import 'features/loans/presentation/pages/bank_details_page.dart';
import 'features/loans/presentation/pages/loan_history_page.dart';
import 'features/loans/presentation/pages/client_profile_page.dart';
import 'features/loans/presentation/pages/transaction_history_page.dart';
import 'features/loans/presentation/pages/user_documents_history_page.dart';


CustomTransitionPage<T> animatedPage<T>({
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    transitionDuration: const Duration(milliseconds: 400),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    },
  );
}
/// ===============================
/// APP ROUTER
/// ===============================
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    /// HOME
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),

    /// DASHBOARD USER
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),

    /// LOAN SIMULATION
    GoRoute(
      path: '/loan',
      name: 'loan_simulation',
      builder: (context, state) => const LoanSimulationPage(),
    ),

    /// LOAN OFFERS
    GoRoute(
      path: '/offers',
      name: 'loan_offers',
      builder: (context, state) => const LoanOffersPage(),
    ),

    /// INVESTMENT
    GoRoute(
      path: '/investment',
      name: 'investment',
      builder: (context, state) => const LoanSolutionSection(),
    ),

    /// CONTACT
    GoRoute(
      path: '/contact',
      name: 'contact',
      builder: (context, state) => const ContactPage(),
    ),

    /// ABOUT
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutPage(),
    ),

    /// LOGOUT
    GoRoute(
      path: '/logout',
      name: 'logout',
      builder: (context, state) => const LogoutPage(),
    ),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const AuthGate(),
    ),

    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),

    GoRoute(
      path: '/request',
      name: 'loan_request',
      builder: (context, state) => const LoanRequestPage(),
    ),

    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ClientProfilePage(),
    ),

    GoRoute(
      path: '/bank_details',
      name: 'bank_details',
      builder: (context, state) => const BankDetailsPage(),
    ),

    GoRoute(
      path: '/loan_history',
      name: 'loan_history',
      builder: (context, state) => const LoanHistoryPage(),
    ),

    GoRoute(
      path: '/transaction_history',
      name: 'transaction_history',
      builder: (context, state) => const TransactionHistoryPage(),
    ),

    GoRoute(
      path: '/documents_history',
      name: 'documents_history',
      builder: (context, state) => const UserDocumentsHistoryPage(),
    ),

    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) => const ChatUserPage(),
    ),
  ],

  /// ===============================
  /// (OPTIONNEL) PAGE 404 WEB
  /// ===============================
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        'Page introuvable',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ),
  ),
);
