import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import 'app_router.dart';
import 'l10n/app_localizations.dart';
import 'localization/locale_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://yztryuurtkxoygpcmlmu.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
  );
  print("✅ Supabase initialized");

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyANJpRnblw9qXD9P_oIHbW5ioGSSG9kzm0",
        authDomain: "loan-web-app-b5697.firebaseapp.com",
        projectId: "loan-web-app-b5697",
        messagingSenderId: "214149699740",
        appId: "1:214149699740:web:556cda3cec07bbb94eb559"
    ),
  );
  print("✅ Firebase initialized");

  await initializeDateFormatting('fr_FR', null);
  print("✅ Date formatting initialized for fr_FR");

  final localeNotifier = LocaleNotifier();

  // 🔹 Étape 1 : essayer de récupérer la langue Supabase si l'utilisateur est connecté
  final user = FirebaseAuth.instance.currentUser;
  String? initialLang;

  if (user != null) {
    final profile = await Supabase.instance.client
        .from('profiles')
        .select('language')
        .eq('firebase_uid', user.uid)
        .maybeSingle();

    initialLang = profile?['language'] as String?;
    print("✅ Supabase language found: $initialLang");
  }

  // 🔹 Étape 2 : si pas de langue Supabase, utiliser la langue du système
  if (initialLang == null || initialLang.isEmpty) {
    final systemLang = ui.PlatformDispatcher.instance.locale.languageCode;
    if (AppLocalizations.supportedLocales
        .map((e) => e.languageCode)
        .contains(systemLang)) {
      initialLang = systemLang;
      print("✅ System language used: $initialLang");
    }
  }

  // 🔹 Étape 3 : si toujours rien, mettre 'de' par défaut
  initialLang ??= 'de';
  print("✅ Final initial language: $initialLang");

  // 🔹 Définir la locale initiale
  localeNotifier.setLocale(Locale(initialLang));

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleNotifier(),
      child: const LoanApp(),
    ),
  );
}

class LoanApp extends StatelessWidget {
  const LoanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeNotifier = context.watch<LocaleNotifier>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'KreditSch',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        useMaterial3: true,
      ),
      routerConfig: appRouter,

      locale: localeNotifier.locale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}