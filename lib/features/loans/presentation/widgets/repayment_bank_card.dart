import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // Pour kIsWeb
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../widgets/web_card.dart';
import '../widgets/row_item.dart';

class RepaymentBankCard extends StatefulWidget {
  const RepaymentBankCard({super.key});

  @override
  State<RepaymentBankCard> createState() => _RepaymentBankCardState();
}

class _RepaymentBankCardState extends State<RepaymentBankCard> {
  final SupabaseClient supabase = Supabase.instance.client;
  final String firebaseUid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = true;
  Map<String, dynamic>? bankData;
  Map<String, dynamic>? profileData;

  File? selectedFile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bank = await supabase
        .from('user_financial_accounts')
        .select(
      'receiver_full_name, iban, bic, bank_name, bank_address',
    )
        .eq('is_active', true)
        .maybeSingle();

    final profile = await supabase
        .from('profiles')
        .select('payment, currency')
        .eq('firebase_uid', firebaseUid)
        .maybeSingle();

    setState(() {
      bankData = bank;
      profileData = profile;
      loading = false;
    });
  }

  Uint8List? selectedFileBytes;
  String? selectedFileName;

  Future<void> _pickFile() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true, // nécessaire pour obtenir Uint8List
      );
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          selectedFileBytes = result.files.single.bytes!;
          selectedFileName = result.files.single.name;
        });
      }
    } else {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() => selectedFile = File(image.path));
        return;
      }
      final file = await FilePicker.platform.pickFiles();
      if (file != null && file.files.single.path != null) {
        setState(() => selectedFile = File(file.files.single.path!));
      }
    }
  }

  Future<void> uploadPaymentProof({
    required Uint8List fileBytes,
    required String fileName,
    required String mimeType,
  }) async {
    final firebaseUid = FirebaseAuth.instance.currentUser!.uid;

    const anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls";

    final uri = Uri.parse("https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/upload_payment_proof");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "apikey": anonKey,
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
        "x-edge-secret": "Mahugnon23",
      },
      body: jsonEncode({
        "file_base64": base64Encode(fileBytes),
        "file_name": fileName,
        "mime_type": mimeType,
        "firebase_uid": firebaseUid,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur upload: ${response.body}");
    }
  }


  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const WebCard(
        title: "Les coordonnées bancaires de paiement",
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (bankData == null) {
      return const WebCard(
        title: "Les coordonnées bancaires de paiement",
        child: Text("Aucune information de paiement disponible"),
      );
    }

    final payment = profileData?['payment'];
    final currency = profileData?['currency'] ?? 'EUR';

    return WebCard(
      title: "Les coordonnées bancaires de paiement",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowItem("Receveur", bankData!['receiver_full_name'] ?? '—'),
          RowItem("IBAN", bankData!['iban'] ?? '—'),
          RowItem("BIC", bankData!['bic'] ?? '—'),
          RowItem("Banque", bankData!['bank_name'] ?? '—'),
          RowItem("Adresse", bankData!['bank_address'] ?? '—'),

          if (payment != null) ...[
            const Divider(height: 32),

            RowItemColor(
              "Montant à payer",
              "$payment $currency",
              valueColor: Colors.red,
              valueWeight: FontWeight.bold,
            ),

            const SizedBox(height: 16),

            if ((selectedFile != null) || (selectedFileBytes != null)) ...[
              const Text("Aperçu du document", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (kIsWeb && selectedFileBytes != null)
                Image.memory(selectedFileBytes!, height: 160)
              else if (selectedFile != null)
                Image.file(selectedFile!, height: 160),

              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text("Confirmer la soumission"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: (selectedFileBytes != null && selectedFileName != null)
                    ? () async {
                  try {
                    // ⚡ Upload du fichier
                    await uploadPaymentProof(
                      fileBytes: selectedFileBytes!,
                      fileName: selectedFileName!,
                      mimeType: "image/png", // adapter selon le type
                    );

                    // 🔹 Réinitialiser l’aperçu
                    setState(() {
                      selectedFileBytes = null;
                      selectedFileName = null;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Preuve envoyée avec succès"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("❌ Erreur lors de l'upload : $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                    : null, // bouton désactivé si aucun fichier sélectionné
              ),
            ] else
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text("Soumettre une preuve"),
                onPressed: _pickFile,
              ),
          ],
        ],
      ),
    );
  }
}