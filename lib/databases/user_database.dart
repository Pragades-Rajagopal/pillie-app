import 'package:pillie/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDatabase {
  final SupabaseQueryBuilder database = Supabase.instance.client.from('users');

  Future getUser(String userId) async {
    try {
      return await database.select().eq('id', userId);
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }

  Future addUser(UserModel user) async {
    try {
      await database.insert(user.toMap());
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }

  Future updateUser(UserModel data, String userId) async {
    try {
      await database.update(data.toMap()).eq('id', userId);
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }
}
