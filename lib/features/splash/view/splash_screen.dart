import 'package:flutter/material.dart';
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
  static const String _videoUrl = 'https://svdigital.ae/wp-content/uploads/2026/05/ADDC-Logo-Animation-Black-v5.mp4';

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

    _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.play();
      });
    _controller.addListener(_videoListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
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
            ? Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

