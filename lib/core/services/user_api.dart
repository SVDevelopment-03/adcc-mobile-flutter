import 'package:dio/dio.dart';
import 'api_client.dart';
import '../constants/api_endpoints.dart';

class UserApi {
  UserApi._();

  static Future<Response<dynamic>> confirmPhoneChange(String newPhone, String oldCode, String newCode) async {
    final data = {
      'changeToken': oldCode, // legacy single-call used oldCode as token; keep compatibility if needed
      'newPhone': newPhone,
      'newCode': newCode,
    };
    return ApiClient.instance.post(ApiEndpoints.userPhoneChangeConfirm, data: data);
  }

  static Future<Response<dynamic>> startPhoneChange(String oldCode) async {
    final data = {'oldCode': oldCode};
    return ApiClient.instance.post('${ApiEndpoints.v1}/user/phone-change/start', data: data);
  }

  static Future<Response<dynamic>> confirmPhoneChangeWithToken(String changeToken, String newPhone, String newCode) async {
    final data = {'changeToken': changeToken, 'newPhone': newPhone, 'newCode': newCode};
    return ApiClient.instance.post(ApiEndpoints.userPhoneChangeConfirm, data: data);
  }
}
