import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../presentation/auth/auth_gate.dart';

class UserDocumentsHistoryPage extends StatefulWidget {
  const UserDocumentsHistoryPage({super.key});

  @override
  State<UserDocumentsHistoryPage> createState() =>
      _UserDocumentsHistoryPageState();
}

class _UserDocumentsHistoryPageState
    extends State<UserDocumentsHistoryPage> {
  bool loading = true;
  List documents = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();

    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthGate()),
        );
      });
    }
  }

  Future<void> _loadHistory() async {
    setState(() => loading = true);

    try {
      final firebaseUid = FirebaseAuth.instance.currentUser?.uid;

      if (firebaseUid == null) {
        throw "Utilisateur non connecté";
      }

      final res = await http.post(
        Uri.parse(
          'https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/get_user_documents_history',
        ),
        headers: {
          "Content-Type": "application/json",
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "x-edge-secret": "Mahugnon23",
        },
        body: jsonEncode({
          "firebase_uid": firebaseUid,
        }),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode != 200) {
        throw body['error'] ?? "Erreur serveur";
      }

      setState(() {
        documents = body['documents'] ?? [];
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Erreur chargement: $e"),
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

  String _statusLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Approuvé';
      case 'rejected':
        return 'Rejeté';
      default:
        return 'En attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (documents.isEmpty) {
      return const Center(
        child: Text("Aucun document soumis"),
      );
    }

    return ListView.builder(
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
                // 📅 Date
                Text(
                  DateFormat('dd MMM yyyy – HH:mm')
                      .format(DateTime.parse(doc['created_at'])),
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 8),

                // 🖼 Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    doc['file_url'],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                    const Text("Image indisponible"),
                  ),
                ),

                const SizedBox(height: 12),

                // 🏷 Status
                Row(
                  children: [
                    Icon(
                      _statusIcon(doc['status']),
                      color: _statusColor(doc['status']),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _statusLabel(doc['status']),
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
    );
  }
}
