import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminTransactionsHistoryPage extends StatefulWidget {
  const AdminTransactionsHistoryPage({super.key});

  @override
  State<AdminTransactionsHistoryPage> createState() =>
      _AdminTransactionsHistoryPageState();
}

class _AdminTransactionsHistoryPageState
    extends State<AdminTransactionsHistoryPage> {
  bool loading = true;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);

    try {
      final uri = Uri.parse(
          "https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/get_payment_proofs_history");

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
        },
        body: jsonEncode({}), // corps vide
      );

      if (response.statusCode != 200) {
        throw Exception("Erreur serveur: ${response.statusCode} ${response.body}");
      }

      final json = jsonDecode(response.body);

      debugPrint("📦 JSON reçu: $json");

      // ⚡ Parsing correct : json est une List
      final dataList = (json as List<dynamic>).map((e) {
        final m = Map<String, dynamic>.from(e);

        // profiles est un objet
        if (m['profiles'] != null) {
          m['profile'] = Map<String, dynamic>.from(m['profiles']);
        }

        // ⚡ Conversion sécurisée d'éventuels champs numériques
        if (m['amount'] is String) {
          m['amount'] = double.tryParse(m['amount']) ?? 0.0;
        }

        return m;
      }).toList();

      setState(() {
        transactions = dataList;
        loading = false;
      });
    } catch (e, stack) {
      debugPrint("❌ Error loading history");
      debugPrint("$e");
      debugPrint("$stack");
      setState(() => loading = false);
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Approuvé';
      case 'rejected':
        return 'Rejeté';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique des paiements"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
          ? const Center(child: Text("Aucune transaction"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (_, i) {
          final t = transactions[i];
          final profile = t['profile'] as Map<String, dynamic>?;

          final email = profile?['email'] ?? 'Email non disponible';
          final fullName =
              profile?['receiver_full_name'] ?? 'Nom non renseigné';

          final status = t['status'] as String;
          final date = DateTime.parse(
            t['reviewed_at'] ?? t['created_at'],
          );

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _statusIcon(status),
                        color: _statusColor(status),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _statusLabel(status),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _statusColor(status),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(date),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(email),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    label:
                    const Text("Voir la preuve de paiement"),
                    onPressed: () async {
                      final uri = Uri.parse(t['file_url']);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  if (t['reviewed_by'] != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Traité par : ${t['reviewed_by']}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
