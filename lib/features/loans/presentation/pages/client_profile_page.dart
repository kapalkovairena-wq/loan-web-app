import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('loan_requests')
        .select()
        .eq('user_id', user.id)
        .single();

    setState(() => profile = data);
  }

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Mon profil"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: Container(
          width: 900,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ===== HEADER =====
              Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile!['full_name'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        profile!['profession'] ?? "—",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _statusBadge(profile!['loan_status']),
                ],
              ),

              const SizedBox(height: 30),

              /// ===== PERSONAL INFO =====
              _infoCard(
                title: "Informations personnelles",
                items: {
                  "Date de naissance": profile!['date_of_birth'] ?? "—",
                  "Pays": profile!['country'] ?? "—",
                  "Ville": profile!['city'] ?? "—",
                  "Adresse": profile!['address'] ?? "—",
                },
              ),

              /// ===== CONTACT =====
              _infoCard(
                title: "Coordonnées",
                items: {
                  "Email": profile!['email'],
                  "Téléphone": profile!['phone'],
                },
              ),

              /// ===== PROFESSIONAL =====
              _infoCard(
                title: "Situation professionnelle",
                items: {
                  "Profession": profile!['profession'],
                  "Source de revenus": profile!['income_source'],
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required Map<String, String> items,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),
            ...items.entries.map(
                  (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.key,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e.value,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String? status) {
    Color color = Colors.orange;
    String text = "En cours";

    if (status == "approved") {
      color = Colors.green;
      text = "Approuvé";
    } else if (status == "rejected") {
      color = Colors.red;
      text = "Refusé";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
