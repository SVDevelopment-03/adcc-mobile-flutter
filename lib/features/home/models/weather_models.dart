import 'package:adcc/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class WeatherSnapshot {
  final String city;
  final double latitude;
  final double longitude;
  final double temperature;
  final double highTemperature;
  final double lowTemperature;
  final double uvIndex;
  final double windSpeed;
  final int weatherCode;
  final DateTime observedAt;

  const WeatherSnapshot({
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.highTemperature,
    required this.lowTemperature,
    required this.uvIndex,
    required this.windSpeed,
    required this.weatherCode,
    required this.observedAt,
  });

  factory WeatherSnapshot.fallback({String city = 'Abu Dhabi'}) {
    return WeatherSnapshot(
      city: city,
      latitude: 24.4539,
      longitude: 54.3773,
      temperature: 20,
      highTemperature: 28,
      lowTemperature: 21,
      uvIndex: 7.5,
      windSpeed: 22,
      weatherCode: 2,
      observedAt: DateTime.now(),
    );
  }

  int get roundedTemperature => temperature.round();

  int get roundedHighTemperature => highTemperature.round();

  int get roundedLowTemperature => lowTemperature.round();

  String get timeLabel => DateFormat('h:mm a').format(observedAt);

  String get weatherIconAsset => 'assets/icons/cloudy-waether.gif';

  String uvTitle(AppLocalizations l10n) => uvIndex >= 8
      ? l10n.uv_title_high
      : uvIndex >= 6
          ? l10n.uv_title_advisory
          : l10n.uv_title_update;

  String uvMessage(AppLocalizations l10n) =>
      l10n.uv_message(uvIndex.toStringAsFixed(1));

  String windTitle(AppLocalizations l10n) =>
      windSpeed >= 30 ? l10n.wind_title_advisory : l10n.wind_title_update;

  String windMessage(AppLocalizations l10n) =>
      l10n.wind_message(windSpeed.toStringAsFixed(0));
}
