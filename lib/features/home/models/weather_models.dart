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

  String get weatherIconAsset => 'assets/images/weather_cloud.png';

  String get uvTitle => uvIndex >= 8
      ? 'High UV Alert'
      : uvIndex >= 6
          ? 'UV Advisory'
          : 'UV Update';

  String get uvMessage =>
      'UV index is ${uvIndex.toStringAsFixed(1)} today. Avoid midday rides, bring water and sunscreen.';

  String get windTitle => windSpeed >= 30 ? 'Wind Advisory' : 'Wind Update';

  String get windMessage =>
      'Wind speed is ${windSpeed.toStringAsFixed(0)} km/h right now. Ride with caution.';
}