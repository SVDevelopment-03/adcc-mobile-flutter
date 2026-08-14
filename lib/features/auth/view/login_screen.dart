import 'package:adcc/features/auth/view/registrationScreen/create_account.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/auth/view/otpScreen/otp.dart';
import 'package:adcc/features/auth/Services/social_auth_service.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import 'package:adcc/shared/widgets/app_phone_number_field.dart';
import '../view/setupProfile/setup_profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  bool _isSendingOtp = false;
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  String countryCode = "+971";

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isSendingOtp) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
    });

    if (_formKey.currentState!.validate()) {
      final phone = "$countryCode${_phoneController.text}";
      setState(() => _isSendingOtp = true);

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          final message = e.code == 'too-many-requests'
              ? l10n.otp_too_many_attempts
              : (e.message ?? l10n.otp_failed);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          setState(() => _isSendingOtp = false);
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;
          setState(() => _isSendingOtp = false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(
                verificationId: verificationId,
                phone: phone,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!mounted) return;
          setState(() => _isSendingOtp = false);
        },
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    if (_isGoogleLoading) return;

    final l10n = AppLocalizations.of(context)!;

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
            content: Text(response.message ?? l10n.google_login_failed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Google login error: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error_prefix} ${e.toString()}'),
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

    final l10n = AppLocalizations.of(context)!;

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
            content: Text(response.message ?? l10n.facebook_login_failed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Facebook login error: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error_prefix} ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.softCream,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autoValidateMode,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Image.asset(
                          'assets/icons/adcc_logo.png',
                          width: 85,
                          height: 69,
                        ),
                        const SizedBox(height: 60),
                        Text(
                          l10n.login_to_your_account,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 40),
                        AppPhoneNumberField(
                          controller: _phoneController,
                          hintText: l10n.phone_number_placeholder,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.error_required_number;
                            }
                            if (value.length < 8) {
                              return l10n.error_valid_number;
                            }
                            return null;
                          },
                          onCountryChanged: (country) {
                            setState(() {
                              countryCode = "+${country.phoneCode}";
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 51,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSendingOtp ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.deepRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSendingOtp
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    l10n.login,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 25),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                l10n.or_continue_with,
                                style: const TextStyle(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialCircleButton(
                              onTap: null,
                              isLoading: false,
                              child: const Icon(
                                Icons.apple,
                                size: 24,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 18),
                            _buildSocialCircleButton(
                              onTap:
                                  _isGoogleLoading ? null : _handleGoogleLogin,
                              isLoading: _isGoogleLoading,
                              child: Image.asset(
                                'assets/icons/google_icon.png',
                                width: 22,
                                height: 22,
                              ),
                            ),
                            const SizedBox(width: 18),
                            _buildSocialCircleButton(
                              onTap: _isFacebookLoading
                                  ? null
                                  : _handleFacebookLogin,
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
                        const SizedBox(height: 25),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF333333),
                            ),
                            children: [
                              TextSpan(text: l10n.dont_have_account),
                              TextSpan(
                                text: l10n.sign_up,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const CreateAccountScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
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
                    AppColors.deepRed,
                  ),
                ),
              )
            : child,
      ),
    );
  }
}
