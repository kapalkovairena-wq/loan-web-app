import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class SupabaseProfileService {
  static Future<void> createProfile(
      User user, {
        required String currency,
      }) async {
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

        // 🔐 OBLIGATOIRE POUR SUPABASE
        "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",

        // 🔐 TON CONTRÔLE INTERNE
        "x-edge-secret": "Mahugnon23",
      },
      body: jsonEncode({
        "firebase_uid": user.uid,
        "email": email,
        "provider": provider,
        "currency": currency,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Erreur Supabase: ${response.statusCode} - ${response.body}");
    }
  }
}
