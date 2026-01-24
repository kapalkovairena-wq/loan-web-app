import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/admin_financial_account_page.dart';
import '../pages/chat_admin_page.dart';
import '../pages/admin_loan_page.dart';
import '../pages/loan_admin_page.dart';


class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Tableau de bord"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Header(),

                    const SizedBox(height: 24),

                    isMobile
                        ? const _MobileLayout()
                        : const _WebLayout(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Bonjour 👋",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Bienvenue dans votre espace client sécurisé",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "🔒 Données protégées",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        RepaymentBankCard(),
        SizedBox(height: 20),
        QuickActions(),
      ],
    );
  }
}

class _WebLayout extends StatelessWidget {
  const _WebLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: RepaymentBankCard()),
          ],
        ),
        const SizedBox(height: 24),
        const QuickActions(),
      ],
    );
  }
}




class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final String firebaseUid = FirebaseAuth.instance.currentUser!.uid;
    return _Card(
      title: "Actions rapides",
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _ActionButton(
            label: "Les utilisateurs",
            icon: Icons.add_circle_outline,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AccountsUsersPage(),
                ),
              );
            },
          ),
          _ActionButton(
            label: "Mise à jour du compte",
            icon: Icons.folder_open,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminFinancialAccountPage(),
                ),
              );
            },
          ),
          _ActionButton(
            label: "Informations et envoi de contrat",
            icon: Icons.folder_open,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminLoanPage(),
                ),
              );
            },
          ),
          _ActionButton(
            label: "Validation des demandes",
            icon: Icons.folder_open,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoanAdminPage(),
                ),
              );
            },
          ),
          _ActionButton(
            label: "Discussions",
            icon: Icons.folder_open,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatAdminPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;

  const _RowItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.arrow_forward),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class RepaymentBankCard extends StatefulWidget {
  const RepaymentBankCard({super.key});

  @override
  State<RepaymentBankCard> createState() => _RepaymentBankCardState();
}

class _RepaymentBankCardState extends State<RepaymentBankCard> {
  final SupabaseClient supabase = Supabase.instance.client;
  final String firebaseUid = FirebaseAuth.instance.currentUser!.uid;

  bool loading = true;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await supabase
        .from('user_financial_accounts')
        .select(
      'receiver_full_name, iban, bic, bank_name, bank_address',
    )
        .eq('firebase_uid', firebaseUid)
        .eq('is_active', true)
        .maybeSingle();

    setState(() {
      data = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const _Card(
        title: "Informations de remboursement",
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return _Card(
        title: "Informations de remboursement",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Aucune information de remboursement disponible",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Veuillez contacter le support pour obtenir les coordonnées de remboursement.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return _Card(
      title: "Informations de remboursement",
      child: Column(
        children: [
          _RowItem("Receveur", data!['receiver_full_name'] ?? '—'),
          _RowItem("IBAN", data!['iban'] ?? '—'),
          _RowItem("BIC", data!['bic'] ?? '—'),
          _RowItem("Banque", data!['bank_name'] ?? '—'),
          _RowItem("Adresse", data!['bank_address'] ?? '—'),
        ],
      ),
    );
  }
}




class AccountsUsersPage extends StatefulWidget {
  const AccountsUsersPage({super.key});

  @override
  State<AccountsUsersPage> createState() =>
      _AccountsUsersPageState();
}

class _AccountsUsersPageState extends State<AccountsUsersPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  Map<String, dynamic>? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin — Utilisateurs"),
      ),
      body: Row(
        children: [
          // ================= LISTE UTILISATEURS =================
          SizedBox(
            width: 360,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: supabase
                  .from('profiles')
                  .select()
                  .order('created_at', ascending: false),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!;

                if (users.isEmpty) {
                  return const Center(child: Text("Aucun utilisateur"));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final u = users[index];

                    final bool hasBankInfo =
                        u['iban'] != null && (u['iban'] as String).isNotEmpty;

                    return ListTile(
                      selected: selectedUser?['id'] == u['id'],
                      title: Text(
                        u['email'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        u['receiver_full_name'] ?? '_',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        hasBankInfo ? Icons.verified : Icons.warning_amber,
                        color: hasBankInfo ? Colors.green : Colors.orange,
                      ),
                      onTap: () {
                        setState(() {
                          selectedUser = u;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),

          const VerticalDivider(width: 1),

          // ================= DETAILS =================
          Expanded(
            child: selectedUser == null
                ? const Center(
              child: Text(
                "Sélectionnez un utilisateur",
                style: TextStyle(fontSize: 16),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Informations utilisateur",
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    _InfoRow("Email", selectedUser!['email']),
                    _InfoRow("Devise", selectedUser!['currency']),
                    _InfoRow("Langue", selectedUser!['language']),
                    const Divider(height: 32),

                    _InfoRow("Nom du receveur",
                        selectedUser!['receiver_full_name']),
                    _InfoRow("IBAN", selectedUser!['iban']),
                    _InfoRow("BIC", selectedUser!['bic']),
                    _InfoRow(
                        "Banque", selectedUser!['bank_name']),
                    _InfoRow("Adresse banque",
                        selectedUser!['bank_address']),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= WIDGET INFO + COPIE =================

class _InfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final displayValue =
    value == null || value!.isEmpty ? '_' : value!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              displayValue,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          if (displayValue != '_')
            IconButton(
              tooltip: "Copier",
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: displayValue));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$label copié"),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
