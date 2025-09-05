import 'package:pillie/app/pill/services/pill_service.dart';
import 'package:pillie/models/pill_model.dart';

Future<void> resetPillCountsDaily(String userId) async {
  try {
    final pillService = PillService(userId);
    final List<PillModel> pills = await pillService.getAllPills();
    if (pills.isEmpty) return;
    for (var pill in pills) {
      if (pill.count != null && pill.count! > 0) {
        pill.count =
            pill.count! -
            ((pill.day! ? 1 : 0) +
                (pill.noon! ? 1 : 0) +
                (pill.night! ? 1 : 0));
        if (pill.count! < 0) pill.count = 0;
        await pillService.editPill(pill, pill.id!);
      }
    }
  } catch (e) {
    print('Error occurred while resetting pill counts: $e');
  }
}
