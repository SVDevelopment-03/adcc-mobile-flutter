import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Width for a card designed at [designWidth] that must still fit on narrow
/// screens: never wider than the screen minus [horizontalMargin] (the list's
/// side padding). Unbounded widths (`double.infinity`) are returned as-is.
double fitCardWidth(
  BuildContext context,
  double designWidth, {
  double horizontalMargin = 32,
}) {
  if (!designWidth.isFinite) return designWidth;
  final available = MediaQuery.sizeOf(context).width - horizontalMargin;
  return math.max(0, math.min(designWidth, available));
}
