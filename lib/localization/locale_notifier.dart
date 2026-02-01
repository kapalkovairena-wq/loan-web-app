import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Web uniquement
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Gestion de la locale de l'application
class LocaleNotifier extends ChangeNotifier {
  static const _storageKey = 'app_locale';

  Locale? _locale;

  Locale? get locale => _locale;

  LocaleNotifier() {
    _loadFromStorage();
    debugPrint('🌐 LocaleNotifier initialized with locale: $_locale');
  }

  /// Définit la locale de l'application
  void setLocale(Locale locale) async {
    if (_locale == locale) {
      debugPrint('ℹ️ Locale already set to ${locale.languageCode}');
      return;
    }

    _locale = locale;
    _saveToStorage(locale.languageCode);
    notifyListeners();

    debugPrint('🌍 Locale set to ${locale.languageCode}');
    await _syncLanguageWithSupabase(locale.languageCode);
  }

  /// Synchronise la langue avec Supabase si l'utilisateur est connecté
  Future<void> _syncLanguageWithSupabase(String languageCode) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint('⚠️ No Firebase user, skipping language sync');
      return;
    }

    if (user.email == null) {
      debugPrint('❌ Firebase user has no email, cannot sync profile');
      return;
    }

    try {
      final uri = Uri.parse(
        'https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/sync_language',
      );

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "x-edge-secret": "Mahugnon23",
        },
        body: jsonEncode({
          'firebase_uid': user.uid,
          'email': user.email,
          'language': languageCode,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('✅ Language synced via Edge Function: ${response.body}');
      } else {
        debugPrint(
          '❌ Edge function error [${response.statusCode}]: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('❌ Edge function call failed: $e');
    }
  }

  /// Supprime la locale actuelle et le stock local
  void clearLocale() {
    _locale = null;
    if (kIsWeb) {
      html.window.localStorage.remove(_storageKey);
      debugPrint('🗑 Locale cleared from localStorage');
    }
    notifyListeners();
  }

  // =========================
  // 🔐 PERSISTENCE WEB
  // =========================

  /// Charge la locale depuis le localStorage (web uniquement)
  void _loadFromStorage() {
    if (!kIsWeb) return;

    final code = html.window.localStorage[_storageKey];
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
      debugPrint('📥 Loaded locale from localStorage: $code');
    } else {
      debugPrint('📥 No locale found in localStorage');
    }
  }

  /// Sauvegarde la locale dans le localStorage (web uniquement)
  void _saveToStorage(String code) {
    if (!kIsWeb) return;
    html.window.localStorage[_storageKey] = code;
    debugPrint('💾 Saved locale to localStorage: $code');
  }

  /// Retourne la locale effective : locale définie > locale système > fallback
  Locale get effectiveLocale {
    if (_locale != null) return _locale!;
    if (!kIsWeb) return Locale(window.locale.languageCode);
    debugPrint('⚠️ No locale set, using fallback "de"');
    return const Locale('de'); // fallback web
  }
}
