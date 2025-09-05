import 'package:flutter/material.dart';
import 'package:pillie/app/auth/auth_gate.dart';
import 'package:pillie/clients/supabase_init.dart';
import 'package:pillie/utils/cron/cron.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  // Initialize cron jobs
  initCronJobs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.white,
          primary: Colors.white,
          secondary: Colors.grey[700]!,
          tertiary: Colors.grey[500]!,
          surfaceContainer: Colors.lightBlue[100]!,
        ),
      ),
      home: const AuthGate(),
    );
  }
}
