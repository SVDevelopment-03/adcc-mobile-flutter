import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Shared sizing for the home weather cards. Phones narrower than 360dp
/// get a slightly smaller scale so text never crowds or overflows.
class _WeatherCardMetrics {
  final bool compact;

  const _WeatherCardMetrics._(this.compact);

  factory _WeatherCardMetrics.of(BuildContext context) =>
      _WeatherCardMetrics._(MediaQuery.sizeOf(context).width < 360);

  EdgeInsetsDirectional get padding => EdgeInsetsDirectional.symmetric(
        horizontal: compact ? 12 : 14,
        vertical: compact ? 10 : 12,
      );

  double get titleSize => compact ? 14 : 16;
  double get citySize => compact ? 11.5 : 12.5;
  double get timeSize => compact ? 10 : 11;
  double get tempSize => compact ? 16 : 18;
  double get iconSize => compact ? 34 : 40;
  double get highLowSize => compact ? 10 : 11;
  double get alertSize => compact ? 11 : 12;
}

TextStyle _outfit(double size, Color color, {FontWeight? weight}) => TextStyle(
      fontFamily: 'Outfit',
      fontSize: size,
      fontWeight: weight ?? FontWeight.w400,
      height: 1.25,
      color: color,
    );

// ─────────────────────────────────────────────
// Card type 1 — Current Weather
// Figma: background #FFDA9B, decorative amber circles
// ─────────────────────────────────────────────
class WeatherCard extends StatelessWidget {
  final String city;
  final String time;
  final int temperature;
  final int highTemp;
  final int lowTemp;
  final String weatherIcon;

  const WeatherCard({
    super.key,
    required this.city,
    required this.time,
    required this.temperature,
    required this.highTemp,
    required this.lowTemp,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final m = _WeatherCardMetrics.of(context);
    const textColor = Color(0xFF000000);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFDA9B),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Decorative concentric circles
          const Positioned(
            left: 82,
            top: 26,
            child: SizedBox(
              width: 172,
              height: 172,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x1FDA8A01),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 100,
            top: 44,
            child: SizedBox(
              width: 135,
              height: 135,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x1FC3861D),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 122,
            top: 66,
            child: SizedBox(
              width: 92,
              height: 92,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x1FBA7807),
                ),
              ),
            ),
          ),

          // Main content, vertically centred in the card
          Positioned.fill(
            child: Padding(
              padding: m.padding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left: current location / city / time
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.currentLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _outfit(m.titleSize, textColor,
                              weight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          city,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _outfit(m.citySize, textColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _outfit(m.timeSize, textColor),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Right: weather icon + temp + H/L
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            weatherIcon,
                            width: m.iconSize,
                            height: m.iconSize,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$temperature${l10n.temperatureUnit}',
                            style: _outfit(m.tempSize, textColor,
                                weight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.highTemp}:$highTemp${l10n.temperatureUnit}  '
                        '${l10n.lowTemp}:$lowTemp${l10n.temperatureUnit}',
                        maxLines: 1,
                        style: _outfit(m.highLowSize, textColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card type 2 & 3 — Weather Alert Cards
// Figma: background #FFEFD7, left: title/city/time + red icon, right: alert text
// ─────────────────────────────────────────────
class WeatherAlertCard extends StatelessWidget {
  final String city;
  final String time;
  final String alertTitle;
  final String alertMessage;
  final WeatherAlertType alertType;

  const WeatherAlertCard({
    super.key,
    required this.city,
    required this.time,
    required this.alertTitle,
    required this.alertMessage,
    required this.alertType,
  });

  @override
  Widget build(BuildContext context) {
    final m = _WeatherCardMetrics.of(context);
    const textColor = Color(0xFF1A1C20);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFD7),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: m.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: title / city / time + alert icon
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alertTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      _outfit(m.titleSize, textColor, weight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  city,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _outfit(m.citySize, textColor),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        time,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _outfit(m.timeSize, textColor),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _AlertIcon(type: alertType),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Right: advisory message
          Expanded(
            flex: 5,
            child: Text(
              alertMessage,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: _outfit(m.alertSize, textColor),
            ),
          ),
        ],
      ),
    );
  }
}

enum WeatherAlertType { uv, wind }

// Draws the red alert icon using CustomPaint to match Figma's Vector paths
class _AlertIcon extends StatelessWidget {
  final WeatherAlertType type;

  const _AlertIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter:
            type == WeatherAlertType.uv ? _UvIconPainter() : _WindIconPainter(),
      ),
    );
  }
}

// UV icon: 3 horizontal bars (Figma: 3 Vector lines stacked)
class _UvIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC12D32)
      ..strokeWidth = 1.67
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Top bar: ~83.3% width, at 12.5% from top
    canvas.drawLine(
      Offset(w * 0.083, h * 0.125),
      Offset(w * 0.917, h * 0.125),
      paint,
    );
    // Middle bar: ~83.3% width, at 37.5% from top
    canvas.drawLine(
      Offset(w * 0.083, h * 0.375),
      Offset(w * 0.917, h * 0.375),
      paint,
    );
    // Bottom bar: ~83.3% width, at 70.8% from top
    canvas.drawLine(
      Offset(w * 0.083, h * 0.708),
      Offset(w * 0.917, h * 0.708),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Wind icon: 3 lines of varying width (Figma: Wind advisory icon)
class _WindIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC12D32)
      ..strokeWidth = 1.67
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Top short line: 8.34%→54.17% at 16.67%
    canvas.drawLine(
      Offset(w * 0.083, h * 0.167),
      Offset(w * 0.542, h * 0.167),
      paint,
    );
    // Middle full line: 8.34%→91.67% at 29.16%
    canvas.drawLine(
      Offset(w * 0.083, h * 0.292),
      Offset(w * 0.917, h * 0.292),
      paint,
    );
    // Bottom medium line: 8.34%→66.67% at 66.68%
    canvas.drawLine(
      Offset(w * 0.083, h * 0.667),
      Offset(w * 0.667, h * 0.667),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Compact weather display used in headers to match WeatherCard styles.
class CompactWeather extends StatelessWidget {
  final String weatherIcon;
  final int temperature;
  final int? highTemp;
  final int? lowTemp;

  const CompactWeather({
    super.key,
    required this.weatherIcon,
    required this.temperature,
    this.highTemp,
    this.lowTemp,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSmallScreen = MediaQuery.of(context).size.height < 600;
    final iconSize = isSmallScreen ? 32.0 : 40.0;
    final fontSize = isSmallScreen ? 14.0 : 16.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          weatherIcon,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 4),
        Text(
          '$temperature${l10n.temperatureUnit}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}
