import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

import '../widgets/web_card.dart';
import '../widgets/row_item.dart';

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
      return const WebCard(
        title: "Vos coordonnées bancaires",
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null ||
        data!['iban'] == null ||
        (data!['iban'] as String).isEmpty) {
      return WebCard(
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

    return WebCard(
      title: "Vos coordonnées bancaires",
      child: Column(
        children: [
          RowItem("Receveur", data!['receiver_full_name'] ?? '—'),
          RowItem("IBAN", data!['iban'] ?? '—'),
          RowItem("BIC", data!['bic'] ?? '—'),
          RowItem("Banque", data!['bank_name'] ?? '—'),
          RowItem("Adresse", data!['bank_address'] ?? '—'),
        ],
      ),
    );
  }
}