import 'package:adcc/features/profile/view/sections/profile/my_badge_section.dart';
import 'package:adcc/features/profile/view/sections/profile/my_communities_section.dart';
import 'package:adcc/features/profile/view/sections/profile/my_joined_events_section.dart';
import 'package:adcc/core/utils/image_source.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/cosmatic_imgs.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../auth/view/registrationScreen/create_account.dart';
import '../../viewmodels/profile_view_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../sections/profile/profile_header_section.dart';
import '../sections/profile/profile_menu_section.dart';
import '../sections/guest_screen/guest_profile_section.dart';
import '../../../onboarding/view/onboarding_screen.dart';
import '../../../home/view/home_screen.dart';
import '../../../communities/view/community_screen.dart';
import '../../../events/view/my_event_screen.dart';
import 'badges_achievement.screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool showBackButton;

  const ProfileScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;
  bool _isDeletingAccount = false;
  bool _isAuthenticated = false;
  bool _isGuestUser = false;
  bool _isCheckingAuth = true;
  final ProfileViewModel _profileViewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    _profileViewModel.addListener(_onProfileChanged);
    _checkAuthentication();
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _profileViewModel.removeListener(_onProfileChanged);
    _profileViewModel.dispose();
    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    final isAuthenticated = await TokenStorageService.isAuthenticated();
    final isGuest = await TokenStorageService.isGuestUser();

    // Only load remote profile for non-guest authenticated users
    if (isAuthenticated && !isGuest) {
      await _profileViewModel.loadProfile();
    }

    if (mounted) {
      setState(() {
        _isAuthenticated = isAuthenticated;
        _isGuestUser = isGuest;
        _isCheckingAuth = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      final refreshToken = await TokenStorageService.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final apiClient = ApiClient.instance;
          final requestData = {
            'refreshToken': refreshToken,
          };

          debugPrint(' [Logout API] Request URL: ${ApiEndpoints.authLogout}');
          debugPrint(' [Logout API] Request Body: $requestData');

          final response = await apiClient.post<dynamic>(
            ApiEndpoints.authLogout,
            data: requestData,
          );

          debugPrint(
              ' [Logout API] Response Status Code: ${response.statusCode}');
          debugPrint(' [Logout API] Response Body: ${response.data}');

          if (response.statusCode != null &&
              response.statusCode! >= 200 &&
              response.statusCode! < 300) {
            debugPrint(' [Logout API] Logout successful');
          } else {
            debugPrint(' [Logout API] Logout API returned non-success status');
          }
        } on DioException {
          // Logout can still proceed locally if the remote call fails.
        } catch (e) {
          // Logout can still proceed locally if an unexpected error occurs.
        }
      } else {
        debugPrint(' [Logout] No refresh token found, skipping API call');
      }

      await TokenStorageService.clearTokens();
      debugPrint(' [Logout] Local tokens cleared');

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      await TokenStorageService.clearTokens();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
          (route) => false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    if (_isDeletingAccount) return;

    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.delete_account_title),
          content: Text(l10n.delete_account_message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.delete_account_cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                l10n.delete_account_confirm,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _isDeletingAccount = true;
    });

    try {
      final apiClient = ApiClient.instance;

      await apiClient.delete<dynamic>(
        ApiEndpoints.deleteAccount,
      );

      await TokenStorageService.clearTokens();

      if (!mounted) return;

      // Show confirmation toast/snackbar to the user before navigating away
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.account_deleted_successfully)),
      );

      // Give the snack a moment to appear so the user sees it
      await Future.delayed(const Duration(milliseconds: 800));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const CreateAccountScreen(),
        ),
        (route) => false,
      );
    } on DioException catch (e) {
      debugPrint('Delete account failed: ${e.response?.data ?? e.message}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failed_delete_account),
          ),
        );
      }
    } catch (e) {
      debugPrint('Delete account unexpected error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingAccount = false;
        });
      }
    }
  }

  void _handleSignUpLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateAccountScreen(),
      ),
    );

    _checkAuthentication();
  }

  void _handleBrowseEvents() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(initialIndex: 1),
      ),
    );
  }

  void _handleExploreCommunity() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(initialIndex: 2),
      ),
    );
  }

  void _handleViewRoutes() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(initialIndex: 3),
      ),
    );
  }

  void _handleViewAllBadges() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BadgesAchievementsScreen(),
      ),
    );
  }

  void _handleViewAllCommunities() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CommunitiesScreen(),
      ),
    );
  }

  void _handleViewAllJoinedEvents() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MYEVENET(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAuth) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5EDFF),
        body: Container(
          color: const Color(0xFFF5EDFF),
          child: const SafeArea(
            top: false,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    // Show guest profile screen if guest or not authenticated
    if (_isGuestUser || !_isAuthenticated) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5EDFF),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: resolveImageProvider(ProfileImgs.profileBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
            children: [
              // Header with Profile title
              Container(
                // color: const Color(0xFFD6D8FF),
                padding: const EdgeInsets.fromLTRB(21, 90, 16, 0),
                child: SizedBox(
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: const Color(0xFF95baf5)
                                  .withValues(alpha: 0.36),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Color(0xFF5257B5),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.profile_title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          height: 1.28,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Guest Profile Content
              Expanded(
                child: GuestProfileSection(
                  onSignUpLogin: _handleSignUpLogin,
                  onBrowseEvents: _handleBrowseEvents,
                  onExploreCommunity: _handleExploreCommunity,
                  onViewRoutes: _handleViewRoutes,
                ),
              ),
            ],
          ),
        ),
      ),);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5EDFF),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: resolveImageProvider(ProfileImgs.profileBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            bottom: 100,
          ),
          children: [
            ProfileHeaderSection(
              showBackButton: widget.showBackButton,
              name: _profileViewModel.profile?.fullName ?? '',
              location: _profileViewModel.profile?.city ?? '',
              skillLevel: _profileViewModel.profile?.skillLevel ??
                  AppLocalizations.of(context)!.intermediate_rider,
              profileImageUrl:
                  _profileViewModel.profile?.image.startsWith('http') == true
                      ? _profileViewModel.profile!.image
                      : null,
              stats: {
                'km': _profileViewModel.profile?.km ?? '0',
                'rides': _profileViewModel.profile?.rides ?? '0',
                'events': _profileViewModel.profile?.events ?? '0',
              },
            ),
            MyBadgesSection(
              onViewAll: _handleViewAllBadges,
            ),
            const SizedBox(height: 24),
            MyCommunitiesSection(
              onViewAll: _handleViewAllCommunities,
            ),
            const SizedBox(height: 49),
            MyJoinedEventsSection(
              onViewAll: _handleViewAllJoinedEvents,
            ),
            const SizedBox(height: 50),
            const ProfileMenuSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // const SizedBox(height: 50),

                  //TODO: Uncomment this section when the Route Details Integration feature is ready to be displayed in the profile screen.
                  // Route Details Integration
                  // RouteDetailsIntegrationSection(
                  //   services: [
                  //     ServiceIntegration(
                  //       name: 'Garmin',
                  //       onConnect: () {
                  //         debugPrint('Connect Garmin tapped');
                  //       },
                  //     ),
                  //     ServiceIntegration(
                  //       name: 'Wahoo',
                  //       onConnect: () {
                  //         debugPrint('Connect Wahoo tapped');
                  //       },
                  //     ),
                  //   ],
                  // ),

                  const SizedBox(height: 50),

                  AppButton(
                    label: _isDeletingAccount
                        ? AppLocalizations.of(context)!.deleting_account
                        : AppLocalizations.of(context)!.delete_account_title,
                    textStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                    onPressed: _isDeletingAccount ? null : _handleDeleteAccount,
                    type: AppButtonType.danger,
                    backgroundColor: Color(0xFF5257B5),
                  ),

                  const SizedBox(height: 16),

                  AppButton(
                    label: _isLoggingOut
                        ? AppLocalizations.of(context)!.logging_out
                        : AppLocalizations.of(context)!.logout,
                    textStyle: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1, // 100% line height
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                    onPressed: _isLoggingOut ? null : _handleLogout,
                    type: AppButtonType.danger,
                    backgroundColor: const Color(0xFF5257B5),
                  ),
                  const SizedBox(height: 95),
                ],
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}
