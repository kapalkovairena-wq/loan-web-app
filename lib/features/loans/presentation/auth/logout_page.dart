import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../pages/home_page.dart';
import '../../../../l10n/app_localizations.dart';

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

      // Déconnexion Supabase
      await sb.Supabase.instance.client.auth.signOut();
    } catch (e) {
      debugPrint("Erreur lors de la déconnexion: $e");
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        // Redirection vers HomePage
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: _loading
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(l10n.loggingOut),
          ],
        )
            : const SizedBox.shrink(),
      ),
    );
  }
}
