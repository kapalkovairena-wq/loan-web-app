import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'supabase_profile_service.dart';
import 'register_loan_page.dart';
import 'forgot_password_page.dart';
import '../pages/loan_request_page.dart';

class LoginLoanPage extends StatefulWidget {
  const LoginLoanPage({super.key});

  @override
  State<LoginLoanPage> createState() => _LoginLoanPageState();
}

class _LoginLoanPageState extends State<LoginLoanPage> {
  late final Stream<User?> _authStream;
  String? selectedCurrency;

  @override
  void initState() {
    super.initState();

    _authStream = FirebaseAuth.instance.authStateChanges();

    _authStream.listen((user) {
      if (user != null) {
        SupabaseProfileService.createProfile(
          user,
          currency: selectedCurrency!,
        );
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

  Future<void> _login() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      _showMessage("Veuillez remplir tous les champs", isError: true);
      return;
    }

    try {
      setState(() => loading = true);
      await auth.signInWithEmail(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showMessage(
          "Aucun compte trouvé. Veuillez vous inscrire.",
          isError: true,
        );
      } else if (e.code == 'wrong-password') {
        _showMessage("Mot de passe incorrect", isError: true);
      } else if (e.code == 'invalid-email') {
        _showMessage("Email invalide", isError: true);
      } else {
        _showMessage("Erreur de connexion", isError: true);
      }
    } finally {
      setState(() => loading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

                  const Text(
                    "Connexion",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Accédez à votre espace client",
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Mot de passe",
                      border: OutlineInputBorder(),
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
                      child: const Text("Mot de passe oublié ?"),
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
                        : const Text("Se connecter"),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  OutlinedButton.icon(
                    icon: Image.network(
                      "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/google.png",
                      height: 18,
                    ),
                    label: const Text("Continuer avec Google"),
                    onPressed: () async {
                      try {
                        await auth.signInWithGoogle();
                      } catch (_) {
                        _showMessage(
                          "Erreur lors de la connexion Google",
                          isError: true,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Pas encore de compte ?",
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterLoanPage(),
                            ),
                          );
                        },
                        child: const Text("Créer un compte"),
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