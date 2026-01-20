import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../pages/home_page.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _logoutUser();
  }

  Future<void> _logoutUser() async {
    try {
      // Déconnexion Firebase
      await fb.FirebaseAuth.instance.signOut();

      // Déconnexion Supabase (si nécessaire)
      await sb.Supabase.instance.client.auth.signOut();
    } catch (e) {
      debugPrint("Erreur lors de la déconnexion: $e");
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        // Redirection vers LoginPage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text("Déconnexion en cours…"),
          ],
        )
            : const SizedBox.shrink(),
      ),
    );
  }
}
