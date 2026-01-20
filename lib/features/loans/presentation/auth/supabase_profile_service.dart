import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseProfileService {
  static Future<void> createProfile(User user) async {
    await dotenv.load(); // charge .env
    final secret = dotenv.env['EDGE_FUNCTION_SECRET'];

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
        "x-edge-secret": secret!, // <- clé secrète envoyée
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
