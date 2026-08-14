import 'package:adcc/features/feed_posts/repositories/feed_posts_repository.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/features/ride_feed/view/ride_feed_screen.dart';
import 'package:adcc/features/store/view/Screen/store_screen.dart';
import 'package:adcc/shared/widgets/community_update_card.dart';
import 'package:flutter/material.dart';
import 'package:adcc/l10n/app_localizations.dart';

class CommunityUpdatesSection extends StatefulWidget {
  final List<HomeFeedPostModel> updates;
  final bool showFallback;
  final bool fromGuest;
  final VoidCallback? onGuestRestrictedTap;

  const CommunityUpdatesSection({
    super.key,
    this.updates = const [],
    this.showFallback = false,
    this.fromGuest = false,
    this.onGuestRestrictedTap,
  });

  @override
  State<CommunityUpdatesSection> createState() =>
      _CommunityUpdatesSectionState();
}

class _CommunityUpdatesSectionState extends State<CommunityUpdatesSection> {
  late List<HomeFeedPostModel> _updates;
  final FeedPostsRepository _feedRepository = FeedPostsRepository();
  int _currentIndex = 0;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  bool _showLikeBadge = false;

  @override
  void initState() {
    super.initState();
    _updates = List<HomeFeedPostModel>.from(widget.updates);
  }

  @override
  void didUpdateWidget(covariant CommunityUpdatesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.updates, widget.updates)) {
      _updates = List<HomeFeedPostModel>.from(widget.updates);
      if (_currentIndex >= _updates.length) {
        _currentIndex = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _updates;
    if (data.isEmpty) return const SizedBox.shrink();

    if (_currentIndex >= data.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 520,
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.noMorePosts,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    final remaining = data.length - _currentIndex;
    final visibleCount = remaining.clamp(0, 3);

    final cards = List.generate(visibleCount, (i) {
      final item = data[_currentIndex + i];
      final isTop = i == 0;
      return Positioned(
        top: i * 16.0,
        left: i * 12.0,
        right: i * 12.0,
        child: isTop
            ? _buildDraggableCard(context, item)
            : _buildStackedCard(item, i),
      );
    }).reversed.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.recentlyPosted,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  letterSpacing: 0,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const StoreScreen(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.viewAll,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: Color(0xFF555555),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.swipeBrowsePosts,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 540,
            child: Stack(
              clipBehavior: Clip.none,
              children: cards,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStackedCard(HomeFeedPostModel item, int position) {
    final scale = 1.0 - (position * 0.04);
    return Transform.scale(
      scale: scale,
      child: CommunityUpdateCard(
        profileImage: item.profileImage,
        name: item.name,
        locationTime: item.locationTime,
        postImage: item.postImage,
        likes: item.likes,
        commentsCount: item.commentsCount,
        likedByMe: item.likedByMe,
        caption: item.caption,
        onLikeTap: () => _toggleLike(_currentIndex + position),
        onTap: () => _openFeedDetail(context, item.id),
      ),
    );
  }

  Widget _buildDraggableCard(BuildContext context, HomeFeedPostModel item) {
    return GestureDetector(
      onTap: () => _openFeedDetail(context, item.id),
      onPanStart: (_) {
        setState(() {
          _isDragging = true;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _dragOffset += details.delta;
          _showLikeBadge = _dragOffset.dx > 0;
        });
      },
      onPanEnd: (_) {
        _handleSwipeEnd();
      },
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: _dragOffset.dx / 400,
          child: Stack(
            children: [
              CommunityUpdateCard(
                profileImage: item.profileImage,
                name: item.name,
                locationTime: item.locationTime,
                postImage: item.postImage,
                likes: item.likes,
                commentsCount: item.commentsCount,
                likedByMe: item.likedByMe,
                caption: item.caption,
                onLikeTap: () => _toggleLike(_currentIndex),
              ),
              if (_isDragging) _buildSwipeBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleLike(int index) async {
    if (index < 0 || index >= _updates.length) return;

    if (widget.fromGuest) {
      widget.onGuestRestrictedTap?.call();
      return;
    }

    final currentItem = _updates[index];
    final updated = await _feedRepository.toggleLike(currentItem.id);
    if (updated == null) return;

    setState(() {
      _updates[index] = currentItem.copyWith(
        likes: updated.likesCount,
        commentsCount: updated.commentsCount,
        likedByMe: updated.likedByMe,
      );
    });
  }

  Widget _buildSwipeBadge() {
    final badgeText = _showLikeBadge
        ? AppLocalizations.of(context)!.like
        : AppLocalizations.of(context)!.nope;
    final badgeColor =
        _showLikeBadge ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    return Positioned(
      top: 32,
      left: _showLikeBadge ? 24 : null,
      right: _showLikeBadge ? null : 24,
      child: Transform.rotate(
        angle: _showLikeBadge ? -0.35 : 0.35,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badgeText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  void _openFeedDetail(BuildContext context, String postId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FeedDetailScreen(
          postId: postId,
          isGuest: widget.fromGuest,
          onLoginRequired: widget.onGuestRestrictedTap ?? () {},
        ),
      ),
    );
  }

  void _handleSwipeEnd() {
    const threshold = 120;
    if (_dragOffset.dx.abs() > threshold) {
      setState(() {
        _currentIndex = (_currentIndex + 1).clamp(0, _currentIndex + 1);
        _dragOffset = Offset.zero;
        _isDragging = false;
        _showLikeBadge = false;
      });
    } else {
      setState(() {
        _dragOffset = Offset.zero;
        _isDragging = false;
        _showLikeBadge = false;
      });
    }
  }
}
