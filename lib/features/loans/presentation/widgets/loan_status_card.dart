import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;

    Widget cardWidget;

    if (loading) {
      cardWidget = WebCard(
        title: loc.loanStatusTitle,
        child: const Center(child: CircularProgressIndicator()),
      );
    } else if (loan == null) {
      cardWidget = _noRequest(context, loc);
    } else {
      switch (loan!.status) {
        case LoanStatus.pending:
          cardWidget = _statusCard(
            loc.loanStatusPendingTitle,
            loc.loanStatusPendingDescription,
            Colors.orange,
            loc,
          );
          break;
        case LoanStatus.approved:
          cardWidget = _statusCard(
            loc.loanStatusApprovedTitle,
            loc.loanStatusApprovedDescription,
            Colors.green,
            loc,
          );
          break;
        case LoanStatus.rejected:
          cardWidget = _statusCard(
            loc.loanStatusRejectedTitle,
            loc.loanStatusRejectedDescription,
            Colors.red,
            loc,
          );
          break;
        default:
          cardWidget = _noRequest(context, loc);
      }
    }

    cardWidget = KeyedSubtree(
      key: ValueKey(loan?.status ?? 'none'),
      child: cardWidget,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: cardWidget,
    );
  }

  Widget _noRequest(BuildContext context, AppLocalizations loc) => WebCard(
    title: loc.loanStatusTitle,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.loanStatusNoneTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => context.goNamed('loan_request'),
          child: Text(loc.loanStatusActionRequest),
        ),
      ],
    ),
  );

  Widget _statusCard(
      String title,
      String description,
      Color color,
      AppLocalizations loc,
      ) =>
      WebCard(
        title: loc.loanStatusTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      );
}
