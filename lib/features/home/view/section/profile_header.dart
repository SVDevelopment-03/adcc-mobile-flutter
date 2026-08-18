import 'dart:async';
import 'package:adcc/core/services/language_storage_service.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/home/models/weather_models.dart';
import '../weather_card.dart';
import 'package:adcc/features/profile/view/screens/profile_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

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

  void _navigateToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProfileScreen(showBackButton: true)),
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
    final isGuest =
        name.isEmpty || name == AppLocalizations.of(context)!.welcome_guest;
    final hasImage = _profileImageUrl != null && _profileImageUrl!.isNotEmpty;
    final imageUrl = _profileImageUrl;

    // Use animated profile GIF when guest or user has no profile image
    if (isGuest || !hasImage) {
      return GestureDetector(
        onTap: _navigateToProfile,
        behavior: HitTestBehavior.opaque,
        child: ClipOval(
          child: Image.asset(
            'assets/icons/profile-img.gif',
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _navigateToProfile,
      behavior: HitTestBehavior.opaque,
      child: CircleAvatar(
        radius: 22.5,
        backgroundColor: AppColors.deepRed,
        backgroundImage: imageUrl!.startsWith('http')
            ? NetworkImage(imageUrl)
            : AssetImage(imageUrl) as ImageProvider,
        child: null,
      ),
    );
  }

  /// Switches the app language (EN/AR) and persists the choice.
  Future<void> _switchLanguage(String code) async {
    await LanguageStorageService.setLocaleCode(code);
    if (!mounted) return;
    MyApp.setLocale(context, Locale(code));
  }

  /// Compact EN/AR toggle stacked vertically (EN on top, Arabic on bottom).
  /// Shown left of the weather indicators.
  Widget _buildLanguageToggle() {
    final current = AppLocalizations.of(context)!.localeName.toLowerCase();
    final isAr = current.startsWith('ar');

    Widget segment({required String label, required bool selected, required String code}) {
      return GestureDetector(
        onTap: selected ? null : () => _switchLanguage(code),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: selected ? AppColors.deepRed : Colors.transparent,
            // Rounded corners for the up/down toggle.
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1,
              color: selected ? Colors.white : const Color(0xFF767779),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Color(0x1A000000),
        // Rounded corners for the up/down toggle.
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          segment(label: 'EN', selected: !isAr, code: 'en'),
          const SizedBox(height: 2),
          segment(label: 'ع', selected: isAr, code: 'ar'),
        ],
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
        padding: const EdgeInsetsDirectional.fromSTEB(16, 55, 16, 8),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name.trim().isEmpty ? AppLocalizations.of(context)!.welcome_guest : widget.name,
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
                        _city.isEmpty ? AppLocalizations.of(context)!.fetchingLocation : _city,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLanguageToggle(),
                const SizedBox(width: 10),
                FutureBuilder<WeatherSnapshot?>(
                  future: widget.weatherFuture,
                  builder: (context, snapshot) {
                    final weather = snapshot.data;
                    if (weather == null) return const SizedBox.shrink();

                    return CompactWeather(
                      weatherIcon: weather.weatherIconAsset,
                      temperature: weather.roundedTemperature,
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
