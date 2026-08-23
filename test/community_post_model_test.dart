import 'package:adcc/features/community_posts/models/community_post_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CommunityPostModel reads backend community post fields', () {
    final post = CommunityPostModel.fromJson({
      '_id': 'abc123',
      'title': 'Weekend ride update',
      'caption': 'Meet at the marina at 7am.',
      'postType': 'Announcement',
      'createdBy': {
        'fullName': 'Sara Ali',
      },
      'image': 'https://example.com/update.jpg',
    });

    expect(post.id, 'abc123');
    expect(post.title, 'Weekend ride update');
    expect(post.description, 'Meet at the marina at 7am.');
    expect(post.status, 'Announcement');
    expect(post.createdByName, 'Sara Ali');
    expect(post.image, 'https://example.com/update.jpg');
  });
}
