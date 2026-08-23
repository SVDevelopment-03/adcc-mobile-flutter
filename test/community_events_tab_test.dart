import 'package:adcc/core/services/api_response.dart';
import 'package:adcc/features/communities/sections/Community%20Details/community_events_tab.dart';
import 'package:adcc/features/events/Model/model_events.dart';
import 'package:adcc/features/events/services/events_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeEventsService extends EventsService {
  Map<String, dynamic>? lastQueryParameters;

  @override
  Future<ApiResponse<List<Event>>> getEvents({
    Map<String, dynamic>? queryParameters,
  }) async {
    lastQueryParameters = queryParameters;
    return ApiResponse.success(
      data: [
        Event(
          id: 'event-1',
          title: 'Sunrise Community Ride',
        ),
      ],
      statusCode: 200,
    );
  }
}

void main() {
  test('event model extracts IDs from nested track/community objects', () {
    final event = Event.fromJson({
      '_id': 'evt-123',
      'title': 'Sunrise Ride',
      'communityId': {'_id': 'community-456', 'title': 'City Riders'},
      'trackId': {'_id': 'track-789', 'title': 'Al Ain Loop'},
    });

    expect(event.communityId, 'community-456');
    expect(event.trackId, 'track-789');
  });

  testWidgets('community events tab loads using communityId when present', (tester) async {
    final fakeService = FakeEventsService();

    await tester.pumpWidget(
      MaterialApp(
        home: CommunityEventsTab(
          communityId: 'community-123',
          eventsService: fakeService,
        ),
      ),
    );

    await tester.pump();

    expect(fakeService.lastQueryParameters, {
      'communityId': 'community-123',
      'status': 'Upcoming',
      'limit': 20,
    });
    expect(find.text('Sunrise Community Ride'), findsOneWidget);
  });
}
