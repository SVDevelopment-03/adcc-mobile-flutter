import 'dart:convert';
import 'package:flutter/material.dart';

class CommunityDetailsHeader extends StatelessWidget {
  final String? base64Image;
  final String title;
  final VoidCallback onBackTap;

  const CommunityDetailsHeader({
    super.key,
    required this.base64Image,
    required this.title,
    required this.onBackTap,
  });

  bool _isBase64(String path) {
    return path.startsWith('data:image');
  }

  Widget _buildImage() {
    if (base64Image == null || base64Image!.isEmpty) {
      return _fallback();
    }

    try {
      if (_isBase64(base64Image!)) {
        final base64String = base64Image!.split(',').last;

        return Image.memory(
          base64Decode(base64String),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _fallback(),
        );
      } else {
        return Image.network(
          base64Image!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => _fallback(),
        );
      }
    } catch (_) {
      return _fallback();
    }
  }

  Widget _fallback() {
    return Image.asset(
      'assets/images/community_ride.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 414,
          width: double.infinity,
          child: Stack(
            children: [
              /// IMAGE
              Positioned.fill(
                child: _buildImage(),
              ),

              /// DARK OVERLAY
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.03),
                ),
              ),

              /// DECORATIVE FRAME
              // Positioned(
              //   left: -35,
              //   bottom: -35,
              //   child: Image.asset(
              //     'assets/images/frame_1.png',
              //     width: 160,
              //     height: 160,
              //     fit: BoxFit.contain,
              //   ),
              // ),

            
              Positioned(
                left: 14,
                top: 14,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onBackTap,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFFC12D32),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
