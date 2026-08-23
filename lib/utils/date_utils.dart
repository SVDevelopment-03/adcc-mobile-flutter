import 'package:intl/intl.dart';

String formatIsoDateForDisplay(String? iso, {String format = 'MMM dd, yyyy'}) {
  if (iso == null || iso.isEmpty) return '';
  try {
    final dateTime = DateTime.parse(iso);
    return DateFormat(format).format(dateTime);
  } catch (_) {
    if (iso.contains('T')) return iso.split('T')[0];
    return iso;
  }
}
