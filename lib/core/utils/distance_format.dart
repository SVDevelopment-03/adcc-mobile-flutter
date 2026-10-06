/// Returns a display label such as `42 km` for an event/track distance, or
/// `null` when [raw] is missing, not a number, or zero — callers should hide
/// the distance instead of showing `0 km`.
String? distanceLabelOrNull(Object? raw) {
  if (raw == null) return null;

  if (raw is num) {
    if (raw <= 0) return null;
    final value = raw == raw.roundToDouble() ? raw.round() : raw;
    return '$value km';
  }

  final text = raw.toString().trim();
  final match = RegExp(r'\d+(\.\d+)?').firstMatch(text);
  final value = match == null ? null : double.tryParse(match.group(0)!);
  if (value == null || value <= 0) return null;

  return text.toLowerCase().contains('km') ? text : '$text km';
}
