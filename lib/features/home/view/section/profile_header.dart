import 'dart:async';
import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/weather_models.dart';
import 'package:adcc/features/profile/view/screens/edit_profile_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  final String name;
  final VoidCallback? onNotificationTap;
  final Future<WeatherSnapshot?>? weatherFuture;

  const ProfileHeader({
    super.key,
    required this.name,
    this.onNotificationTap,
    this.weatherFuture,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader>
    with WidgetsBindingObserver {
  String _city = '';
  String? _profileImageUrl;
  Timer? _refreshTimer;
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLocation();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _navigateToEditProfile() {
    final name = widget.name.trim();
    final isGuest = name.isEmpty || name == 'Welcome, Guest';
    if (isGuest) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
  }

  void _startPeriodicRefresh() {
    int checkCount = 0;

    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      checkCount++;

      if (checkCount >= 5) {
        timer.cancel();
        return;
      }

      await _loadLocation();

      if (_city.isNotEmpty) {
        timer.cancel();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadLocation();
    }
  }

  Future<void> _loadLocation() async {
    try {
      final profile = await _profileRepository.fetchProfile();
      final profileCity = profile?.city ?? '';
      final profileImageUrl = profile?.image;
      if (mounted) {
        setState(() {
          _city = profileCity;
          _profileImageUrl =
              profileImageUrl?.trim().isEmpty == true ? null : profileImageUrl;
        });
      }
    } catch (_) {
      // leave _city and _profileImageUrl as-is
    }
  }

  Widget _buildAvatar() {
    final name = widget.name.trim();
    final isGuest = name.isEmpty || name == 'Welcome, Guest';

    if (isGuest) {
      return const CircleAvatar(
        radius: 22.5,
        backgroundColor: Color(0xFFE0E0E0),
        child: Icon(Icons.person, size: 26, color: Color(0xFF757575)),
      );
    }

    final initial = name[0].toUpperCase();
    final hasImage = _profileImageUrl != null && _profileImageUrl!.isNotEmpty;
    final imageUrl = _profileImageUrl;

    return GestureDetector(
      onTap: _navigateToEditProfile,
      behavior: HitTestBehavior.opaque,
      child: CircleAvatar(
        radius: 22.5,
        backgroundColor: AppColors.deepRed,
        backgroundImage: hasImage
            ? (imageUrl!.startsWith('http')
                ? NetworkImage(imageUrl)
                : AssetImage(imageUrl) as ImageProvider)
            : null,
        child: hasImage
            ? null
            : Text(
                initial,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // image: DecorationImage(
        //   image: CachedNetworkImageProvider(
        //     HomeImgs.homeheaderbackground,
        //   ),
        //   fit: BoxFit.fitWidth,
        //   alignment: Alignment(0, -0.9), // Move image down
        // ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 55, 16, 8),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name.trim().isEmpty ? 'Welcome, Guest' : widget.name,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: 0,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/location.png',
                        height: 14,
                        width: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _city.isEmpty ? 'Fetching location...' : _city,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1, // 100% line height
                          letterSpacing: 0,
                          color: Color(0xFF767779),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder<WeatherSnapshot?>(
                  future: widget.weatherFuture,
                  builder: (context, snapshot) {
                    final weather = snapshot.data;
                    if (weather == null) return const SizedBox.shrink();
                    final l10n = AppLocalizations.of(context)!;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          weather.weatherIconAsset,
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${weather.roundedTemperature}${l10n.temperatureUnit}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
