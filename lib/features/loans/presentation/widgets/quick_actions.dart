import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/web_card.dart';
import '../widgets/action_button.dart';

class QuickActions extends StatelessWidget {
  final bool hasLoanAmount;

  const QuickActions({
    super.key,
    required this.hasLoanAmount,
  });

  @override
  Widget build(BuildContext context) {
    return WebCard(
      title: "Actions rapides",
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          ActionButton(
            label: "Profil",
            icon: Icons.person,
            onPressed: () =>
                context.go('/profile'),
          ),
          ActionButton(
            label: "Nouvelle demande",
            icon: Icons.add_circle_outline,
            onPressed: () =>
                context.go('/request'),
          ),
          if (hasLoanAmount)
            ActionButton(
              label: "Mes coordonnées bancaires",
              icon: Icons.folder_open,
              onPressed: () =>
                  context.go('/bank_details'),
            ),
          ActionButton(
            label: "Historique des demandes",
            icon: Icons.history,
            onPressed: () =>
                context.go('/loan_history'),
          ),
          ActionButton(
            label: "Historique des paiements",
            icon: Icons.history,
            onPressed: () =>
                context.go('/transaction_history'),
          ),
          ActionButton(
            label: "Historique des documents",
            icon: Icons.history,
            onPressed: () =>
                context.go('/documents_history'),
          ),
          ActionButton(
            label: "Support",
            icon: Icons.chat_bubble_outline,
            onPressed: () =>
                context.go('/chat'),
          ),
        ],
      ),
    );
  }
}