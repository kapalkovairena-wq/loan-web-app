import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AdminFinancialAccountPage extends StatefulWidget {
  final String firebaseUid;

  const AdminFinancialAccountPage({
    super.key,
    required this.firebaseUid,
  });

  @override
  State<AdminFinancialAccountPage> createState() =>
      _AdminFinancialAccountPageState();
}

class _AdminFinancialAccountPageState
    extends State<AdminFinancialAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _receiverController = TextEditingController();
  final _ibanController = TextEditingController();
  final _bicController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAddressController = TextEditingController();

  bool _loading = false;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  Future<void> _loadExistingData() async {
    final response = await supabase
        .from('user_financial_accounts')
        .select()
        .eq('firebase_uid', widget.firebaseUid)
        .eq('is_active', true)
        .maybeSingle();

    if (response != null) {
      _receiverController.text = response['receiver_full_name'] ?? '';
      _ibanController.text = response['iban'] ?? '';
      _bicController.text = response['bic'] ?? '';
      _bankNameController.text = response['bank_name'] ?? '';
      _bankAddressController.text = response['bank_address'] ?? '';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Désactiver ancien compte actif
      await supabase
          .from('user_financial_accounts')
          .update({'is_active': false})
          .eq('firebase_uid', widget.firebaseUid)
          .eq('is_active', true);

      // Insérer nouveau
      await supabase.from('user_financial_accounts').insert({
        'firebase_uid': widget.firebaseUid,
        'receiver_full_name': _receiverController.text.trim(),
        'iban': _ibanController.text.trim(),
        'bic': _bicController.text.trim(),
        'bank_name': _bankNameController.text.trim(),
        'bank_address': _bankAddressController.text.trim(),
        'is_active': true,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informations enregistrées')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compte bancaire – Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field(_receiverController, 'Nom complet du receveur'),
              _field(_ibanController, 'IBAN'),
              _field(_bicController, 'BIC'),
              _field(_bankNameController, 'Nom de la banque'),
              _field(_bankAddressController, 'Adresse de la banque', maxLines: 3),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loading ? null : _save,
                icon: const Icon(Icons.save),
                label: Text(_loading ? 'Enregistrement...' : 'Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (v) =>
        v == null || v.isEmpty ? 'Champ requis' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
