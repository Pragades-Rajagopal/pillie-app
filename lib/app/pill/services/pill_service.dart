import 'package:pillie/models/pill_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PillService {
  String userId;

  PillService(this.userId);

  final SupabaseQueryBuilder database = Supabase.instance.client.from(
    'pills_inventory',
  );

  Future addPill(PillModel pill) async {
    try {
      await database.insert(pill.toMap(userId));
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }

  Future editPill(PillModel pill, String pillId) async {
    try {
      await database.update(pill.toMap(userId)).eq("id", pillId);
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }

  Stream<List<PillModel>> get pillStream => Supabase.instance.client
      .from('pills_inventory')
      .stream(primaryKey: ["id"])
      .eq('user_id', userId)
      .order('count', ascending: true)
      .map(
        (data) => data.map((pillMap) => PillModel.fromMap(pillMap)).toList(),
      );

  Future<List<PillModel>> getAllPills() async {
    try {
      final response = await database
          .select()
          .eq('user_id', userId)
          .eq('is_archived', false)
          .order('count', ascending: true);
      return response.map((pillMap) => PillModel.fromMap(pillMap)).toList();
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }

  Future archiveRestorePill(String pillId, bool flag) async {
    try {
      await database
          .update({"is_archived": flag})
          .eq("id", pillId)
          .eq("user_id", userId);
    } catch (e, stackTrace) {
      print(stackTrace);
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }

  Future deletePill(String pillId) async {
    try {
      await database.delete().eq("id", pillId).eq("user_id", userId);
    } catch (e, stackTrace) {
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }
}
