import 'package:adcc/features/auth/Services/auth_services.dart';
import 'package:adcc/features/auth/Services/social_auth_service.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/token_storage_service.dart';
import '../../home/view/home_screen.dart';
import 'email_password_login_screen.dart';
import 'registrationScreen/create_account.dart';
import '../view/setupProfile/setup_profile_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndRedirect();
  }

  Future<void> _checkAuthAndRedirect() async {
    final isAuthenticated = await TokenStorageService.isAuthenticated();
    if (isAuthenticated && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }
  }

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;

  Future<void> _continueAsGuest() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await AuthService.guestLogin();

      if (response.success) {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(fromGuest: true),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onDisabledButtonPressed() {}

  Future<void> _handleGoogleLogin() async {
    if (_isGoogleLoading) return;

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      debugPrint('🔵 Starting Google login...');
      final response = await SocialAuthService.loginWithGoogle();

      if (!mounted) return;

      if (response.success) {
        final isNewUser = response.data?['isNewUser'] == true;

        if (isNewUser) {
          debugPrint('👤 New user - navigating to profile setup');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SetupProfileScreen()),
          );
        } else {
          debugPrint('✅ Existing user - navigating to home');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Google login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Google login error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _handleFacebookLogin() async {
    if (_isFacebookLoading) return;

    setState(() {
      _isFacebookLoading = true;
    });

    try {
      debugPrint('🔵 Starting Facebook login...');
      final response = await SocialAuthService.loginWithFacebook();

      if (!mounted) return;

      if (response.success) {
        final isNewUser = response.data?['isNewUser'] == true;

        if (isNewUser) {
          debugPrint('👤 New user - navigating to profile setup');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SetupProfileScreen()),
          );
        } else {
          debugPrint('✅ Existing user - navigating to home');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Facebook login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Facebook login error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFacebookLoading = false;
        });
      }
    }
  }

  void _navigateToEmailPasswordLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateAccountScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topSectionHeight = size.height * 0.51;
    final sheetHeight = size.height - (topSectionHeight - 22);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6EB),
      body: Stack(
        children: [
          SizedBox(
            height: topSectionHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/registeration_header_banner.png',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.45),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                      stops: const [0.4, 0.72, 1.0],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 14, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0.78),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Ride. Connect.',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text:
                                "\nJoin Abu Dhabi's premier cycling community App",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.35,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: sheetHeight,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
              decoration: const BoxDecoration(
                color: AppColors.softCream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                children: [
                  _buildPrimaryMobileButton(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Color(0xFFA3A4A6),
                          thickness: 1,
                        ),
                      ),
                      Container(
                        color: AppColors.softCream,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text(
                          'Skip and continue as',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF484A4D),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color(0xFFA3A4A6),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildGuestButton(),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialCircleButton(
                        onTap: _onDisabledButtonPressed,
                        isLoading: false,
                        child: const Icon(
                          Icons.apple,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 18),
                      _buildSocialCircleButton(
                        onTap: _isGoogleLoading ? null : _handleGoogleLogin,
                        isLoading: _isGoogleLoading,
                        child: Image.asset(
                          'assets/icons/google_icon.png',
                          width: 22,
                          height: 22,
                        ),
                      ),
                      const SizedBox(width: 18),
                      _buildSocialCircleButton(
                        onTap: _isFacebookLoading ? null : _handleFacebookLogin,
                        isLoading: _isFacebookLoading,
                        child: Image.asset(
                          'assets/icons/facebook_icon.png',
                          width: 22,
                          height: 22,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.facebook,
                            color: Color(0xFF1877F2),
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // const Text(
                  //   "By continuing, you agree to ADCycling's Terms of Service\nand Privacy Policy",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontFamily: 'Outfit',
                  //     fontSize: 13,
                  //     fontWeight: FontWeight.w400,
                  //     height: 1.2,
                  //     color: AppColors.textSecondary,
                  //   ),
                  // ),
                  const SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        "By continuing, you agree to ADCycling's Terms of Service\nand Privacy Policy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryMobileButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.3,
      child: ElevatedButton(
        onPressed: _navigateToEmailPasswordLogin,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF07B487),
          foregroundColor: Colors.white,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, size: 18, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Continue With Mobile Number',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.3,
      child: OutlinedButton(
        onPressed: _isLoading ? null : _continueAsGuest,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          side: const BorderSide(color: Color(0xFFDADADA), width: 1.16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline,
                      size: 18, color: AppColors.textDark),
                  SizedBox(width: 8),
                  Text(
                    'Continue as Guest',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSocialCircleButton({
    required Widget child,
    required VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(74),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0x1A000000),
          borderRadius: BorderRadius.circular(74),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF07B487),
                  ),
                ),
              )
            : child,
      ),
    );
  }
}
