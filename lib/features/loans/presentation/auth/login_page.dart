import 'package:flutter/material.dart';
import '../widgets/auth_button.dart';
import 'auth_service.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Accédez à votre espace KreditSch",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 32),

                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Mot de passe"),
                ),
                const SizedBox(height: 24),
                TextButton(
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
                const SizedBox(height: 24),

                AuthButton(
                  label: "Se connecter",
                  loading: loading,
                  onPressed: () async {
                    setState(() => loading = true);
                    await auth.signInWithEmail(
                      emailCtrl.text,
                      passCtrl.text,
                    );
                    setState(() => loading = false);
                  },
                ),

                const SizedBox(height: 16),

                OutlinedButton.icon(
                  icon: Image.network(
                    "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/google.png",
                    height: 18,
                  ),
                  label: const Text("Continuer avec Google"),
                  onPressed: auth.signInWithGoogle,
                ),

                const SizedBox(height: 24),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text("Créer un compte"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
