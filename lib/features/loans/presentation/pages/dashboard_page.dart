import 'package:flutter/material.dart';
import '../pages/loan_request_page.dart';
import '../pages/chat_user_page.dart';
import '../auth/loan_service.dart';

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
        LoanStatusCard(),
        SizedBox(height: 20),
        LoanSimulationCard(),
        SizedBox(height: 20),
        LastRequestCard(),
        SizedBox(height: 20),
        TrustCard(),
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
            Expanded(child: LoanStatusCard()),
            SizedBox(width: 24),
            Expanded(child: LoanSimulationCard()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: const [
            Expanded(child: LastRequestCard()),
            SizedBox(width: 24),
            Expanded(child: TrustCard()),
          ],
        ),
        const SizedBox(height: 24),
        const QuickActions(),
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


class LoanSimulationCard extends StatelessWidget {
  const LoanSimulationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Simulation indicative",
      child: Column(
        children: const [
          _RowItem("Montant", "300 000 FCFA"),
          _RowItem("Durée", "6 mois"),
          _RowItem("Mensualité", "52 000 FCFA"),
          _RowItem("Taux annuel", "3%"),
        ],
      ),
    );
  }
}

class LastRequestCard extends StatelessWidget {
  const LastRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Dernière demande",
      child: Column(
        children: const [
          _RowItem("Date", "—"),
          _RowItem("Montant", "—"),
          _RowItem("Statut", "—"),
        ],
      ),
    );
  }
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
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Actions rapides",
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
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
          _ActionButton(
            label: "Mes documents",
            icon: Icons.folder_open,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoanRequestPage(),
                ),
              );
            },
          ),
          _ActionButton(
            label: "Historique",
            icon: Icons.history,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoanRequestPage(),
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

