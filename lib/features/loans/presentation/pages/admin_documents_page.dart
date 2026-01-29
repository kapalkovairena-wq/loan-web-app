import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'admin_documents_history_page.dart';


class AdminDocumentsPage extends StatefulWidget {
  const AdminDocumentsPage({super.key});

  @override
  State<AdminDocumentsPage> createState() => _AdminDocumentsPageState();
}

class _AdminDocumentsPageState extends State<AdminDocumentsPage> {
  final supabase = Supabase.instance.client;
  bool loading = true;
  List documents = [];

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() => loading = true);

    final res = await supabase
        .from('user_documents_pending')
        .select('id, file_url, status, created_at, profiles(email)')
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    setState(() {
      documents = res;
      loading = false;
    });
  }

  Future<void> _reviewDocument(
      String documentId,
      String action,
      ) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/admin_review_document',
        ),
        headers: {
          "Content-Type": "application/json",
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "x-edge-secret": "Mahugnon23",
        },
        body: jsonEncode({
          'document_id': documentId,
          'action': action,
          'admin_email': supabase.auth.currentUser?.email,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw body['error'];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            action == 'approved'
                ? '✅ Document approuvé'
                : '❌ Document rejeté',
          ),
        ),
      );

      _loadDocuments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (documents.isEmpty) {
      return const Center(child: Text("Aucun document en attente"));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Validation des documents"),
          actions: [
            IconButton(
              tooltip: "Historique des documents",
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminDocumentsHistoryPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['profiles']?['email'] ?? 'Utilisateur inconnu',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Image.network(doc['file_url'], height: 180),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text("Approuver"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () =>
                          _reviewDocument(doc['id'], 'approved'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text("Rejeter"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () =>
                          _reviewDocument(doc['id'], 'rejected'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
        ),
    );
  }
}
