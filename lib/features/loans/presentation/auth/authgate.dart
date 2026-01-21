import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'supabase_profile_service.dart';
import 'loginpage.dart';
import '../pages/loan_request_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Stream<User?> _authStream;
  bool _profileCreated = false; // pour éviter plusieurs appels

  @override
  void initState() {
    super.initState();

    _authStream = FirebaseAuth.instance.authStateChanges();

    _authStream.listen((user) async {
      if (user != null && !_profileCreated) {
        try {
          await SupabaseProfileService.createProfile(user);
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
    return StreamBuilder<User?>(
      stream: _authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const LoanRequestPage();
        }

        return const LoginPage();
      },
    );
  }
}
