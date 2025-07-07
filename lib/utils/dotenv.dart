import 'package:flutter/services.dart';

/// Parses the .env file
Future<Map<String, String>> parseDotEnv(
    {String assetsFileName = '.env'}) async {
  final lines = await rootBundle.loadString(assetsFileName);
  Map<String, String> envVariables = {};
  for (String line in lines.split('\n')) {
    line = line.trim();
    if (line.contains('=') && !line.startsWith(RegExp(r'=|#'))) {
      List<String> contents = line.split('=');
      envVariables[contents[0]] = contents.sublist(1).join('=');
    }
  }
  return envVariables;
}
