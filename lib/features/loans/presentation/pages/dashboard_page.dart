import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/loan_request_page.dart';
import '../pages/chat_user_page.dart';
import '../pages/bank_details_page.dart';
import '../auth/loan_service.dart';
import '../pages/loan_history_page.dart';
import '../pages/client_profile_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
      body: const _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<Map<String, dynamic>?>(
      future: supabase
          .from('loan_requests')
          .select('payment_bank, my_details_bank, amount')
          .eq('firebase_uid', uid)
          .maybeSingle(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final loanData = snapshot.data;
        final showRepayment = loanData?['payment_bank'] ?? false;
        final showBankDetails = loanData?['my_details_bank'] ?? false;
        final hasLoanAmount = loanData?['amount'] != null;

        return LayoutBuilder(
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
                          ? _MobileLayout(
                        showRepaymentBankCard: showRepayment,
                        showBankDetailsCard: showBankDetails,
                        hasLoanAmount: hasLoanAmount,
                      )
                          : _WebLayout(
                        showRepaymentBankCard: showRepayment,
                        showBankDetailsCard: showBankDetails,
                        hasLoanAmount: hasLoanAmount,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
  final bool showRepaymentBankCard;
  final bool showBankDetailsCard;
  final bool hasLoanAmount;

  const _MobileLayout({
    required this.showRepaymentBankCard,
    required this.showBankDetailsCard,
    required this.hasLoanAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LoanStatusCard(),
        const SizedBox(height: 20),

        if (showRepaymentBankCard) ...[
          const RepaymentBankCard(),
          const SizedBox(height: 20),
        ],

        if (showBankDetailsCard) ...[
          const BankDetailsCard(),
          const SizedBox(height: 20),
        ],

        const TrustCard(),
        const SizedBox(height: 20),
        QuickActions(hasLoanAmount: hasLoanAmount),
      ],
    );
  }
}

class _WebLayout extends StatelessWidget {
  final bool showRepaymentBankCard;
  final bool showBankDetailsCard;
  final bool hasLoanAmount;

  const _WebLayout({
    required this.showRepaymentBankCard,
    required this.showBankDetailsCard,
    required this.hasLoanAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: LoanStatusCard()),
            const SizedBox(width: 24),
            if (showRepaymentBankCard)
              const Expanded(child: RepaymentBankCard()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            if (showBankDetailsCard) const Expanded(child: BankDetailsCard()),
            const SizedBox(width: 24),
            const Expanded(child: TrustCard()),
          ],
        ),
        const SizedBox(height: 24),
        QuickActions(hasLoanAmount: hasLoanAmount),
      ],
    );
  }
}

class LoanStatusCard extends StatefulWidget {
  const LoanStatusCard({super.key});

  @override
  State<LoanStatusCard> createState() => _LoanStatusCardState();
}

class _LoanStatusCardState extends State<LoanStatusCard> {
  final _service = LoanService();
  LoanRequest? loan;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    loan = await _service.fetchActiveLoan();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    Widget cardWidget;

    if (loading) {
      cardWidget = const _Card(
        title: "Statut de votre prêt",
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (loan == null) {
      cardWidget = _noRequest(context);
    } else {
      switch (loan!.status) {
        case LoanStatus.pending:
          cardWidget = _pending();
          break;
        case LoanStatus.approved:
          cardWidget = _approved();
          break;
        case LoanStatus.rejected:
          cardWidget = _rejected();
          break;
        default:
          cardWidget = _noRequest(context);
      }
    }

    // Ajoute une clé unique pour l'animation
    cardWidget = KeyedSubtree(
      key: ValueKey(loan?.status ?? 'none'),
      child: cardWidget,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: cardWidget, // ← le widget avec une clé unique
    );
  }


  Widget _noRequest(BuildContext context) => _Card(
    title: "Statut de votre prêt",
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Aucune demande en cours",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => const LoanRequestPage(),
                transitionsBuilder: (_, animation, __, child) =>
                    SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
              ),
            );
          },
          child: const Text("Faire une demande"),
        ),
      ],
    ),
  );

  Widget _pending() => _statusCard(
    "⏳ Demande en cours",
    "Notre équipe analyse votre dossier.",
    Colors.orange,
  );

  Widget _approved() => _statusCard(
    "✅ Demande approuvée",
    "Les fonds seront bientôt disponibles.",
    Colors.green,
  );

  Widget _rejected() => _statusCard(
    "❌ Demande refusée",
    "Vous pouvez soumettre une nouvelle demande.",
    Colors.red,
  );

  Widget _statusCard(String title, String desc, Color color) => _Card(
    title: "Statut de votre prêt",
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
            TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 8),
        Text(desc),
      ],
    ),
  );
}

class TrustCard extends StatelessWidget {
  const TrustCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Pourquoi nous faire confiance ?",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("✔️ Taux transparents"),
          Text("✔️ Analyse rapide"),
          Text("✔️ Données sécurisées"),
          Text("✔️ Assistance dédiée"),
        ],
      ),
    );
  }
}

class QuickActions extends StatelessWidget {
  final bool hasLoanAmount;

  const QuickActions({
    super.key,
    required this.hasLoanAmount,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Actions rapides",
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _ActionButton(
            label: "Profil",
            icon: Icons.person,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClientProfilePage(),
                ),
              );
            },
          ),
          _ActionButton(
            label: "Nouvelle demande",
            icon: Icons.add_circle_outline,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoanRequestPage(),
                ),
              );
            },
          ),
          if (hasLoanAmount)
            _ActionButton(
            label: "Mes coordonnées bancaires",
            icon: Icons.folder_open,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BankDetailsPage(),
                ),
              );
            },
          ),
          _ActionButton(
            label: "Historique des demandes",
            icon: Icons.history,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoanHistoryPage(),
                ),
              );
            },
          ),
          _ActionButton(
            label: "Support",
            icon: Icons.chat_bubble_outline,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatUserPage(),
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

class BankDetailsCard extends StatefulWidget {
  const BankDetailsCard({super.key});

  @override
  State<BankDetailsCard> createState() => _BankDetailsCardState();
}

class _BankDetailsCardState extends State<BankDetailsCard> {
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
        .from('profiles')
        .select(
      'receiver_full_name, iban, bic, bank_name, bank_address',
    )
        .eq('firebase_uid', firebaseUid)
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
        title: "Vos coordonnées bancaires",
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null ||
        data!['iban'] == null ||
        (data!['iban'] as String).isEmpty) {
      return _Card(
        title: "Vos coordonnées bancaires",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Aucune information bancaire enregistrée",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Veuillez renseigner vos coordonnées pour recevoir les fonds.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return _Card(
      title: "Coordonnées bancaires",
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
        title: "Les coordonnées bancaires de paiement",
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return _Card(
        title: "Les coordonnées bancaires de paiement",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Aucune information de paiement disponible",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Veuillez contacter le support pour obtenir les coordonnées de paiement.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return _Card(
      title: "Les coordonnées bancaires de paiement",
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
