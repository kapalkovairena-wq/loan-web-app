import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoanService {
  final _supabase = Supabase.instance.client;
  final _firebaseAuth = FirebaseAuth.instance;

  Future<LoanRequest?> fetchActiveLoan() async {
    final uid = _firebaseAuth.currentUser!.uid;

    final response = await _supabase
        .from('loan_requests')
        .select()
        .eq('firebase_uid', uid)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return LoanRequest.fromMap(response);
  }
}

enum LoanStatus { none, pending, approved, rejected }

class LoanRequest {
  final String id;
  final double amount;
  final LoanStatus status;
  final DateTime createdAt;

  LoanRequest({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory LoanRequest.fromMap(Map<String, dynamic> map) {
    return LoanRequest(
      id: map['id'],
      amount: (map['amount'] as num).toDouble(),
      status: LoanStatus.values.firstWhere(
            (e) => e.name == map['loan_status'],
        orElse: () => LoanStatus.pending,
      ),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
