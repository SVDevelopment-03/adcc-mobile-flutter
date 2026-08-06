import 'dart:io';

import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/feed_posts/models/feed_post_model.dart';
import 'package:adcc/features/feed_posts/repositories/feed_posts_repository.dart';
import 'package:adcc/features/home/models/home_models.dart';
import 'package:adcc/features/home/repositories/home_repository.dart';
import 'package:adcc/shared/widgets/adaptive_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';

import '../../../core/services/permission_service.dart';
import '../../auth/view/registrationScreen/create_account.dart';

class RideFeedScreen extends StatefulWidget {
  const RideFeedScreen({super.key});

  @override
  State<RideFeedScreen> createState() => _RideFeedScreenState();
}

class _RideFeedScreenState extends State<RideFeedScreen> {
  final FeedPostsRepository _repository = FeedPostsRepository();
  late Future<List<FeedPostModel>> _postsFuture;
  bool _isGuest = true;

  @override
  void initState() {
    super.initState();
    _postsFuture = _repository.fetchPosts(queryParameters: {
      'status': 'approved',
      'limit': 20,
      'page': 1,
    });
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final isGuest = await TokenStorageService.isGuestUser();
    final token = await TokenStorageService.getAccessToken();
    if (!mounted) return;
    setState(() {
      _isGuest = isGuest || token == null || token.isEmpty;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _postsFuture = _repository.fetchPosts(queryParameters: {
        'status': 'approved',
        'limit': 20,
        'page': 1,
      });
    });
    await _postsFuture;
  }

  void _showLoginPrompt() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login required',
            style: TextStyle(fontFamily: 'Outfit')),
        content: const Text('Please login to post or like feed updates.',
            style: TextStyle(fontFamily: 'Outfit')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'Outfit')),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
              );
            },
            child: const Text('Login', style: TextStyle(fontFamily: 'Outfit')),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreatePost() async {
    if (_isGuest) {
      _showLoginPrompt();
      return;
    }

    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CreateFeedPostScreen()),
    );

    if (created == true) {
      await _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFEFF4),
        body: RefreshIndicator(
          onRefresh: _refresh,
          displacement: topPad + 20,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            slivers: [
              // Unified Header & Button (Guarantees Hit-Testing)
              SliverToBoxAdapter(
                child: Container(
                  height:
                      250 + topPad, // Explicit height covering header + button
                  child: Stack(
                    children: [
                      // Red Header
                      Container(
                        height: 210 + topPad,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                rideFeedImgs.rideFeedheaderbackground),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Color(0xFF435974),
                              BlendMode
                                  .dstOver, // or multiply, overlay, modulate, etc.
                            ),
                          ),

                          // borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.only(top: topPad + 40),
                        child: const Column(
                          children: [
                            Text(
                              'Ride Feed',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 18),
                            Text(
                              'Join the Abu Dhabi Cycling Community!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Back Button
                      Positioned(
                        left: 8,
                        top: topPad + 30,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),

                      // Floating Post Button (Now logically inside the Stack bounds)
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 0,
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                debugPrint('[RideFeed] Post Your Ride Clicked');
                                _openCreatePost();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC35178),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Post Your Ride',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Posts List
              FutureBuilder<List<FeedPostModel>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final posts = snapshot.data ?? const [];
                  if (posts.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyFeed(),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 25, 16, 100),
                    sliver: SliverList.separated(
                      itemCount: posts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        return FeedPostCard(
                          post: posts[index],
                          isGuest: _isGuest,
                          onLoginRequired: _showLoginPrompt,
                          onChanged: _refresh,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedPostCard extends StatelessWidget {
  final FeedPostModel post;
  final bool isGuest;
  final VoidCallback onLoginRequired;
  final VoidCallback onChanged;

  const FeedPostCard({
    super.key,
    required this.post,
    required this.isGuest,
    required this.onLoginRequired,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FeedDetailScreen(
              postId: post.id,
              isGuest: isGuest,
              onLoginRequired: onLoginRequired,
            ),
          ),
        );
        onChanged();
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFD7E4),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.fromLTRB(12, 13, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostHeader(post: post),
            if (post.image.isNotEmpty) ...[
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 245,
                  width: double.infinity,
                  child: AdaptiveImage(
                    imagePath: post.image,
                    fit: BoxFit.cover,
                    errorWidget: const _ImageFallback(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                LikeButton(
                  size: 22,
                  isLiked: post.likedByMe,
                  likeBuilder: (isLiked) => Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked
                        ? const Color(0xFFC35178)
                        : const Color(0xFF3C3C3B),
                    size: 21,
                  ),
                  onTap: (isLiked) async {
                    if (isGuest) {
                      onLoginRequired();
                      return isLiked;
                    }
                    final updated =
                        await FeedPostsRepository().toggleLike(post.id);
                    return updated?.likedByMe ?? isLiked;
                  },
                ),
                const SizedBox(width: 4),
                IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints:
                      const BoxConstraints.tightFor(width: 30, height: 30),
                  onPressed: () {}, // Handled by card tap
                  icon: const Icon(Icons.chat_bubble_outline,
                      color: Color(0xFF3C3C3B), size: 20),
                ),
                Text('${post.commentsCount}',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF121E3F),
                    )),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${post.likesCount} likes',
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF121E3F),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              post.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.35,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  final FeedPostModel post;
  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 21,
          backgroundColor: AppColors.goldenOchre,
          child: ClipOval(
            child: post.authorAvatar.isEmpty
                ? const Icon(Icons.person, color: Colors.white)
                : AdaptiveImage(
                    imagePath: post.authorAvatar,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                    errorWidget: const Icon(Icons.person, color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3C3C3B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _timeAgo(post.createdAt),
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11.5,
                  color: Color(0xFF555555),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FeedDetailScreen extends StatefulWidget {
  final String postId;
  final bool isGuest;
  final VoidCallback onLoginRequired;

  const FeedDetailScreen({
    super.key,
    required this.postId,
    required this.isGuest,
    required this.onLoginRequired,
  });

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  final FeedPostsRepository _repository = FeedPostsRepository();
  final TextEditingController _commentController = TextEditingController();
  late Future<FeedPostModel?> _postFuture;
  FeedPostModel? _post;
  bool _commenting = false;

  @override
  void initState() {
    super.initState();
    _postFuture = _loadPost();
  }

  Future<FeedPostModel?> _loadPost() async {
    final post = await _repository.fetchPostById(widget.postId);
    if (!mounted) return post;
    setState(() => _post = post);
    return post;
  }

  Future<bool> _toggleLike(bool isLiked) async {
    if (widget.isGuest) {
      widget.onLoginRequired();
      return isLiked;
    }
    final post = _post;
    if (post == null) return isLiked;

    final updated = await _repository.toggleLike(post.id);
    if (!mounted || updated == null) return isLiked;

    setState(() => _post = updated);
    return updated.likedByMe;
  }

  Future<void> _addComment() async {
    if (widget.isGuest) {
      widget.onLoginRequired();
      return;
    }
    final text = _commentController.text.trim();
    if (text.isEmpty || _post == null || _commenting) return;

    setState(() => _commenting = true);
    final updated = await _repository.addComment(postId: _post!.id, text: text);
    if (!mounted) return;
    setState(() {
      _commenting = false;
      if (updated != null) {
        _post = updated;
        _commentController.clear();
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFEFF4),
        body: SafeArea(
          child: FutureBuilder<FeedPostModel?>(
            future: _postFuture,
            builder: (context, snapshot) {
              final post = _post ?? snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting &&
                  post == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (post == null) {
                return const Center(
                  child: Text(
                    'Post not found',
                    style: TextStyle(fontFamily: 'Outfit'),
                  ),
                );
              }

              final title =
                  post.title.trim().isNotEmpty && post.title != 'Feed Post'
                      ? post.title
                      : 'SheRides Weekend Success!';

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                children: [
                  _SubHeader(
                    title: 'Back to Feed',
                    titleColor: const Color(0xFFC35178),
                    iconColor: const Color(0xFFC35178),
                    onBack: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 34),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 358 / 414,
                      child: post.image.isEmpty
                          ? const _ImageFallback()
                          : AdaptiveImage(
                              imagePath: post.image,
                              fit: BoxFit.cover,
                              errorWidget: const _ImageFallback(),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD5E4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Club Update',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFC35178),
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    post.description,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.22,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    _timeAgo(post.createdAt),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFFFD5E4)),
                  SizedBox(
                    height: 52,
                    child: Row(
                      children: [
                        LikeButton(
                          size: 23,
                          isLiked: post.likedByMe,
                          likeBuilder: (isLiked) => Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked
                                ? const Color(0xFFC35178)
                                : const Color(0xFF555555),
                            size: 23,
                          ),
                          onTap: _toggleLike,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          '${post.likesCount}',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            color: Color(0xFF555555),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(
                          Icons.chat_bubble_outline,
                          size: 22,
                          color: Color(0xFF555555),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${post.commentsCount}',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            color: Color(0xFF555555),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share_outlined,
                            size: 23,
                            color: Color(0xFF555555),
                          ),
                        ),
                        if (post.isAuthor == true)
                          TextButton.icon(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFC35178),
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(56, 36),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.edit_outlined,
                                size: 22, color: Color(0xFFC35178)),
                            label: const Text(
                              'Edit',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFC35178),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFFFD5E4)),
                  const SizedBox(height: 29),
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (post.comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Text(
                        'No comments yet.',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFF555555),
                        ),
                      ),
                    )
                  else
                    ...post.comments.map((c) => _CommentTile(comment: c)),
                  const SizedBox(height: 16),
                  _CommentComposer(
                    controller: _commentController,
                    enabled: !widget.isGuest,
                    submitting: _commenting,
                    onSubmit: _addComment,
                    onLoginRequired: widget.onLoginRequired,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class LocationSelection {
  final String label;
  final LatLng position;

  LocationSelection({required this.label, required this.position});
}

class LocationPickerScreen extends StatefulWidget {
  final LatLng? previousSelection;
  final String? previousLabel;

  const LocationPickerScreen({
    super.key,
    this.previousSelection,
    this.previousLabel,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const LatLng _defaultCenter = LatLng(24.4539, 54.3773);
  LatLng? _selectedLatLng;
  String? _locationLabel;
  LatLng _cameraTarget = _defaultCenter;
  bool _loading = true;
  bool _permissionDenied = false;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _prepareInitialLocation();
  }

  Future<void> _prepareInitialLocation() async {
    LatLng target = widget.previousSelection ?? _defaultCenter;
    String? label = widget.previousLabel;

    final hasPermission =
        await PermissionService.requestLocationPermission(context);
    if (hasPermission) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        target = LatLng(position.latitude, position.longitude);
      } catch (e) {
        debugPrint('Location fetch error: $e');
      }
    } else {
      _permissionDenied = true;
    }

    setState(() {
      _cameraTarget = target;
      _selectedLatLng = widget.previousSelection;
      _locationLabel = label;
      if (_selectedLatLng != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('selected-location'),
            position: _selectedLatLng!,
          ),
        );
      }
      _loading = false;
    });
  }

  Future<void> _resolveLocationName(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = <String>[];
        if ((place.locality ?? '').isNotEmpty) parts.add(place.locality!);
        if ((place.subAdministrativeArea ?? '').isNotEmpty) {
          if (!parts.contains(place.subAdministrativeArea)) {
            parts.add(place.subAdministrativeArea!);
          }
        }
        if ((place.country ?? '').isNotEmpty) parts.add(place.country!);
        if (parts.isNotEmpty) {
          setState(() {
            _locationLabel = parts.join(', ');
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Reverse geocoding failed: $e');
    }

    setState(() {
      _locationLabel =
          '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLatLng = position;
      _markers
        ..clear()
        ..add(
          Marker(
            markerId: const MarkerId('selected-location'),
            position: position,
          ),
        );
      _locationLabel =
          '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    });
    _resolveLocationName(position);
  }

  void _confirmSelection() {
    if (_selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tap the map to select a location.')),
      );
      return;
    }

    Navigator.of(context).pop(
      LocationSelection(
        position: _selectedLatLng!,
        label: _locationLabel ??
            '${_selectedLatLng!.latitude.toStringAsFixed(4)}, ${_selectedLatLng!.longitude.toStringAsFixed(4)}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select location'),
        actions: [
          TextButton(
            onPressed: _confirmSelection,
            child: const Text(
              'Confirm',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _cameraTarget,
                      zoom: 11,
                    ),
                    markers: _markers,
                    mapType: MapType.normal,
                    onTap: _onMapTap,
                    myLocationEnabled: !_permissionDenied,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _locationLabel ?? 'Tap to place a pin on the map.',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C2B4A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _permissionDenied
                            ? 'Location permission denied. You can still select manually.'
                            : 'Tap any point on the map to set the location.',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class CreateFeedPostScreen extends StatefulWidget {
  const CreateFeedPostScreen({super.key});

  @override
  State<CreateFeedPostScreen> createState() => _CreateFeedPostScreenState();
}

class _CreateFeedPostScreenState extends State<CreateFeedPostScreen> {
  final FeedPostsRepository _repository = FeedPostsRepository();
  final HomeRepository _homeRepository = HomeRepository();
  final TextEditingController _descController = TextEditingController();
  File? _image;
  bool _submitting = false;
  bool _loadingTags = false;

  String? _selectedLocationName;
  LatLng? _selectedLocationLatLng;

  final TextEditingController _startTimeController =
      TextEditingController(text: '5:30');
  final TextEditingController _specialInstructionsController =
      TextEditingController();

  List<HomeEventModel> _availableEvents = [];
  List<HomeTrackModel> _availableTracks = [];
  String? _selectedEventId;
  String? _selectedEvent;
  String? _selectedTrackId;
  String? _selectedTrack;

  Future<void> _pickImage() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _submit() async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) return;
    setState(() => _submitting = true);
    final ok = await _repository.createPost(
      description: desc,
      image: _image,
      eventId: _selectedEventId,
      eventTitle: _selectedEvent,
      trackId: _selectedTrackId,
      trackTitle: _selectedTrack,
      location: _selectedLocationName,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post submitted for approval')),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTagData();
  }

  Future<void> _loadTagData() async {
    setState(() => _loadingTags = true);
    final feed = await _homeRepository.fetchHomeFeed();
    if (!mounted) return;
    setState(() {
      _availableEvents = feed.upcomingEvents;
      _availableTracks = feed.nearbyTracks;
      _loadingTags = false;
    });
  }

  Future<void> _openEventPicker() async {
    if (_loadingTags) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        if (_loadingTags) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (_availableEvents.isEmpty) {
          return const SizedBox(
            height: 140,
            child: Center(child: Text('No events available')),
          );
        }

        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Text('Select an event',
                    style: TextStyle(
                        fontFamily: 'Outfit', fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _availableEvents.length,
                    itemBuilder: (context, index) {
                      final event = _availableEvents[index];
                      return ListTile(
                        title: Text(event.title),
                        subtitle: Text(event.date),
                        onTap: () {
                          setState(() {
                            _selectedEventId = event.id;
                            _selectedEvent = event.title;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openTrackPicker() async {
    if (_loadingTags) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        if (_loadingTags) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (_availableTracks.isEmpty) {
          return const SizedBox(
            height: 140,
            child: Center(child: Text('No tracks available')),
          );
        }

        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Text('Select a track',
                    style: TextStyle(
                        fontFamily: 'Outfit', fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _availableTracks.length,
                    itemBuilder: (context, index) {
                      final track = _availableTracks[index];
                      return ListTile(
                        title: Text(track.title),
                        subtitle: Text(track.location),
                        onTap: () {
                          setState(() {
                            _selectedTrackId = track.id;
                            _selectedTrack = track.title;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openLocationPicker() async {
    final result = await Navigator.of(context).push<LocationSelection?>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          previousSelection: _selectedLocationLatLng,
          previousLabel: _selectedLocationName,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocationLatLng = result.position;
        _selectedLocationName = result.label;
      });
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _startTimeController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEFF4),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _SectionLabel(label: 'Add Photos / Videos'),
                  const SizedBox(height: 10),
                  _buildMediaUploadBox(),
                  const SizedBox(height: 22),
                  _SectionLabel(label: 'Write your experience'),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _descController,
                    hintText: 'Share your ride, event experience...',
                    maxLines: 1,
                    minLines: 1,
                  ),
                  const SizedBox(height: 22),
                  _SectionLabel(label: 'Tag Event (optional)'),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    hintText: 'Select event',
                    value: _selectedEvent,
                    onTap: _openEventPicker,
                  ),
                  const SizedBox(height: 22),
                  _SectionLabel(label: 'Start Time'),
                  const SizedBox(height: 10),
                  _buildTimeField(controller: _startTimeController),
                  const SizedBox(height: 22),
                  _SectionLabel(label: 'Special Instructions'),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _specialInstructionsController,
                    hintText:
                        'Join the Abu Dhabi Cycle Community Event!\nPedal through the city\'s beautiful streets and\nconnect with fellow cycling enthusiasts.\nCelebrate cycling and community spirit!',
                    maxLines: 5,
                    minLines: 4,
                  ),
                  const SizedBox(height: 22),
                  _SectionLabel(label: 'Tag Track (optional)'),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    hintText: 'Select track',
                    value: _selectedTrack,
                    onTap: _openTrackPicker,
                  ),
                  const SizedBox(height: 22),
                  _SectionLabel(label: 'Location (optional)'),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _openLocationPicker,
                    child: _buildMapPreview(),
                  ),
                  if (_selectedLocationName != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Selected location: $_selectedLocationName',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C2B4A),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  _buildPostButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD5E4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: Color(0xFFC35178),
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Create Post',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1,
                color: Color(0xFFC35178),
              ),
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  Widget _buildMediaUploadBox() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: _image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _image!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD5E4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.upload_rounded,
                      size: 26,
                      color: Color(0xFFC35178),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Upload Media',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C2B4A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Images, videos, or GIFs',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    int minLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          color: Color(0xFF1C2B4A),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF989898),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFC35178), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hintText,
    required String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? hintText,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: value != null
                    ? const Color(0xFF1C2B4A)
                    : const Color(0xFF989898),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 22,
              color: Color(0xFFC35178),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField({required TextEditingController controller}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          color: Color(0xFF1C2B4A),
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFC35178), width: 1.5),
          ),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 14),
            child: Icon(
              Icons.access_time_rounded,
              size: 20,
              color: Color(0xFFC35178),
            ),
          ),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    final initialPosition =
        _selectedLocationLatLng ?? const LatLng(24.4539, 54.3773);
    final markers = _selectedLocationLatLng != null
        ? {
            Marker(
              markerId: const MarkerId('selected-location'),
              position: _selectedLocationLatLng!,
            ),
          }
        : <Marker>{};

    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AbsorbPointer(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: _selectedLocationLatLng != null ? 12 : 10,
            ),
            markers: markers,
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
        ),
      ),
    );
  }

  Widget _buildPostButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _submitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC35178),
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: const Color(0xFFC35178).withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _submitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Post',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Outfit',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: Color(0xFF1C2B4A),
      ),
    );
  }
}

// ── Supporting widgets ───────────────────────────────────────────────────────

class _SubHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final Color titleColor;
  final Color iconColor;

  const _SubHeader({
    required this.title,
    required this.onBack,
    this.titleColor = Colors.black,
    this.iconColor = const Color(0xFFC35178),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD5E4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 22,
              color: iconColor,
            ),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              color: titleColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 36),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final FeedCommentModel comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFFFD5E4),
            child: ClipOval(
              child: comment.authorAvatar.isEmpty
                  ? const Icon(
                      Icons.person,
                      color: Color(0xFFC35178),
                      size: 18,
                    )
                  : AdaptiveImage(
                      imagePath: comment.authorAvatar,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorWidget: const Icon(
                        Icons.person,
                        color: Color(0xFFC35178),
                        size: 18,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.authorName,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF555555),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  comment.text,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B6B6B),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  _timeAgo(comment.createdAt),
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentComposer extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final bool submitting;
  final VoidCallback onSubmit;
  final VoidCallback onLoginRequired;

  const _CommentComposer({
    required this.controller,
    required this.enabled,
    required this.submitting,
    required this.onSubmit,
    required this.onLoginRequired,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      onTap: enabled ? null : onLoginRequired,
      style: const TextStyle(fontFamily: 'Outfit', fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Add a comment...',
        hintStyle: const TextStyle(
          fontFamily: 'Outfit',
          color: Color(0xFF989898),
        ),
        suffixIcon: IconButton(
          onPressed: enabled ? onSubmit : onLoginRequired,
          icon: submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.send, color: Color(0xFFC35178)),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No approved posts yet.',
        style: TextStyle(fontFamily: 'Outfit', color: Colors.grey),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE6E1D8),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Color(0xFF8A8175),
      ),
    );
  }
}

String _timeAgo(DateTime? dateTime) {
  if (dateTime == null) return 'Recently';
  final diff = DateTime.now().difference(dateTime);
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}

// class CreateFeedPostScreen extends StatefulWidget {
//   const CreateFeedPostScreen({super.key});

//   @override
//   State<CreateFeedPostScreen> createState() => _CreateFeedPostScreenState();
// }

// class _CreateFeedPostScreenState extends State<CreateFeedPostScreen> {
//   final FeedPostsRepository _repository = FeedPostsRepository();
//   final TextEditingController _descController = TextEditingController();
//   File? _image;
//   bool _submitting = false;

//   Future<void> _pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
//     if (picked != null) setState(() => _image = File(picked.path));
//   }

//   Future<void> _submit() async {
//     final desc = _descController.text.trim();
//     if (desc.isEmpty) return;
//     setState(() => _submitting = true);
//     final ok = await _repository.createPost(description: desc, image: _image);
//     if (!mounted) return;
//     setState(() => _submitting = false);
//     if (ok) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post submitted for approval')));
//       Navigator.pop(context, true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.softCream,
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             _SubHeader(title: 'Create Post', onBack: () => Navigator.pop(context)),
//             TextField(
//               controller: _descController,
//               minLines: 5,
//               maxLines: 8,
//               decoration: InputDecoration(
//                 hintText: 'Share your ride update...',
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
//               ),
//             ),
//             const SizedBox(height: 12),
//             if (_image != null) ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_image!, height: 200, width: double.infinity, fit: BoxFit.cover)),
//             TextButton.icon(onPressed: _pickImage, icon: const Icon(Icons.image, color: AppColors.deepRed), label: const Text('Add Image', style: TextStyle(color: AppColors.deepRed, fontFamily: 'Outfit'))),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: _submitting ? null : _submit,
//               style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepRed, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
//               child: _submitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Post', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SubHeader extends StatelessWidget {
//   final String title;
//   final VoidCallback onBack;
//   const _SubHeader({required this.title, required this.onBack});
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back, color: AppColors.deepRed)),
//         Expanded(child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Outfit', color: AppColors.deepRed, fontSize: 18, fontWeight: FontWeight.w600))),
//         const SizedBox(width: 48),
//       ],
//     );
//   }
// }

// class _CommentTile extends StatelessWidget {
//   final FeedCommentModel comment;
//   const _CommentTile({required this.comment});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text(comment.authorName, style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.bold, fontSize: 13)),
//         const SizedBox(height: 4),
//         Text(comment.text, style: const TextStyle(fontFamily: 'Outfit', fontSize: 13)),
//       ]),
//     );
//   }
// }

// class _CommentComposer extends StatelessWidget {
//   final TextEditingController controller;
//   final bool enabled;
//   final bool submitting;
//   final VoidCallback onSubmit;
//   final VoidCallback onLoginRequired;

//   const _CommentComposer({required this.controller, required this.enabled, required this.submitting, required this.onSubmit, required this.onLoginRequired});

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       enabled: enabled,
//       onTap: enabled ? null : onLoginRequired,
//       decoration: InputDecoration(
//         hintText: 'Add a comment...',
//         hintStyle: const TextStyle(fontFamily: 'Outfit'),
//         suffixIcon: IconButton(onPressed: enabled ? onSubmit : onLoginRequired, icon: submitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send, color: AppColors.deepRed)),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
//       ),
//     );
//   }
// }

// class _EmptyFeed extends StatelessWidget {
//   const _EmptyFeed();
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('No approved posts yet.', style: TextStyle(fontFamily: 'Outfit', color: Colors.grey)));
//   }
// }

// class _ImageFallback extends StatelessWidget {
//   const _ImageFallback();
//   @override
//   Widget build(BuildContext context) {
//     return Container(color: const Color(0xFFE6E1D8), alignment: Alignment.center, child: const Icon(Icons.image_not_supported_outlined, color: Color(0xFF8A8175)));
//   }
// }

// String _timeAgo(DateTime? dateTime) {
//   if (dateTime == null) return 'Recently';
//   final diff = DateTime.now().difference(dateTime);
//   if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
//   if (diff.inHours < 24) return '${diff.inHours}h ago';
//   return '${diff.inDays}d ago';
// }
