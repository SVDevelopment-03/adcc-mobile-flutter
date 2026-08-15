import 'package:adcc/shared/widgets/community_update_card.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/features/community_posts/models/community_post_model.dart';
import 'package:adcc/features/community_posts/repositories/community_posts_repository.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CommunityUpdatesTab extends StatefulWidget {
  final String? communityId;

  const CommunityUpdatesTab({super.key, this.communityId});

  @override
  State<CommunityUpdatesTab> createState() => _CommunityUpdatesTabState();
}

class _CommunityUpdatesTabState extends State<CommunityUpdatesTab> {
  late final CommunityPostsRepository _repository;
  late Future<List<CommunityPostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _repository = CommunityPostsRepository(apiClient: ApiClient.instance);
    _postsFuture = _loadPosts();
  }

  Future<List<CommunityPostModel>> _loadPosts() async {
    final communityId = widget.communityId?.trim() ?? '';
    if (communityId.isEmpty) return const [];
    return _repository.fetchPosts(communityId: communityId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommunityPostModel>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 430,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final posts = snapshot.data ?? const <CommunityPostModel>[];

        if (posts.isEmpty) {
          return SizedBox(
            height: 430,
            child: Center(
              child: Text(AppLocalizations.of(context)!.community_no_updates),
            ),
          );
        }

        return SizedBox(
          height: 430,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (context, index) {
              final post = posts[index];
              return CommunityUpdateCard(
                profileImage: 'assets/images/profile_sara.png',
                name: post.createdByName?.isNotEmpty == true
                    ? post.createdByName!
                    : (post.title.isEmpty ? 'Community Update' : post.title),
                locationTime:
                    post.status.isNotEmpty ? post.status : 'Community',
                postImage: post.image,
                likes: 0,
                caption: post.description.isEmpty
                    ? 'No caption available.'
                    : post.description,
              );
            },
          ),
        );
      },
    );
  }
}
