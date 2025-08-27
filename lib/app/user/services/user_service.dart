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

  Future addUser(UserModel user) async {
    try {
      await userClient.insert(user.toMap());
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }

  Future updateUser(UserModel data, String userId) async {
    try {
      await userClient.update(data.toMap()).eq('id', userId);
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }
}
