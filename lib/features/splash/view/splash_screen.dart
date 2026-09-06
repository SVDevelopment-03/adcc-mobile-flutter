import 'package:flutter/material.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;
  late final VideoPlayerController _controller;
  late final VoidCallback _videoListener;
  Timer? _fallbackTimer;
  static const String _videoUrl =
      'https://svdigital.ae/wp-content/uploads/2026/09/Darraja-Logo-Animation-7.mp4';

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
      if (!_navigated && _controller.value.isInitialized) {
        final duration = _controller.value.duration;
        final position = _controller.value.position;
        if (position >= duration - const Duration(milliseconds: 200)) {
          _goNext();
        }
      }
    };

    _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl));

    // Fallback: if video doesn't initialize within 4 seconds, continue.
    _fallbackTimer = Timer(const Duration(seconds: 4), () {
      if (!_navigated && !_controller.value.isInitialized) {
        _goNext();
      }
    });

    _controller.initialize().then((_) {
      if (!mounted) return;
      _fallbackTimer?.cancel();
      setState(() {});
      _controller.play();
    }).catchError((_) {
      _fallbackTimer?.cancel();
      _goNext();
    });
    _controller.addListener(_videoListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _fallbackTimer?.cancel();
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      body: SizedBox.expand(
        child: _controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
