import 'package:flutter/material.dart';

import '../pages/loan_request_page.dart';
import '../pages/chat_user_page.dart';
import '../pages/bank_details_page.dart';
import '../pages/loan_history_page.dart';
import '../pages/client_profile_page.dart';
import '../pages/transaction_history_page.dart';
import '../pages/user_documents_history_page.dart';

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClientProfilePage(),
                ),
              );
            },
          ),
          ActionButton(
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
            ActionButton(
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
          ActionButton(
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
          ActionButton(
            label: "Historique des paiements",
            icon: Icons.history,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TransactionHistoryPage(),
                ),
              );
            },
          ),
          ActionButton(
            label: "Historique des documents",
            icon: Icons.history,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserDocumentsHistoryPage(),
                ),
              );
            },
          ),
          ActionButton(
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