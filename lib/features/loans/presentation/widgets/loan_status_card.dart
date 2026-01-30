import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Pour kIsWeb
import 'dart:async';
import 'package:go_router/go_router.dart';

import '../widgets/web_card.dart';
import '../auth/loan_service.dart';

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
      cardWidget = const WebCard(
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


  Widget _noRequest(BuildContext context) => WebCard(
    title: "Statut de votre prêt",
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Aucune demande en cours",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            context.goNamed('loan_request');
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

  Widget _statusCard(String title, String desc, Color color) =>
      WebCard(
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