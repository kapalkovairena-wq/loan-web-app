import 'package:flutter/material.dart';

import '../widgets/web_card.dart';

class TrustCard extends StatelessWidget {
  const TrustCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WebCard(
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