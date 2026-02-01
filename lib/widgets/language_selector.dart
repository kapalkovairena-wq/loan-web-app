import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/locale_notifier.dart';

const supportedLanguages = [
  ('en', '🇬🇧', 'English'),
  ('fr', '🇫🇷', 'Français'),
  ('de', '🇩🇪', 'Deutsch'),
  ('es', '🇪🇸', 'Español'),
  ('it', '🇮🇹', 'Italiano'),
  ('pt', '🇵🇹', 'Português'),
  ('pl', '🇵🇱', 'Polski'),
  ('nl', '🇳🇱', 'Nederlands'),
  ('sv', '🇸🇪', 'Svenska'),
  ('el', '🇬🇷', 'Ελληνικά'),
  ('ro', '🇷🇴', 'Română'),
  ('hu', '🇭🇺', 'Magyar'),
  ('cs', '🇨🇿', 'Čeština'),
  ('sk', '🇸🇰', 'Slovenčina'),
  ('bg', '🇧🇬', 'Български'),
  ('hr', '🇭🇷', 'Hrvatski'),
  ('da', '🇩🇰', 'Dansk'),
  ('fi', '🇫🇮', 'Suomi'),
  ('ga', '🇮🇪', 'Gaeilge'),
  ('lt', '🇱🇹', 'Lietuvių'),
  ('lv', '🇱🇻', 'Latviešu'),
  ('mt', '🇲🇹', 'Malti'),
  ('sl', '🇸🇮', 'Slovenščina'),
  ('et', '🇪🇪', 'Eesti'),
];

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeNotifier = context.watch<LocaleNotifier>();
    final current = localeNotifier.locale?.languageCode;

    // Trouve la langue courante
    final currentLang = supportedLanguages.firstWhere(
          (lang) => lang.$1 == current,
      orElse: () => supportedLanguages[0],
    );

    return PopupMenuButton<String>(
      tooltip: 'Language',
      offset: const Offset(0, 40),

      // Remplace l’icône par le drapeau + nom de langue
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentLang.$2, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              currentLang.$3,
              style: const TextStyle(color: Colors.white),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),

      onSelected: (code) {
        localeNotifier.setLocale(Locale(code));
      },

      itemBuilder: (context) => supportedLanguages.map((lang) {
        final isSelected = lang.$1 == current;

        return PopupMenuItem<String>(
          value: lang.$1,
          child: Row(
            children: [
              Text(lang.$2, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                lang.$3,
                style: TextStyle(
                  fontWeight:
                  isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}