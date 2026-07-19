import 'dart:io';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/utils/response_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ProfileService {
  final ApiClient _api = ApiClient.instance;

  void _logResponse(String label, Response response) {
    debugPrint('[$label] status=${response.statusCode}');
    debugPrint('[$label] data=${response.data}');
  }

  void _logDioException(String label, DioException error) {
    debugPrint('[$label] DioException type=${error.type}');
    debugPrint('[$label] status=${error.response?.statusCode}');
    debugPrint('[$label] response=${error.response?.data}');
    debugPrint('[$label] message=${error.message}');
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _api.patch(
        ApiEndpoints.authMe,
        data: data,
      );
      _logResponse('updateProfile', response);
      return response;
    } on DioException catch (error) {
      _logDioException('updateProfile', error);
      rethrow;
    }
  }

  Future<Response> updateProfileImageUrl(String url) async {
    try {
      final response = await _api.patch(
        '${ApiEndpoints.authMe}/profile-image',
        data: {'profileImage': url},
      );
      _logResponse('updateProfileImageUrl', response);
      return response;
    } on DioException catch (error) {
      _logDioException('updateProfileImageUrl', error);
      rethrow;
    }
  }

  Future<List<String>> fetchAvailableCities() async {
    try {
      final response = await _api.get<dynamic>(ApiEndpoints.communityMetadataCities);
      final cities = ResponseParser.extractList(response.data, const ['cities', 'data']);
      final parsed = cities
          .map((city) => ResponseParser.asString(city))
          .where((city) => city.isNotEmpty)
          .toList();

      if (parsed.isNotEmpty) {
        return parsed;
      }
    } catch (_) {
      // Fall through to the static fallback list below.
    }

    return const [
      'Abu Dhabi',
      'Dubai',
      'Sharjah',
      'Ajman',
      'Ras Al Khaimah',
      'Fujairah',
      'Umm Al Quwain',
      'Al Ain',
      'Riyadh',
      'Jeddah',
      'Mecca',
      'Medina',
      'Dammam',
      'Khobar',
      'Dhahran',
      'Taif',
      'Tabuk',
      'Abha',
      'Jubail',
      'Yanbu',
      'Doha',
      'Al Wakrah',
      'Al Khor',
      'Al Rayyan',
      'Mesaieed',
      'Dukhan',
      'Muscat',
      'Salalah',
      'Sohar',
      'Nizwa',
      'Sur',
      'Ibri',
      'Barka',
      'Rustaq',
      'Kuwait City',
      'Hawalli',
      'Salmiya',
      'Farwaniya',
      'Jahra',
      'Ahmadi',
      'Mangaf',
      'Fahaheel',
      'Manama',
      'Muharraq',
      'Riffa',
      'Hamad Town',
      'Isa Town',
      'Sitra',
      'Budaiya',
      'Jidhafs',
    ];
  }

  Future<Response> uploadImageFile(File file, {String folder = 'members-profile'}) async {
    final fileName = file.path.split('/').last;
    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(file.path, filename: fileName),
      'folder': folder,
    });

    try {
      final response = await _api.post(
        '/v1/uploads/image',
        data: form,
      );
      _logResponse('uploadImageFile', response);
      return response;
    } on DioException catch (error) {
      _logDioException('uploadImageFile', error);
      rethrow;
    }
  }
}
