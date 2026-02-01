import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/web_card.dart';
import '../../../../l10n/app_localizations.dart';

class DocumentUploadCard extends StatefulWidget {
  const DocumentUploadCard({super.key});

  @override
  State<DocumentUploadCard> createState() => _DocumentUploadCardState();
}

class _DocumentUploadCardState extends State<DocumentUploadCard> {
  final String firebaseUid = FirebaseAuth.instance.currentUser!.uid;

  Uint8List? selectedFileBytes;
  String? selectedFileName;
  bool loading = true;
  bool hasDocumentPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final supabase = Supabase.instance.client;

    final profile = await supabase
        .from('loan_requests')
        .select('document')
        .eq('firebase_uid', firebaseUid)
        .maybeSingle();

    if (!mounted) return;

    setState(() {
      hasDocumentPermission = profile?['document'] == true;
      loading = false;
    });
  }

  Future<void> _pickFile() async {
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
  }

  Future<void> _submitDocument() async {
    if (selectedFileBytes == null || selectedFileName == null) return;

    final l10n = AppLocalizations.of(context)!;

    try {
      final uri = Uri.parse(
        "https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/upload_user_document",
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
          "firebase_uid": firebaseUid,
          "file_base64": base64Encode(selectedFileBytes!),
          "file_name": selectedFileName!,
          "mime_type": "application/octet-stream",
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(response.body);
      }

      setState(() {
        selectedFileBytes = null;
        selectedFileName = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.documentUploadSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${l10n.documentUploadError} $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (loading || !hasDocumentPermission) {
      return const SizedBox();
    }

    return WebCard(
      title: l10n.documentUploadTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedFileBytes != null)
            Image.memory(
              selectedFileBytes!,
              height: 150,
            ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: Text(l10n.documentChooseFile),
            onPressed: _pickFile,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: Text(l10n.documentSubmit),
            onPressed:
            (selectedFileBytes != null && selectedFileName != null)
                ? _submitDocument
                : null,
          ),
        ],
      ),
    );
  }
}
