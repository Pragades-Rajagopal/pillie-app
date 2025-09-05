import 'package:workmanager/workmanager.dart';
import 'package:pillie/app/auth/services/auth_service.dart';
import 'package:pillie/utils/cron/functions.dart';

const String pillResetTask = "pillResetTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == pillResetTask) {
      final user = AuthService().getCurrentUser();
      if (user != null && user["uid"] != null) {
        final userId = user["uid"]!;
        await resetPillCountsDaily(userId);
      }
    }
    return Future.value(true);
  });
}

void initCronJobs() {
  Workmanager().initialize(callbackDispatcher);
  // Calculate initial delay to 9pm
  final now = DateTime.now();
  // test it for 22:48
  final next9pm = DateTime(now.year, now.month, now.day, 22, 48);
  final initialDelay = next9pm.isAfter(now)
      ? next9pm.difference(now)
      : next9pm.add(const Duration(days: 1)).difference(now);
  Workmanager().registerPeriodicTask(
    pillResetTask,
    pillResetTask,
    frequency: const Duration(hours: 24),
    initialDelay: initialDelay,
    constraints: Constraints(networkType: NetworkType.connected),
  );
}

void stopAllCronJobs() {
  Workmanager().cancelAll();
}
