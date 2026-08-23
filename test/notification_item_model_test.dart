import 'package:adcc/features/notifications/models/notification_item_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('incoming FCM notification is converted into an inbox item', () {
    final message = RemoteMessage(
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
}
