import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;

    return WebCard(
      title: loc.quickActionsTitle,
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          ActionButton(
            label: loc.quickActionProfile,
            icon: Icons.person,
            onPressed: () => context.go('/profile'),
          ),
          ActionButton(
            label: loc.quickActionNewRequest,
            icon: Icons.add_circle_outline,
            onPressed: () => context.go('/request'),
          ),
          if (hasLoanAmount)
            ActionButton(
              label: loc.quickActionBankDetails,
              icon: Icons.folder_open,
              onPressed: () => context.go('/bank_details'),
            ),
          ActionButton(
            label: loc.quickActionLoanHistory,
            icon: Icons.history,
            onPressed: () => context.go('/loan_history'),
          ),
          ActionButton(
            label: loc.quickActionPaymentHistory,
            icon: Icons.history,
            onPressed: () => context.go('/transaction_history'),
          ),
          ActionButton(
            label: loc.quickActionDocumentsHistory,
            icon: Icons.history,
            onPressed: () => context.go('/documents_history'),
          ),
          ActionButton(
            label: loc.quickActionSupport,
            icon: Icons.chat_bubble_outline,
            onPressed: () => context.go('/chat'),
          ),
        ],
      ),
    );
  }
}
