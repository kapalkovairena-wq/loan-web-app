import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/loan_request_page.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  bool isLoading = true;
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? profile;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      setState(() => isLoading = false);
      return;
    }

    final data = await supabase
        .from('loan_requests')
        .select()
        .eq('firebase_uid', firebaseUser.uid)
        .order('created_at', ascending: false)
        .limit(1);

    setState(() {
      profile = data.isNotEmpty ? data.first : null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profile == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          title: const Text("Mon profil"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                "Profil non encore créé",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Pour compléter votre profil, veuillez effectuer\nvotre première demande de prêt.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoanRequestPage()),
                  );
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5B400),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: const Text(
                  "Faire une demande de prêt",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
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
