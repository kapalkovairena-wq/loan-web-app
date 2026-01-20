import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAdminService {
  static final _supabase = Supabase.instance.client;

  static Future<bool> isAdmin(String email) async {
    final res = await _supabase
        .from('admins')
        .select('email')
        .eq('email', email)
        .maybeSingle();

    return res != null;
  }
}
