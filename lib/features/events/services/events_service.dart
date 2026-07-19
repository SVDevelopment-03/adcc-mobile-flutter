import 'package:adcc/features/events/Model/model_events.dart';
import 'package:dio/dio.dart';

import '../../../core/services/api_client.dart';
import '../../../core/services/api_exception.dart';
import '../../../core/services/api_response.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/token_storage_service.dart';
import '../../../core/utils/response_parser.dart';

class EventsService {
  final _apiClient = ApiClient.instance;

  Future<ApiResponse<List<Event>>> getEvents({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.events,
        queryParameters: queryParameters,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        try {
          final eventsData = ResponseParser.extractList(
            response.data,
            const ['events', 'items', 'results'],
          );

          final events = eventsData
              .map((json) {
                try {
                  return Event.fromJson(json as Map<String, dynamic>);
                } catch (_) {
                  return null;
                }
              })
              .whereType<Event>()
              .toList();

          if (events.isEmpty) {
            return ApiResponse.error(
              message: 'No events parsed from response',
              statusCode: response.statusCode,
            );
          }

          return ApiResponse.success(
            data: events,
            statusCode: response.statusCode,
          );
        } catch (e) {
          return ApiResponse.error(
            message: 'Failed to parse events data: $e',
            statusCode: response.statusCode,
          );
        }
      }

      return ApiResponse.error(
        message: 'Failed to fetch events',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<ApiResponse<dynamic>> joinEvent({
    required String eventId,
  }) async {
    try {
      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.joinEvent(eventId),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data["success"] == true) {
        return ApiResponse.success(
          data: response.data,
          statusCode: response.statusCode,
          message: response.data["message"] ?? "Registered successfully",
        );
      }

      return ApiResponse.error(
        message: response.data?["message"] ?? "Failed to register",
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: "Unexpected error: $e");
    }
  }

  Future<ApiResponse<String>> addEventToCalendar({
    required Event event,
  }) async {
    try {
      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.addToCalendar(event.id),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final data = response.data;
        final googleCalendarUrl = data is Map<String, dynamic>
            ? (data['data'] is Map<String, dynamic>
                ? (data['data'] as Map<String, dynamic>)['googleCalendarUrl']?.toString()
                : data['googleCalendarUrl']?.toString())
            : null;

        if (googleCalendarUrl != null && googleCalendarUrl.isNotEmpty) {
          return ApiResponse.success(
            data: googleCalendarUrl,
            statusCode: response.statusCode,
            message: data is Map<String, dynamic>
                ? data['message']?.toString()
                : 'Calendar link generated',
          );
        }
      }

      return ApiResponse.success(
        data: _buildGoogleCalendarUrl(event),
        message: 'Calendar link generated locally',
      );
    } on DioException catch (e) {
      return ApiResponse.success(
        data: _buildGoogleCalendarUrl(event),
        message: ApiException.fromDioException(e).toString(),
      );
    } catch (e) {
      return ApiResponse.success(
        data: _buildGoogleCalendarUrl(event),
        message: 'Calendar link generated locally',
      );
    }
  }

  String _buildGoogleCalendarUrl(Event event) {
    final start = _parseEventStart(event);
    final end = start.add(const Duration(hours: 2));
    final title = Uri.encodeComponent(event.title);
    final details = Uri.encodeComponent(event.description ?? '');

    return 'https://www.google.com/calendar/render?action=TEMPLATE&text=$title&dates=${_formatCalendarStamp(start)}/${_formatCalendarStamp(end)}&details=$details';
  }

  DateTime _parseEventStart(Event event) {
    final rawDate = event.eventDate?.trim();
    final rawTime = event.eventTime?.trim();

    DateTime? baseDate;
    if (rawDate != null && rawDate.isNotEmpty) {
      baseDate = DateTime.tryParse(rawDate);
    }

    baseDate ??= DateTime.now();

    if (rawTime != null && rawTime.isNotEmpty) {
      final parts = rawTime.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          return DateTime(
            baseDate.year,
            baseDate.month,
            baseDate.day,
            hour,
            minute,
          );
        }
      }
    }

    return DateTime(baseDate.year, baseDate.month, baseDate.day, 9, 0);
  }

  String _formatCalendarStamp(DateTime dateTime) {
    final utc = dateTime.toUtc();
    return '${utc.year.toString().padLeft(4, '0')}${utc.month.toString().padLeft(2, '0')}${utc.day.toString().padLeft(2, '0')}T${utc.hour.toString().padLeft(2, '0')}${utc.minute.toString().padLeft(2, '0')}${utc.second.toString().padLeft(2, '0')}Z';
  }

  Future<ApiResponse<dynamic>> cancelEvent({
    required String eventId,
    required String reason,
  }) async {
    try {
      String? userId = await TokenStorageService.getUserId();
      userId ??= "69959a9430e2025c6208df05";

      final body = {
        "eventId": eventId,
        "userId": userId,
        "status": "cancelled",
        "reason": reason,
      };

      final response = await _apiClient.post<dynamic>(
        ApiEndpoints.cancelEvent(eventId),
        data: body,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data["success"] == true) {
        return ApiResponse.success(
          data: response.data,
          statusCode: response.statusCode,
          message: response.data["message"] ?? "Registration cancelled",
        );
      }

      return ApiResponse.error(
        message: response.data?["message"] ?? "Failed to cancel registration",
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: "Unexpected error: $e");
    }
  }

  Future<ApiResponse<Event>> getEventById(String eventId) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.eventById(eventId),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data["success"] == true) {
        final data = response.data["data"];

        if (data is Map<String, dynamic>) {
          final event = Event.fromJson(data);

          return ApiResponse.success(
            data: event,
            statusCode: response.statusCode,
          );
        } else {
          return ApiResponse.error(
            message: "Invalid event format",
            statusCode: response.statusCode,
          );
        }
      }

      return ApiResponse.error(
        message: response.data?["message"] ?? "Failed to fetch event",
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: "Unexpected error: $e",
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getCompletedEventSummary({
    required String eventId,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        '${ApiEndpoints.events}/$eventId/completed-summary',
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final summary = ResponseParser.extractMap(
              response.data,
              const ['summary', 'data'],
            ) ??
            (response.data is Map<String, dynamic>
                ? Map<String, dynamic>.from(response.data as Map)
                : <String, dynamic>{});

        return ApiResponse.success(
          data: summary,
          statusCode: response.statusCode,
          message: response.data is Map<String, dynamic>
              ? response.data['message']?.toString()
              : null,
        );
      }

      return ApiResponse.error(
        message: response.data?['message'] ?? 'Failed to fetch completed summary',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: 'Unexpected error: $e');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getCompletedEventLeaderboard({
    required String eventId,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.eventResults(eventId),
        queryParameters: const {'status': 'completed'},
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final rows = ResponseParser.extractList(
          response.data,
          const ['results', 'items', 'participants'],
        );

        final leaderboard = rows
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        return ApiResponse.success(
          data: leaderboard,
          statusCode: response.statusCode,
          message: response.data is Map<String, dynamic>
              ? response.data['message']?.toString()
              : null,
        );
      }

      return ApiResponse.error(
        message: response.data?['message'] ?? 'Failed to fetch leaderboard',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: 'Unexpected error: $e');
    }
  }

  Future<ApiResponse<bool>> getMemberStatus({
    required String eventId,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.memberStatus(eventId),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null &&
          response.data["success"] == true) {
        final data = response.data["data"];
        final status = data?["status"]?.toString();

        return ApiResponse.success(
          data: status == "joined",
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.error(
        message: response.data?["message"] ?? "Failed to get member status",
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: "Unexpected error: $e",
      );
    }
  }

  Future<ApiResponse<dynamic>> getEventResults({
    required String eventId,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.eventResults(eventId),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        return ApiResponse.success(
          data: response.data,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.error(
        message: response.data?['message'] ?? 'Failed to fetch event results',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioException(e);
      return ApiResponse.error(
        message: apiException.toString(),
        statusCode: apiException.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: 'Unexpected error: $e');
    }
  }
}
