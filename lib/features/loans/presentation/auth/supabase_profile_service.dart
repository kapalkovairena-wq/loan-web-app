import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseProfileService {
  static Future<void> createProfile(User user) async {
    final secret = dotenv.env['EDGE_FUNCTION_SECRET'];

    if (secret == null || secret.isEmpty) {
      throw Exception("EDGE_FUNCTION_SECRET manquant");
    }

    final url = Uri.parse(
      "https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/create-profile",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "x-edge-secret": secret,
      },
      body: jsonEncode({
        "firebase_uid": user.uid,
        "email": user.email ?? "",
        "provider": user.providerData.isNotEmpty
            ? user.providerData.first.providerId
            : "unknown",
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Erreur Supabase: ${response.statusCode} - ${response.body}",
      );
    }
  }
}

