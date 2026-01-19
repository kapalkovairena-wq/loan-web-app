import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool loading = false;
  String? message;

  Future<void> resetPassword() async {
    setState(() {
      loading = true;
      message = null;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      setState(() {
        message =
        "Un lien de réinitialisation a été envoyé à votre adresse e-mail.";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = e.message ?? "Une erreur est survenue.";
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  "Mot de passe oublié",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Entrez votre adresse e-mail pour recevoir un lien de réinitialisation.",
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 32),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Adresse e-mail",
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: loading ? null : resetPassword,
                  child: loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text("Envoyer le lien"),
                ),

                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: TextStyle(
                      color: message!.startsWith("Un lien")
                          ? Colors.green
                          : Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 24),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Retour à la connexion"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
