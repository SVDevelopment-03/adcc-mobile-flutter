import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/utils/image_source.dart';
import 'package:flutter/material.dart';

class ProfileHeaderSection extends StatelessWidget {
  final bool showBackButton;
  final String? profileImageUrl;
  final String name;
  final String location;
  final String skillLevel;
  final Map<String, String> stats;

  const ProfileHeaderSection({
    super.key,
    this.showBackButton = false,
    this.profileImageUrl,
    required this.name,
    required this.location,
    required this.skillLevel,
    required this.stats,
  });

  static const _blue = Color(0xFF5257B5);
  static const _blueTint = Color(0xFFD6D8FF);
  static const _charcoal = Color(0xFF333333);

  Widget _buildAvatar() {
    final hasNetworkImage =
        profileImageUrl != null && profileImageUrl!.startsWith('http');

    if (hasNetworkImage) {
      return Image.network(
        profileImageUrl!,
        width: 107,
        height: 107,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildInitialAvatar(),
      );
    }

    return _buildInitialAvatar();
  }

  Widget _buildInitialAvatar() {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return Container(
      width: 107,
      height: 107,
      color: Colors.white24,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 44,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 428,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 376,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    resolveImageProvider(ProfileImgs.profileheaderbackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (showBackButton)
                  Positioned(
                    left: 16,
                    child: GestureDetector(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const SizedBox(
                        width: 35,
                        height: 35,
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                Text(
                  'Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    height: 35 / 28,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: 107,
                  height: 107,
                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   border: Border.all(color: Colors.white, width: 2),
                  // ),
                  // child: ClipOval(child: _buildAvatar()),
                ),
                const SizedBox(height: 10),
                Text(
                  name.trim().isEmpty ? 'undefined' : name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 21.6613,
                    fontWeight: FontWeight.w600,
                    height: 27 / 21.6613,
                    letterSpacing: 0.22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 225,
                  child: Text(
                    '$location - $skillLevel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 18 / 14,
                      letterSpacing: 0.14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: Container(
              height: 109,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    offset: const Offset(0, 1),
                    blurRadius: 3,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: -1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    icon: Icons.speed_rounded,
                    value: stats['km'] ?? '2,340',
                    label: 'KM',
                  ),
                  _StatItem(
                    icon: Icons.pedal_bike_rounded,
                    value: stats['rides'] ?? '126',
                    label: 'Rides',
                  ),
                  _StatItem(
                    icon: Icons.celebration_rounded,
                    value: stats['events'] ?? '14',
                    label: 'Events',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: ProfileHeaderSection._blueTint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: ProfileHeaderSection._blue,
              size: 23,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 21 / 17,
              letterSpacing: 0.17,
              color: ProfileHeaderSection._charcoal,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              height: 14 / 11,
              letterSpacing: 0.11,
              color: ProfileHeaderSection._charcoal.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
