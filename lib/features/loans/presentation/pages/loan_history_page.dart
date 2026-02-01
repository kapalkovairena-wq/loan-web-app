import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';

import '../../presentation/auth/auth_gate.dart';

class LoanHistoryPage extends StatefulWidget {
  const LoanHistoryPage({super.key});

  @override
  State<LoanHistoryPage> createState() => _LoanHistoryPageState();
}

class _LoanHistoryPageState extends State<LoanHistoryPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> requests = [];
  Map<String, dynamic> profileData = {};
  bool isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
    _loadProfile();

    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthGate()),
        );
      });
    }
  }

  Future<void> loadRequests() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    final data = await supabase
        .from('loan_requests')
        .select()
        .eq('firebase_uid', firebaseUser.uid)
        .order('created_at', ascending: false);

    setState(() => requests = List<Map<String, dynamic>>.from(data));
  }

  Future<void> _loadProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      setState(() {
        profileData = {'currency': '€'};
        isLoadingProfile = false;
      });
      return;
    }

    try {
      final response = await supabase
          .from('profiles')
          .select('currency')
          .eq('firebase_uid', firebaseUser.uid)
          .single();

      setState(() {
        profileData = response;
        isLoadingProfile = false;
      });
    } catch (_) {
      setState(() {
        profileData = {'currency': '€'};
        isLoadingProfile = false;
      });
    }
  }

  String get currency => profileData['currency'] ?? '€';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoadingProfile) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(l10n.loanHistoryTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: requests.isEmpty
          ? Center(child: Text(l10n.loanHistoryEmpty))
          : ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: requests.length,
        itemBuilder: (_, i) => _loanCard(context, requests[i]),
      ),
    );
  }

  Widget _loanCard(BuildContext context, Map<String, dynamic> data) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    data['full_name'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                _statusBadge(context, data['loan_status']),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              "${l10n.loanSubmittedOn} ${DateFormat('dd/MM/yyyy').format(
                DateTime.parse(data['created_at']),
              )}",
              style: TextStyle(color: Colors.grey[600]),
            ),

            const Divider(height: 30),

            _section(
              l10n.personalInformation,
              {
                l10n.email: data['email'],
                l10n.phone: data['phone'],
                l10n.address: data['address'],
                l10n.city: data['city'],
                l10n.country: data['country'],
              },
            ),

            _section(
              l10n.financialInformation,
              {
                l10n.profession: data['profession'],
                l10n.incomeSource: data['income_source'],
                l10n.requestedAmount: "${data['amount']} $currency",
                l10n.duration: "${data['duration_months']} ${l10n.months}",
              },
            ),

            _section(
              l10n.loanSummary,
              {
                l10n.monthlyPayment:
                "${data['monthly_payment']} $currency",
                l10n.totalInterest:
                "${data['total_interest']} $currency",
                l10n.totalToRepay:
                "${data['total_amount']} $currency",
              },
            ),

            const SizedBox(height: 20),
            Text(
              l10n.submittedDocuments,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _documentPreview(
                  title: l10n.identityDocument,
                  imageUrl: data['identity_document_url'],
                ),
                const SizedBox(width: 16),
                _documentPreview(
                  title: l10n.addressProof,
                  imageUrl: data['address_proof_url'],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, Map<String, String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...items.entries.map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(e.key,
                        style: TextStyle(color: Colors.grey[700])),
                  ),
                  Expanded(
                    child: Text(e.value,
                        style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentPreview({
    required String title,
    required String imageUrl,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;

    Color color = Colors.orange;
    String text = l10n.statusPending;

    if (status == "approved") {
      color = Colors.green;
      text = l10n.statusApproved;
    } else if (status == "rejected") {
      color = Colors.red;
      text = l10n.statusRejected;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}
