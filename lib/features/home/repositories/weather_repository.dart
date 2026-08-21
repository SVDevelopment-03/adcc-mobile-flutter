import 'package:adcc/core/utils/response_parser.dart';
import 'package:adcc/features/home/models/weather_models.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:dio/dio.dart';

class WeatherRepository {
  final ProfileRepository _profileRepository;
  final Dio _geocodingClient;
  final Dio _weatherClient;

  WeatherRepository({ProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? ProfileRepository(),
        _geocodingClient = Dio(
          BaseOptions(baseUrl: 'https://geocoding-api.open-meteo.com'),
        ),
        _weatherClient = Dio(
          BaseOptions(baseUrl: 'https://api.open-meteo.com'),
        );

  Future<WeatherSnapshot?> fetchWeatherSnapshot() async {
    final profile = await _profileRepository.fetchProfile();
    final city = _normalizeCity(profile?.city);

    try {
      final coordinates = await _resolveCoordinates(city);
      final weather =
          await _fetchWeather(coordinates.latitude, coordinates.longitude);

      return WeatherSnapshot(
        city: city,
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
        temperature: weather.temperature,
        highTemperature: weather.highTemperature,
        lowTemperature: weather.lowTemperature,
        uvIndex: weather.uvIndex,
        windSpeed: weather.windSpeed,
        weatherCode: weather.weatherCode,
        observedAt: weather.observedAt,
      );
    } catch (_) {
      return null;
    }
  }

  String _normalizeCity(String? city) {
    final trimmed = city?.trim() ?? '';
    return trimmed.isEmpty ? 'Abu Dhabi' : trimmed;
  }

  Future<_Coordinates> _resolveCoordinates(String city) async {
    try {
      final response = await _geocodingClient.get<dynamic>(
        '/v1/search',
        queryParameters: {
          'name': city,
          'count': 1,
          'language': 'en',
          'format': 'json',
        },
      );

      final results = ResponseParser.extractList(
        response.data,
        const ['results'],
      );

      if (results.isNotEmpty && results.first is Map<String, dynamic>) {
        final first = results.first as Map<String, dynamic>;
        return _Coordinates(
          latitude:
              ResponseParser.asDouble(first['latitude'], fallback: 24.4539),
          longitude:
              ResponseParser.asDouble(first['longitude'], fallback: 54.3773),
        );
      }
    } catch (_) {
      // Use the fallback coordinates below.
    }

    return const _Coordinates(latitude: 24.4539, longitude: 54.3773);
  }

  Future<_WeatherPayload> _fetchWeather(
      double latitude, double longitude) async {
    final response = await _weatherClient.get<dynamic>(
      '/v1/forecast',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current': 'temperature_2m,weather_code,wind_speed_10m',
        'daily': 'temperature_2m_max,temperature_2m_min,uv_index_max',
        'timezone': 'Asia/Dubai',
        'forecast_days': 1,
      },
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Unexpected weather response');
    }

    final current = data['current'];
    final daily = data['daily'];

    if (current is! Map<String, dynamic> || daily is! Map<String, dynamic>) {
      throw const FormatException('Incomplete weather response');
    }

    return _WeatherPayload(
      temperature: ResponseParser.asDouble(current['temperature_2m']),
      weatherCode: ResponseParser.asInt(current['weather_code']),
      windSpeed: ResponseParser.asDouble(current['wind_speed_10m']),
      highTemperature: _firstDouble(daily['temperature_2m_max'], fallback: 28),
      lowTemperature: _firstDouble(daily['temperature_2m_min'], fallback: 21),
      uvIndex: _firstDouble(daily['uv_index_max'], fallback: 7.5),
      observedAt: DateTime.tryParse(
            ResponseParser.asString(current['time']),
          ) ??
          DateTime.now(),
    );
  }

  double _firstDouble(dynamic value, {double fallback = 0}) {
    if (value is List && value.isNotEmpty) {
      return ResponseParser.asDouble(value.first, fallback: fallback);
    }

    return ResponseParser.asDouble(value, fallback: fallback);
  }
}

class _Coordinates {
  final double latitude;
  final double longitude;

  const _Coordinates({required this.latitude, required this.longitude});
}

class _WeatherPayload {
  final double temperature;
  final double highTemperature;
  final double lowTemperature;
  final double uvIndex;
  final double windSpeed;
  final int weatherCode;
  final DateTime observedAt;

  const _WeatherPayload({
    required this.temperature,
    required this.highTemperature,
    required this.lowTemperature,
    required this.uvIndex,
    required this.windSpeed,
    required this.weatherCode,
    required this.observedAt,
  });
}
