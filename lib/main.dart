import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/loans/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://yztryuurtkxoygpcmlmu.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
  );

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyANJpRnblw9qXD9P_oIHbW5ioGSSG9kzm0",
        authDomain: "loan-web-app-b5697.firebaseapp.com",
        projectId: "loan-web-app-b5697",
        messagingSenderId: "214149699740",
        appId: "1:214149699740:web:556cda3cec07bbb94eb559"
    ),
  );

  await initializeDateFormatting('fr_FR', null);

  runApp(const LoanApp());
}

class LoanApp extends StatelessWidget {
  const LoanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KreditSch',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}