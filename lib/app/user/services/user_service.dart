import 'package:pillie/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseQueryBuilder userClient = Supabase.instance.client.from(
    'users',
  );

  Future getUser(String userId) async {
    try {
      return await userClient.select().eq('id', userId);
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }

  Future upsertUser(UserModel user) async {
    try {
      await userClient.upsert(user.toMap());
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }
}
