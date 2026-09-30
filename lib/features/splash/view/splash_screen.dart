import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../../../core/services/app_update_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/auth_wrapper.dart';
import '../repository/splash_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;
  VideoPlayerController? _controller;
  late final VoidCallback _videoListener;
  Timer? _fallbackTimer;

  String? _mediaUrl;
  String _mediaType = 'image'; // 'video' or 'image'
  int _durationSeconds = 3; // used for image/fallback timing
  bool _isLoading = true;
  bool _isCheckingForUpdate = false;
  AppUpdateCheckResult? _appUpdateResult;
  final _repo = SplashRepository();

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthWrapper()),
    );
  }

  @override
  void initState() {
    super.initState();
    _videoListener = () {
      final c = _controller;
      if (c == null) return;
      if (!_navigated && c.value.isInitialized) {
        final duration = c.value.duration;
        final position = c.value.position;
        if (position >= duration - const Duration(milliseconds: 200)) {
          _goNext();
        }
      }
    };

    _loadCachedThenFetch();
  }

  Future<void> _loadCachedThenFetch() async {
    await _checkAppUpdate();

    // Load cached splash info if available as a quick fallback.
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('splash_media');
      if (cached != null) {
        final map = jsonDecode(cached) as Map<String, dynamic>;
        _applyMedia(map, fromCache: true);
      }
    } catch (_) {}

    // Always refresh from backend so a newly changed Current splash overrides the cache.
    try {
      final data = await _repo.fetchSplash();
      if (data != null) {
        try {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('splash_media', jsonEncode(data));
        } catch (_) {}
        if (mounted) _applyMedia(data);
      }
    } catch (_) {}

    if (_mediaUrl != null || _isLoading == false) return;

    // No splash returned from cache/backend. Keep the splash screen visible briefly,
    // then continue to the app so the user doesn't get a blank flash.
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    _fallbackTimer?.cancel();
    _fallbackTimer = Timer(const Duration(seconds: 2), () {
      if (!_navigated && mounted) {
        _goNext();
      }
    });
  }

  Future<void> _checkAppUpdate() async {
    if (_isCheckingForUpdate || _navigated || !mounted) return;

    _isCheckingForUpdate = true;
    try {
      final update = await AppUpdateService.checkFromRemote();
      if (update == null || !update.isUpdateRequired || !mounted) {
        return;
      }

      if (!mounted) return;
      setState(() {
        _appUpdateResult = update;
      });
    } catch (_) {
      // Ignore update check failures and continue normally.
    } finally {
      _isCheckingForUpdate = false;
    }
  }

  Future<void> _handleUpdateAction({required bool continueAnyway}) async {
    final update = _appUpdateResult;
    if (update == null) {
      if (continueAnyway && mounted && !_navigated) {
        _goNext();
      }
      return;
    }

    if (continueAnyway && !update.isForceUpdate && mounted && !_navigated) {
      _goNext();
      return;
    }

    await AppUpdateService.openStore(update.storeUrl);
  }

  void _applyMedia(Map<String, dynamic> map, {bool fromCache = false}) {
    final url = map['url'] as String?;
    final type = ((map['type'] as String?) ?? 'image').toLowerCase();
    final durationValue = map['duration'];
    final duration = durationValue is num ? durationValue.toInt() : null;
    if (url == null || url.isEmpty) return;

    _mediaUrl = url;
    _mediaType = (type == 'video') ? 'video' : 'image';
    if (duration != null && duration > 0) {
      _durationSeconds = duration;
    } else {
      _durationSeconds = 3;
    }

    _isLoading = false;

    if (_mediaType == 'video') {
      _fallbackTimer?.cancel();
      _initVideo(url, fromCache: fromCache);
    } else {
      setState(() {});
      _fallbackTimer?.cancel();
      _fallbackTimer = Timer(Duration(seconds: _durationSeconds), () {
        _goNext();
      });
    }
  }

  void _initVideo(String url, {bool fromCache = false}) {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _fallbackTimer?.cancel();
      // If controller doesn't initialize quickly, fallback to next screen
      _fallbackTimer = Timer(const Duration(seconds: 5), () {
        final c = _controller;
        if (!_navigated && (c == null || !c.value.isInitialized)) {
          _goNext();
        }
      });

      _controller!.initialize().then((_) {
        if (!mounted) return;
        _fallbackTimer?.cancel();
        setState(() {});
        _controller!.play();
      }).catchError((_) {
        _fallbackTimer?.cancel();
        _goNext();
      });
      _controller!.addListener(_videoListener);
    } catch (_) {
      _goNext();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _fallbackTimer?.cancel();
    if (_controller != null && _controller!.value.isPlaying) {
      _controller!.pause();
    }
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_appUpdateResult != null && _appUpdateResult!.isUpdateRequired) {
      return _buildUpdateRequiredScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SizedBox.expand(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildUpdateRequiredScreen() {
    final update = _appUpdateResult!;
    final allowSkip = !update.isForceUpdate;
    final storeLabel = update.platform == 'ios' ? 'App Store' : 'Google Play';

    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE7D7B3)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCF9F0C).withValues(alpha: 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFF1DA),
                      ),
                      child: const Icon(
                        Icons.system_update_rounded,
                        size: 46,
                        color: Color(0xFFC12D32),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Abu Dhabi Cycling Club',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Update required',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1C20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      update.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF4B5563),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9EF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE7D7B3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Current app: ${update.currentVersion}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Minimum required: ${update.minimumVersion}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleUpdateAction(continueAnyway: false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC12D32),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text('Update on $storeLabel'),
                      ),
                    ),
                    if (allowSkip) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => _handleUpdateAction(continueAnyway: true),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF333333),
                        ),
                        child: const Text('Continue anyway'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.softCream,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_mediaType == 'video' && _controller != null && _controller!.value.isInitialized) {
      final size = _controller!.value.size;
      return FittedBox(
        fit: BoxFit.cover,
        alignment: Alignment.center,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: VideoPlayer(_controller!),
        ),
      );
    }

    if (_mediaType == 'image' && _mediaUrl != null && _mediaUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: _mediaUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (c, s) => const SizedBox.shrink(),
        errorWidget: (c, s, e) => const SizedBox.shrink(),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.softCream,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
