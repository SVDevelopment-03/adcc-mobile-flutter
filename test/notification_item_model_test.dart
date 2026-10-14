import 'package:adcc/features/notifications/models/notification_item_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('incoming FCM notification is converted into an inbox item', () {
    const message = RemoteMessage(
      messageId: 'msg-1',
      notification: RemoteNotification(
        title: 'Community update',
        body: 'A new ride has been created',
      ),
      data: {
        'type': 'community',
        'communityId': 'comm-42',
      },
    );

    final item = NotificationItemModel.fromRemoteMessage(message);

    expect(item.title, 'Community update');
    expect(item.body, 'A new ride has been created');
    expect(item.type, 'community');
    expect(item.data?['communityId'], 'comm-42');
    expect(item.isRead, isFalse);
  });

  test('inbox item reads image and actions stored under data', () {
    final item = NotificationItemModel.fromJson({
      '_id': 'abc123',
      'title': 'Ride tomorrow',
      'body': 'Meet at 6am',
      'isRead': false,
      'createdAt': '2026-10-08T10:00:00.000Z',
      'data': {
        'image': 'https://example.com/ride.jpg',
        'actions': '[{"title":"View","action":"/events"}]',
      },
    });

    expect(item.imageUrl, 'https://example.com/ride.jpg');
    expect(item.actions, [
      {'title': 'View', 'action': '/events'},
    ]);
  });

  test('inbox item without data has no image or actions', () {
    final item = NotificationItemModel.fromJson({
      '_id': 'abc124',
      'title': 'Hello',
      'body': 'World',
    });

    expect(item.imageUrl, isEmpty);
    expect(item.actions, isEmpty);
  });
}
