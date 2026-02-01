import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/web_card.dart';
import '../widgets/row_item.dart';
import '../../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      return WebCard(
        title: l10n.bankDetailsTitle,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null ||
        data!['iban'] == null ||
        (data!['iban'] as String).isEmpty) {
      return WebCard(
        title: l10n.bankDetailsTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.bankDetailsEmptyTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.bankDetailsEmptyDescription,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return WebCard(
      title: l10n.bankDetailsTitle,
      child: Column(
        children: [
          RowItem(l10n.bankReceiver, data!['receiver_full_name'] ?? '—'),
          RowItem(l10n.bankIban, data!['iban'] ?? '—'),
          RowItem(l10n.bankBic, data!['bic'] ?? '—'),
          RowItem(l10n.bankName, data!['bank_name'] ?? '—'),
          RowItem(l10n.bankAddress, data!['bank_address'] ?? '—'),
        ],
      ),
    );
  }
}
