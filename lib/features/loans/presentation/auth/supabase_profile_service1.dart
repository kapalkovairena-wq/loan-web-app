import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SupabaseProfileService {
  static Future<void> createProfile(User user) async {
    final url = Uri.parse(
      "https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/create-profile",
    );

    final email = user.email ?? "";
    final provider = user.providerData.isNotEmpty
        ? user.providerData.first.providerId
        : "unknown";

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "x-edge-secret": "Mahugnon23@hof",
      },
      body: jsonEncode({
        "firebase_uid": user.uid,
        "email": email,
        "provider": provider,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Erreur Supabase: ${response.statusCode} - ${response.body}");
    }
  }
}
