import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

import '../widgets/web_card.dart';

class TrustCard extends StatelessWidget {
  const TrustCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return WebCard(
      title: l10n.trustCardTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("✔️ ${l10n.trustCardItem1}"),
          Text("✔️ ${l10n.trustCardItem2}"),
          Text("✔️ ${l10n.trustCardItem3}"),
          Text("✔️ ${l10n.trustCardItem4}"),
        ],
      ),
    );
  }
}
