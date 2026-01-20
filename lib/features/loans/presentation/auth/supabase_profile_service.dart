import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SupabaseProfileService {
  static Future<void> createProfile(User user) async {
    final url = Uri.parse(
      "https://YOUR_PROJECT_ID.supabase.co/functions/v1/create-profile",
    );

    await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "X_APP_SECRET": "TON_SECRET",
      },
      body: jsonEncode({
        "firebase_uid": user.uid,
        "email": user.email,
        "provider": user.providerData.first.providerId,
      }),
    );
  }
}
