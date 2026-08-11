import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

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

    return Container(
      height: 105,
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

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: current location / city / time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.currentLocation,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 1.28,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        city,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.28,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        time,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          height: 1.27,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Right: weather icon + temp + H/L
                SizedBox(
                  width: 114,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            weatherIcon,
                            width: 48,
                            height: 48,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$temperature${l10n.temperatureUnit}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1.28,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${l10n.highTemp}:$highTemp${l10n.temperatureUnit}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              height: 1.27,
                              color: Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${l10n.lowTemp}:$lowTemp${l10n.temperatureUnit}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              height: 1.27,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFD7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 155,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    alertTitle,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.28,
                      color: Color(0xFF1A1C20),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.28,
                      color: Color(0xFF1A1C20),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          height: 1.27,
                          color: Color(0xFF1A1C20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _AlertIcon(type: alertType),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                alertMessage,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.28,
                  color: Color(0xFF1A1C20),
                ),
              ),
            ),
          ],
        ),
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          weatherIcon,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 4),
        Text(
          '$temperature${l10n.temperatureUnit}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}
