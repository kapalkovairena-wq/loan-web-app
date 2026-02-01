import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../l10n/app_localizations.dart';
import 'supabase_profile_service.dart';
import 'login_loan_page.dart';
import '../pages/loan_request_page.dart';

class AuthLoanGate extends StatefulWidget {
  const AuthLoanGate({super.key});

  @override
  State<AuthLoanGate> createState() => _AuthLoanGateState();
}

class _AuthLoanGateState extends State<AuthLoanGate> {
  late final Stream<User?> _authStream;
  bool _profileCreated = false; // pour éviter plusieurs appels
  String? selectedCurrency;

  @override
  void initState() {
    super.initState();

    _authStream = FirebaseAuth.instance.authStateChanges();

    _authStream.listen((user) async {
      final locale = Localizations.localeOf(context);
      final languageCode = locale.languageCode;
      if (user != null && !_profileCreated) {
        try {
          await SupabaseProfileService.createProfile(
            user,
            currency: selectedCurrency!,
            language: languageCode,
          );
          _profileCreated = true;
          print("Profil Supabase créé avec succès pour ${user.uid}");
        } catch (e) {
          print("Erreur création profil Supabase : $e");
        }
      } else if (user == null) {
        // Reset flag si utilisateur se déconnecte
        _profileCreated = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(l10n.loading),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const LoanRequestPage();
        }

        return const LoginLoanPage();
      },
    );
  }
}
