import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminUsersMessagePage extends StatefulWidget {
  const AdminUsersMessagePage({super.key});

  @override
  State<AdminUsersMessagePage> createState() => _AdminUsersMessagePageState();
}

class _AdminUsersMessagePageState extends State<AdminUsersMessagePage> {
  List users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => loading = true);
    debugPrint("🔄 Chargement des utilisateurs...");

    try {
      final res = await http.get(
        Uri.parse("https://yztryuurtkxoygpcmlmu.supabase.co/rest/v1/profiles"),
        headers: {
          "Content-Type": "application/json",
          "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
          "x-edge-secret": "Mahugnon23",
        },
      );

      if (res.statusCode != 200) {
        debugPrint("❌ Erreur HTTP lors du chargement des utilisateurs : ${res.statusCode}");
        throw Exception("Erreur HTTP ${res.statusCode}");
      }

      final body = jsonDecode(res.body);
      debugPrint("✅ ${body.length} utilisateurs récupérés");

      setState(() {
        users = body;
        loading = false;
      });
    } catch (e) {
      debugPrint("❌ Exception lors du chargement des utilisateurs : $e");
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur chargement utilisateurs: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openMessageDialog(user) {
    debugPrint("✉️ Ouverture du dialogue pour l'utilisateur: ${user['firebase_uid']}");

    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Message à ${user['email']}"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: subjectCtrl,
                decoration: const InputDecoration(labelText: "Sujet"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageCtrl,
                minLines: 4,
                maxLines: 6,
                decoration: const InputDecoration(labelText: "Message"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Envoyer"),
            onPressed: () async {
              Navigator.pop(context);
              debugPrint("🚀 Envoi du message à ${user['email']}...");

              try {
                final res = await http.post(
                  Uri.parse(
                    "https://yztryuurtkxoygpcmlmu.supabase.co/functions/v1/admin_send_user_email",
                  ),
                  headers: {
                    "Content-Type": "application/json",
                    "apikey": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
                    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl6dHJ5dXVydGt4b3lncGNtbG11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3OTM0OTAsImV4cCI6MjA4NDM2OTQ5MH0.wJB7hDwviguUl_p3W4XYMdGGWv-mbi2yR6vTub432ls",
                    "x-edge-secret": "Mahugnon23",
                  },
                  body: jsonEncode({
                    "firebase_uid": user['firebase_uid'],
                    "subject": subjectCtrl.text,
                    "message": messageCtrl.text,
                  }),
                );

                final body = jsonDecode(res.body);
                if (res.statusCode != 200 || body['error'] != null) {
                  debugPrint("❌ Erreur lors de l'envoi du message : ${body['error']}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Erreur envoi message: ${body['error']}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                debugPrint("✅ Message envoyé avec succès à ${user['email']}");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Email envoyé avec succès"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                debugPrint("❌ Exception lors de l'envoi du message : $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Erreur envoi message: $e"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Utilisateurs")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text("Aucun utilisateur trouvé"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (_, i) {
          final u = users[i];
          return Card(
            child: ListTile(
              title: Text(u['receiver_full_name'] ?? '—'),
              subtitle: Text(u['email']),
              trailing: IconButton(
                icon: const Icon(Icons.mail),
                onPressed: () => _openMessageDialog(u),
              ),
            ),
          );
        },
      ),
    );
  }
}
