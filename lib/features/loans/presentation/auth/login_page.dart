import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'supabase_profile_service.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import '../pages/home_page.dart';
import '../../../../l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final Stream<User?> _authStream;
  String? selectedCurrency;

  @override
  void initState() {
    super.initState();

    _authStream = FirebaseAuth.instance.authStateChanges();

    _authStream.listen((user) {
      final locale = Localizations.localeOf(context);
      final languageCode = locale.languageCode;
      if (user != null && selectedCurrency != null) {
        SupabaseProfileService.createProfile(
          user,
          currency: selectedCurrency!,
          language: languageCode,
        );
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const Login();
      },
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final auth = AuthService();
  bool loading = false;

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;

    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      _showMessage(l10n.fillAllFields, isError: true);
      return;
    }

    try {
      setState(() => loading = true);
      await auth.signInWithEmail(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      final l10n = AppLocalizations.of(context)!;

      if (e.code == 'user-not-found') {
        _showMessage(l10n.noAccountFound, isError: true);
      } else if (e.code == 'wrong-password') {
        _showMessage(l10n.incorrectPassword, isError: true);
      } else if (e.code == 'invalid-email') {
        _showMessage(l10n.invalidEmail, isError: true);
      } else {
        _showMessage(l10n.loginError, isError: true);
      }
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ===== LOGO =====
                  Center(
                    child: Column(
                      children: [
                        Image.network(
                          "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/logo.png",
                          height: 60,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    l10n.login,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.loginSubtitle,
                    style: const TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(l10n.forgotPassword),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(l10n.loginButton),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  OutlinedButton.icon(
                    icon: Image.network(
                      "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/google.png",
                      height: 18,
                    ),
                    label: Text(l10n.continueWithGoogle),
                    onPressed: () async {
                      try {
                        await auth.signInWithGoogle();
                      } catch (_) {
                        _showMessage(
                          l10n.googleSignInError,
                          isError: true,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.noAccountYet,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterPage(),
                            ),
                          );
                        },
                        child: Text(l10n.createAccount),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
