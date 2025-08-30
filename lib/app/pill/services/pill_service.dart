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

  Future archivePill(String pillId) async {
    try {
      await database
          .update({"is_archived": true})
          .eq("id", pillId)
          .eq("user_id", userId);
    } catch (e, stackTrace) {
      print(stackTrace);
      throw Error.throwWithStackTrace(e, stackTrace);
    }
  }

  Future restorePill(String pillId) async {
    try {
      await database
          .update({"is_archived": false})
          .eq("id", pillId)
          .eq("user_id", userId);
    } catch (e, stackTrace) {
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
