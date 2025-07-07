import 'package:pillie/utils/dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> init() async {
  final env = await parseDotEnv();
  await Supabase.initialize(
    anonKey: '${env["SUPABASE_KEY"]}',
    url: '${env["SUPABASE_URL"]}',
  );
}
