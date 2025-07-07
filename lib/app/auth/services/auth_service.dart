import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabaseClient.auth
        .signInWithPassword(password: password, email: email);
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await _supabaseClient.auth.signUp(password: password, email: email);
  }

  Future<void> signOut() async {
    return await _supabaseClient.auth.signOut();
  }

  Map<String, dynamic>? getCurrentUser() {
    final session = _supabaseClient.auth.currentSession;
    final user = session?.user;
    return {
      "email": user?.email,
      "uid": user?.id,
    };
  }
}
