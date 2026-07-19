import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/api_exception.dart';
import 'package:adcc/features/communities/models/community_model.dart';
import 'package:adcc/features/routes/Models/event_model.dart';
import 'package:adcc/features/routes/Models/track_model.dart';
import 'package:dio/dio.dart';

class TracksService {
  final Dio _dio = ApiClient.instance.dio;

 Future<List<TrackModel>> getAllTracks() async {
  try {
  

   final response = await ApiClient.instance.get(ApiEndpoints.tracks);

 

    final body = response.data;

    if (body is Map<String, dynamic>) {


      final data = body["data"];
  

      if (data is Map<String, dynamic>) {
        final tracksList = data["tracks"];
   

        if (tracksList is List) {
       

          final tracks = tracksList
              .map((e) {
                print("Parsing Track: $e");
                return TrackModel.fromJson(e as Map<String, dynamic>);
              })
              .toList();

        

          return tracks;
        } else {
        
        }
      } else {
      
      }
    } else {
     
    }

    return [];
  } on DioException catch (e) {
 

    throw ApiException.fromDioException(e);
  } catch (e) {


    throw ApiException(
      message: "Something went wrong while fetching tracks.",
    );
  }
}

    Future<TrackModel?> getTrackById(String trackId) async {
  try {
    final response =
        await _dio.get(ApiEndpoints.trackById(trackId));

    final body = response.data;

    if (body is Map<String, dynamic>) {
      final success = body["success"] ?? false;
      final data = body["data"];

      if (success && data is Map<String, dynamic>) {
        return TrackModel.fromJson(data);
      }
    }

    return null;
  } on DioException catch (e) {
    throw ApiException.fromDioException(e);
  } catch (e) {
    throw ApiException(
      message: "Something went wrong while fetching track details.",
    );
  }
}

  Future<List<EventModel>> getTrackRelatedEvents(String trackId) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.trackRelatedEvents(trackId));

      final body = response.data;

      if (body is Map<String, dynamic>) {
        final success = body["success"] ?? false;
        final data = body["data"];

        if (success && data is List) {
          return data
              .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      return [];
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(
        message:
            "Something went wrong while fetching track events.",
      );
    }
  }

  Future<List<CommunityModel>> getTrackRelatedCommunities(
      String trackId) async {
    try {
      final url =
          '${ApiEndpoints.tracks}/$trackId/communities/results';

      final response = await _dio.get(url);
      final body = response.data;

      if (body is Map<String, dynamic>) {
        final success = body["success"] ?? false;
        final data = body["data"];

        if (success && data is List) {
          final communities = data
              .map((e) =>
                  CommunityModel.fromJson(e as Map<String, dynamic>))
              .toList();

          return communities;
        }
      }

      return [];
    } on DioException catch (e) {
      return [];
    } catch (e) {
      return [];
    }
  }
}