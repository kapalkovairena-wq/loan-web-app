import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import '../pages/home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const Register();
      },
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final auth = AuthService();
  bool loading = false;

  Future<void> _register() async {
    if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) {
      _showMessage("Veuillez remplir tous les champs", isError: true);
      return;
    }

    try {
      setState(() => loading = true);

      await auth.registerWithEmail(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );

      _showMessage("Compte créé avec succès");

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showMessage(
          "Ce compte existe déjà. Veuillez vous connecter.",
          isError: true,
        );
      } else if (e.code == 'invalid-email') {
        _showMessage("Email invalide", isError: true);
      } else if (e.code == 'weak-password') {
        _showMessage(
          "Mot de passe trop faible (min. 6 caractères)",
          isError: true,
        );
      } else {
        _showMessage(
          "Erreur lors de la création du compte",
          isError: true,
        );
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
                        const SizedBox(height: 12),
                        const Text(
                          "KreditSch",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    "Créer un compte",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Rejoignez KreditSch en quelques secondes",
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

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Créer mon compte"),
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
                          "Erreur lors de l'inscription Google",
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
                        "Déjà un compte ?",
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text("Se connecter"),
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
