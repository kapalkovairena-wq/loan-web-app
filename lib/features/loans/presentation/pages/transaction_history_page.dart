import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final String firebaseUid = FirebaseAuth.instance.currentUser!.uid;
  bool loading = true;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => loading = true);

    try {
      // 🔹 Remplace par l'URL de ton Edge Function
      final uri = Uri.parse(
          "https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/get_payment_proofs");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "x-edge-secret": "Mahugnon23",
        },
        body: jsonEncode({"firebase_uid": firebaseUid}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          transactions =
          List<Map<String, dynamic>>.from(data["transactions"] ?? []);
        });
      } else {
        debugPrint("Erreur récupération: ${response.body}");
        setState(() => transactions = []);
      }
    } catch (e) {
      debugPrint("Erreur HTTP: $e");
      setState(() => transactions = []);
    } finally {
      setState(() => loading = false);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
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
      case 'pending':
      default:
        return Icons.hourglass_top;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique des transactions"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
          ? const Center(child: Text("Aucune transaction soumise"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (_, i) {
          final tx = transactions[i];
          final status = tx['status'] ?? 'pending';
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    _statusIcon(status),
                    color: _statusColor(status),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Soumis le : ${DateTime.parse(tx['created_at']).toLocal()}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Statut : $status",
                          style: TextStyle(
                              color: _statusColor(status),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () async {
                      final uri = Uri.parse(tx['file_url']);
                      if (await canLaunchUrl(uri)) {
                        launchUrl(uri);
                      }
                    },
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
