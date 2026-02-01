import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'supabase_profile_service.dart';
import '../pages/home_page.dart';
import 'login_page.dart';
import '../../../../l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final Stream<User?> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();
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

  List<String> currencyCodes = [
    'EUR','BGN','DKK','HUF','PLN','RON','SEK','CZK','GBP','CHF','NOK','ISK','RUB','UAH','RSD','BAM','ALL','MKD','MDL','BYN','GEL','AMD','AZN','TRY',
  ];

  String? selectedCurrency;

  Future<void> _register() async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    const supportedLanguages = [
      'en','fr','de','es','it','pt','pl','nl','sv','el','ro','hu','cs','sk','bg',
      'hr','da','fi','ga','lt','lv','mt','sl','et',
    ];
    final languageCode = supportedLanguages.contains(locale.languageCode)
        ? locale.languageCode
        : 'en';

    if (emailCtrl.text.isEmpty ||
        passCtrl.text.isEmpty ||
        selectedCurrency == null) {
      _showMessage(
        l10n.fillAllFields,
        isError: true,
      );
      return;
    }

    try {
      setState(() => loading = true);

      // 1️⃣ Création Firebase
      await auth.registerWithEmail(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );

      // 2️⃣ Création du profil Supabase
      await SupabaseProfileService.createProfile(
        FirebaseAuth.instance.currentUser!,
        currency: selectedCurrency!,
        language: languageCode,
      );

      // 3️⃣ Redirection
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }

    } on FirebaseAuthException catch (e) {
      final l10n = AppLocalizations.of(context)!;

      if (e.code == 'email-already-in-use') {
        _showMessage(l10n.accountAlreadyExists, isError: true);
      } else if (e.code == 'invalid-email') {
        _showMessage(l10n.invalidEmail, isError: true);
      } else if (e.code == 'weak-password') {
        _showMessage(l10n.weakPassword, isError: true);
      } else {
        _showMessage(l10n.registrationError, isError: true);
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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    const supportedLanguages = [
      'en','fr','de','es','it','pt','pl','nl','sv','el','ro','hu','cs','sk','bg',
      'hr','da','fi','ga','lt','lv','mt','sl','et',
    ];
    final languageCode = supportedLanguages.contains(locale.languageCode)
        ? locale.languageCode
        : 'en';

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
                  /// LOGO
                  Center(
                    child: Image.network(
                      "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/logo.png",
                      height: 60,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    l10n.createAccount,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.joinKreditSch,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),

                  DropdownButtonFormField<String>(
                    value: selectedCurrency,
                    decoration: InputDecoration(
                      labelText: l10n.currency,
                      border: const OutlineInputBorder(),
                    ),
                    items: currencyCodes.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedCurrency = value);
                    },
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
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(l10n.createMyAccount),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),

                  OutlinedButton.icon(
                    icon: Image.network(
                      "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/google.png",
                      height: 18,
                    ),
                    label: Text(l10n.continueWithGoogle),
                    onPressed: loading
                        ? null
                        : () async {
                      if (selectedCurrency == null) {
                        _showMessage(
                          l10n.selectCurrency,
                          isError: true,
                        );
                        return;
                      }
                      try {
                        setState(() => loading = true);
                        await auth.signInWithGoogle();
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) throw Exception(l10n.googleAuthError);
                        await SupabaseProfileService.createProfile(
                          user,
                          currency: selectedCurrency!,
                          language: languageCode,
                        );
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        }
                      } catch (e) {
                        _showMessage(l10n.googleAuthError, isError: true);
                      } finally {
                        setState(() => loading = false);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.alreadyHaveAccount, style: const TextStyle(color: Colors.black54)),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginPage()),
                          );
                        },
                        child: Text(l10n.signIn),
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
