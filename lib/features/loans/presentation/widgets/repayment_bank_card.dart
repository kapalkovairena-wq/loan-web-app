import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../l10n/app_localizations.dart';

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
  Uint8List? selectedFileBytes;
  String? selectedFileName;

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

  Future<void> _pickFile() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
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
    const anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls";
    final uri = Uri.parse(
      "https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/upload_payment_proof",
    );

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "apikey": anonKey,
        "Authorization": "Bearer $anonKey",
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
      throw Exception(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      return WebCard(
        title: l10n.paymentBankDetailsTitle,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (bankData == null) {
      return WebCard(
        title: l10n.paymentBankDetailsTitle,
        child: Text(l10n.noPaymentInfo),
      );
    }

    final payment = profileData?['payment'];
    final currency = profileData?['currency'] ?? 'EUR';

    return WebCard(
      title: l10n.paymentBankDetailsTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowItem(l10n.receiver, bankData!['receiver_full_name'] ?? '—'),
          RowItem(l10n.iban, bankData!['iban'] ?? '—'),
          RowItem(l10n.bic, bankData!['bic'] ?? '—'),
          RowItem(l10n.bankName, bankData!['bank_name'] ?? '—'),
          RowItem(l10n.bankAddress, bankData!['bank_address'] ?? '—'),

          if (payment != null) ...[
            const Divider(height: 32),

            RowItemColor(
              l10n.amountToPay,
              "$payment $currency",
              valueColor: Colors.red,
              valueWeight: FontWeight.bold,
            ),

            const SizedBox(height: 16),

            if (selectedFile != null || selectedFileBytes != null) ...[
              Text(
                l10n.documentPreview,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              if (kIsWeb && selectedFileBytes != null)
                Image.memory(selectedFileBytes!, height: 160)
              else if (selectedFile != null)
                Image.file(selectedFile!, height: 160),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: Text(l10n.confirmSubmission),
                onPressed: (selectedFileBytes != null &&
                    selectedFileName != null)
                    ? () async {
                  try {
                    await uploadPaymentProof(
                      fileBytes: selectedFileBytes!,
                      fileName: selectedFileName!,
                      mimeType: "image/png",
                    );

                    setState(() {
                      selectedFileBytes = null;
                      selectedFileName = null;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                        Text(l10n.uploadSuccess),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                        Text(l10n.uploadError(e.toString())),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                    : null,
              ),
            ] else
              ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: Text(l10n.submitProof),
                onPressed: _pickFile,
              ),
          ],
        ],
      ),
    );
  }
}
