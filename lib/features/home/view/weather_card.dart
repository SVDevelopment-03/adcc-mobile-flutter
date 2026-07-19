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
        // Figma: background: #FFDA9B
        color: const Color(0xFFFFDA9B),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // ── Decorative concentric circles (Figma: Group 3) ──
          // Outermost: 172×172, left:82, top:26, #DA8A01 opacity 0.12
          Positioned(
            left: 82,
            top: 26,
            child: Container(
              width: 172,
              height: 172,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1FDA8A01), // 0.12 opacity
              ),
            ),
          ),
          // Middle: 135×135, left:100, top:44, #C3861D opacity 0.12
          Positioned(
            left: 100,
            top: 44,
            child: Container(
              width: 135,
              height: 135,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1FC3861D),
              ),
            ),
          ),
          // Inner: 92×92, left:122, top:66, #BA7807 opacity 0.12
          Positioned(
            left: 122,
            top: 66,
            child: Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1FBA7807),
              ),
            ),
          ),

          // ── Main content ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LEFT: Current location / city / time
                // Figma: Group 1437256740, width:130, centered vertically
                SizedBox(
                  width: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // "Current location" — font 18, w400
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
                      // City — font 14, w400
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
                      // Time — font 11, w400
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

                const Spacer(),

                // RIGHT: weather icon + temp + H/L
                // Figma: Group 1437256739, width:114, height:80
                SizedBox(
                  width: 114,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            weatherIcon,
                            width: 48,
                            height: 48,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 6),
                          // Temp — font 18, w700
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
                      // H: and L: on same row, font 11
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
        // Figma: background #FFEFD7
        color: const Color(0xFFFFEFD7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LEFT: title / city / time / icon
            // Figma: width ~175, centered vertically
            SizedBox(
              width: 155,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Alert title — font 18, w400
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
                  // City — font 14, w400
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
                  // Time + red alert icon row
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
                      // Red alert icon ~20×20 (Figma: Vector lines in #C12D32)
                      _AlertIcon(type: alertType),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // RIGHT: alert description text
            // Figma: width ~168, font 14, w400, color #1A1C20
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
