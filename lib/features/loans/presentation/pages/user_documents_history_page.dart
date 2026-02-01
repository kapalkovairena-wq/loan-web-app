import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../l10n/app_localizations.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistory();
    });

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
    final l10n = AppLocalizations.of(context)!;

    setState(() => loading = true);

    try {
      final firebaseUid = FirebaseAuth.instance.currentUser?.uid;

      if (firebaseUid == null) {
        throw l10n.userNotLoggedIn;
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
        body: jsonEncode({"firebase_uid": firebaseUid}),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode != 200) {
        throw body['error'] ?? l10n.serverError;
      }

      setState(() {
        documents = body['documents'] ?? [];
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${l10n.errorLoading} $e"),
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
      case "pending":
        return Colors.orange;
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
      case "pending":
        return Icons.hourglass_top;
      default:
        return Icons.hourglass_top;
    }
  }

  String _statusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case "pending":
        return l10n.pending;
      case "approved":
        return l10n.approved;
      case "rejected":
        return l10n.rejected;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (documents.isEmpty) {
      return Center(
        child: Text(l10n.noDocumentsSubmitted),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        final status = doc['status'] ?? 'pending';

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
                        Text(l10n.imageUnavailable),
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
                      "${l10n.status}: ${_statusLabel(status, l10n)}",
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
