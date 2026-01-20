import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SupabaseProfileService {
  static Future<void> createProfile(User user) async {
    final url = Uri.parse(
      "https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/create-profile",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firebase_uid": user.uid,
        "email": user.email ?? "",
        "provider": user.providerData.isNotEmpty
            ? user.providerData.first.providerId
            : "unknown",
      }),
    );

    if (response.statusCode != 200) {
      print("Erreur Supabase: ${response.statusCode} ${response.body}");
      throw Exception("Impossible de créer le profil");
    }
  }
}
