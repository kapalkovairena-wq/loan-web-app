import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AdminDocumentsHistoryPage extends StatefulWidget {
  const AdminDocumentsHistoryPage({super.key});

  @override
  State<AdminDocumentsHistoryPage> createState() =>
      _AdminDocumentsHistoryPageState();
}

class _AdminDocumentsHistoryPageState
    extends State<AdminDocumentsHistoryPage> {
  bool loading = true;
  List<Map<String, dynamic>> documents = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR').then((_) {
      _loadDocuments();
    });
  }

  Future<void> _loadDocuments() async {
    setState(() => loading = true);

    try {
      final response = await http.get(
        Uri.parse(
          'https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/admin_get_documents_history',
        ),
        headers: {
          "Content-Type": "application/json",
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "x-edge-secret": "Mahugnon23",
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw body['error'] ?? 'Erreur serveur';
      }

      setState(() {
        documents =
        List<Map<String, dynamic>>.from(body['documents']);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Erreur admin : $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.hourglass_top;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Documents soumis (Admin)"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDocuments,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : documents.isEmpty
          ? const Center(
        child: Text(
          "Aucun document soumis",
          style: TextStyle(color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: documents.length,
        itemBuilder: (_, i) {
          final doc = documents[i];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👤 USER INFO
                  Text(
                    doc['receiver_full_name'] ??
                        'Nom non renseigné',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doc['email'] ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 📅 DATE
                  Text(
                    DateFormat(
                        'dd MMM yyyy • HH:mm', 'fr_FR')
                        .format(
                      DateTime.parse(doc['created_at']),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🖼 DOCUMENT
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      doc['file_url'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Text(
                          "Erreur chargement image"),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🏷 STATUS
                  Row(
                    children: [
                      Icon(
                        _statusIcon(doc['status']),
                        color: _statusColor(doc['status']),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        doc['status'].toUpperCase(),
                        style: TextStyle(
                          color: _statusColor(doc['status']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
