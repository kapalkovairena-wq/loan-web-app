import 'dart:convert';
import 'dart:io';

void main() async {
  // Dossier contenant tes fichiers .arb
  final arbDir = Directory('lib/l10n');

  // Vérifie si le dossier existe
  if (!await arbDir.exists()) {
    print('❌ Dossier lib/l10n introuvable !');
    return;
  }

  // Liste tous les fichiers .arb
  final arbFiles = arbDir
      .listSync()
      .where((f) => f.path.endsWith('.arb'))
      .map((f) => File(f.path))
      .toList();

  if (arbFiles.isEmpty) {
    print('❌ Aucun fichier .arb trouvé dans lib/l10n');
    return;
  }

  // Choisir le fichier "maître" (souvent en anglais)
  final masterFile = arbFiles.firstWhere(
        (f) => f.path.contains('_en.arb'),
    orElse: () => arbFiles.first,
  );

  Map<String, dynamic> masterMap;

  // Lecture du master avec gestion d'erreur
  try {
    final masterContent = await masterFile.readAsString();
    if (masterContent.trim().isEmpty) {
      print('❌ Fichier maître ${masterFile.path} vide !');
      return;
    }
    masterMap = json.decode(masterContent) as Map<String, dynamic>;
  } catch (e) {
    print('❌ Erreur lors de la lecture du fichier maître ${masterFile.path} : $e');
    return;
  }

  print('✅ Fichier maître : ${masterFile.path}');
  print('---');

  // Comparer tous les fichiers avec le master
  for (var file in arbFiles) {
    if (file.path == masterFile.path) continue;

    Map<String, dynamic> targetMap;

    try {
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        print('⚠️ ${file.path} est vide → ignoré.');
        print('---');
        continue;
      }
      targetMap = json.decode(content) as Map<String, dynamic>;
    } catch (e) {
      print('⚠️ ${file.path} contient un JSON invalide → ignoré. Erreur: $e');
      print('---');
      continue;
    }

    final missingKeys =
    masterMap.keys.where((key) => !targetMap.containsKey(key)).toList();

    if (missingKeys.isEmpty) {
      print('✅ ${file.path} → toutes les clés sont présentes.');
    } else {
      print('❌ ${file.path} → clés manquantes :');
      for (var key in missingKeys) {
        print('   • $key');
      }
    }
    print('---');
  }
}
