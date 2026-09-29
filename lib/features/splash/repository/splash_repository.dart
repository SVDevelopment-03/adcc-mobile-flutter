import 'package:dio/dio.dart';

import '../../../core/services/api_client.dart';

class SplashRepository {
  final Dio _dio;

  SplashRepository({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  static Map<String, dynamic>? parseSplashResponse(dynamic data) {
    if (data is! Map) return null;

    final source = data['data'] is Map ? data['data'] : data;
    final payload = Map<String, dynamic>.from(source as Map);
    final rawUrl = payload['url'] ?? payload['image'];
    final url = rawUrl?.toString();
    if (url == null || url.isEmpty) return null;

    final rawType = (payload['type'] ?? 'image').toString().toLowerCase();
    final isVideo = rawType == 'video' || payload['video'] == true;
    final normalizedType = isVideo ? 'video' : 'image';

    final rawDuration = payload['duration'];
    int? duration;
    if (rawDuration is num) {
      duration = rawDuration.toInt();
    } else if (rawDuration is String) {
      duration = int.tryParse(rawDuration);
    }
    if (duration != null && duration <= 0) duration = null;

    final result = <String, dynamic>{
      'url': url,
      'type': normalizedType,
    };
    if (normalizedType != 'video' && duration != null) {
      result['duration'] = duration;
    }
    return result;
  }

  /// Expected response shape:
  /// { success: true, data: { "url": "https://...", "type": "video"|"image", "duration": 3 } }
  Future<Map<String, dynamic>?> fetchSplash() async {
    try {
      final resp = await _dio.get('/v1/splash', options: Options(responseType: ResponseType.json));
      if (resp.statusCode == 200) {
        return parseSplashResponse(resp.data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
