T? sanitizeValue<T>(dynamic value) =>
    value is T && value != null ? value : null;

String convertDateFormat(
  String input, {
  String format = 'mdy',
  String separator = '/',
}) {
  if (input.isEmpty) return '';
  final parts = input.split(separator);
  if (parts.length != 3) throw const FormatException('Invalid date format');
  if (format == 'dmy') {
    final day = parts[2].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[0];
    return '$day/$month/$year';
  }
  final day = parts[0].padLeft(2, '0');
  final month = parts[1].padLeft(2, '0');
  final year = parts[2];
  return '$month/$day/$year';
}
