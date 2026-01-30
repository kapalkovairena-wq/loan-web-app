import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import '../widgets/bank_details_card.dart';
import '../widgets/document_upload_card.dart';
import '../widgets/loan_status_card.dart';
import '../widgets/repayment_bank_card.dart';
import '../widgets/trust_card.dart';
import '../widgets/quick_actions.dart';
import '../../presentation/auth/auth_gate.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Tableau de bord"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: const _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatefulWidget {
  const _DashboardBody();

  @override
  State<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<_DashboardBody> {
  final supabase = Supabase.instance.client;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic>? loanData;
  bool loading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchLoan();

    // Rafraîchir toutes les secondes
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _fetchLoan());

    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthGate()),
        );
      });
    }
  }

  Future<void> _fetchLoan() async {
    try {
      final data = await supabase
          .from('loan_requests')
          .select('payment_bank, my_details_bank, amount, loan_status, document')
          .eq('firebase_uid', uid)
          .maybeSingle();

      if (!mounted) return;
      debugPrint('loanData: $data');

      setState(() {
        loanData = data;
        loading = false;
      });
    } catch (e) {
      debugPrint('Erreur fetchLoan: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showRepayment = loanData?['payment_bank'] ?? false;
    final showBankDetails = loanData?['my_details_bank'] ?? false;
    final documentUpload = loanData?['document'] ?? false;
    final hasLoanAmount = loanData?['amount'] != null;

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
                  const SizedBox(height: 24),
                  isMobile
                      ? _MobileLayout(
                    showRepaymentBankCard: showRepayment,
                    showBankDetailsCard: showBankDetails,
                    documentUploadCard : documentUpload,
                    hasLoanAmount: hasLoanAmount,
                  )
                      : _WebLayout(
                    showRepaymentBankCard: showRepayment,
                    showBankDetailsCard: showBankDetails,
                    documentUploadCard : documentUpload,
                    hasLoanAmount: hasLoanAmount,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(  // ← force le texte à prendre tout l’espace restant
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Bonjour 👋",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                "Bienvenue dans votre espace client sécurisé",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "🔒 Données protégées",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}


class _MobileLayout extends StatelessWidget {
  final bool showRepaymentBankCard;
  final bool showBankDetailsCard;
  final bool documentUploadCard;
  final bool hasLoanAmount;

  const _MobileLayout({
    required this.showRepaymentBankCard,
    required this.showBankDetailsCard,
    required this.documentUploadCard,
    required this.hasLoanAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LoanStatusCard(),
        const SizedBox(height: 20),

        if (showRepaymentBankCard) ...[
          const RepaymentBankCard(),
          const SizedBox(height: 20),
        ],

        if (showBankDetailsCard) ...[
          const BankDetailsCard(),
          const SizedBox(height: 20),
        ],

        if (documentUploadCard) ...[
          const DocumentUploadCard(),
          const SizedBox(height: 20),
        ],

        const TrustCard(),
        const SizedBox(height: 20),
        QuickActions(hasLoanAmount: hasLoanAmount),
      ],
    );
  }
}

class _WebLayout extends StatelessWidget {
  final bool showRepaymentBankCard;
  final bool showBankDetailsCard;
  final bool documentUploadCard;
  final bool hasLoanAmount;

  const _WebLayout({
    required this.showRepaymentBankCard,
    required this.showBankDetailsCard,
    required this.documentUploadCard,
    required this.hasLoanAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: LoanStatusCard()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            if (showRepaymentBankCard)
              const Expanded(child: RepaymentBankCard()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            if (showBankDetailsCard)
              const Expanded(child: BankDetailsCard()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            if (documentUploadCard)
              const Expanded(child: DocumentUploadCard()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(child: TrustCard()),
          ],
        ),
        const SizedBox(height: 24),
        QuickActions(hasLoanAmount: hasLoanAmount),
      ],
    );
  }
}