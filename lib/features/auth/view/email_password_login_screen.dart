import 'package:adcc/features/auth/view/otpScreen/otp.dart';
import 'package:adcc/features/auth/Services/social_auth_service.dart';
import 'package:adcc/features/auth/view/registrationScreen/create_account.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adcc/features/auth/view/login_screen.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import '../view/setupProfile/setup_profile_screen.dart';

class EmailPasswordLoginScreen extends StatefulWidget {
  const EmailPasswordLoginScreen({super.key});

  @override
  State<EmailPasswordLoginScreen> createState() =>
      _EmailPasswordLoginScreenState();
}

class _EmailPasswordLoginScreenState extends State<EmailPasswordLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isSendingOtp = false;
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;

  Country _selectedCountry = Country.parse('AE');
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
    );
  }

  // void _continue() {
  //   setState(() {
  //     _autoValidateMode = AutovalidateMode.onUserInteraction;
  //   });

  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (_) => const OtpScreen()),
  //   );
  // }

  void _continue() async {
    if (_isSendingOtp) return;

    setState(() {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final phone =
        "+${_selectedCountry.phoneCode}${_phoneController.text.trim()}";

    debugPrint("📱 Sending OTP to: $phone");

    setState(() {
      _isSendingOtp = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint("✅ Auto verification completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("❌ OTP Failed (${e.code}): ${e.message}");

        final message = e.code == 'too-many-requests'
            ? 'Too many OTP attempts from this device. Please wait and try again later.'
            : (e.message ?? 'OTP Failed');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        if (mounted) {
          setState(() {
            _isSendingOtp = false;
          });
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        debugPrint("📨 OTP Sent");
        debugPrint("🆔 verificationId: $verificationId");

        if (mounted) {
          setState(() {
            _isSendingOtp = false;
          });
        }

        Navigator.push(
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
        if (mounted) {
          setState(() {
            _isSendingOtp = false;
          });
        }
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const screenBg = Color(0xFFFFF9EF);
    const double contentMaxWidth = 358;
    final size = MediaQuery.sizeOf(context);
    final bool isShortScreen = size.height < 760;
    const double topGapAfterBack = 28;
    const double logoToTitleGap = 64;
    const double titleToSubtitleGap = 10;
    const double subtitleToInputGap = 28;
    const double inputToButtonGap = 20;
    const double buttonToLoginGap = 16;
    final double loginToPolicyGap = isShortScreen ? 120 : 170;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: screenBg,
        body: ColoredBox(
          color: screenBg,
          child: SafeArea(
            child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0x1A000000),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: Color(0xFF2B2B2B),
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
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: contentMaxWidth),
                        child: Column(
                          children: [
                            const SizedBox(height: topGapAfterBack),
                            Image.asset(
                              'assets/icons/adcc_logo.png',
                              width: 85,
                              height: 69,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: logoToTitleGap),
                            const Text(
                              'Create your account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                height: 1.25,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: titleToSubtitleGap),
                            Text(
                              l10n.create_account_title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 1.25,
                                color: Color(0xFF434343),
                              ),
                            ),
                            const SizedBox(height: subtitleToInputGap),
                            Container(
                              height: 56,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.23),
                                ),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: _openCountryPicker,
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            width: 34,
                                            height: 34,
                                            alignment: Alignment.center,
                                            color: Colors.white,
                                            child: Text(
                                              _selectedCountry.flagEmoji,
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '+${_selectedCountry.phoneCode}',
                                          style: const TextStyle(
                                            fontFamily: 'Outfit',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            height: 1.35,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 18,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 1,
                                    height: 28,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      contextMenuBuilder: (context, editableTextState) => const SizedBox.shrink(),
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xFF333333),
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        isCollapsed: true,
                                hintText: l10n.phone_number_placeholder,
                                        hintStyle: const TextStyle(
                                          fontFamily: 'Outfit',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xFF6C6C6C),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return l10n.error_required_number;
                                        }
                                        if (value.trim().length < 8) {
                                          return l10n.error_valid_number;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: inputToButtonGap),
                            SizedBox(
                              height: 51,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSendingOtp ? null : _continue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0359E8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
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
                                        l10n.continue_button,
                                        style: const TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                        ),
                                      ),
                                ),
                              ),
                            const SizedBox(height: buttonToLoginGap),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  height: 1.28,
                                  color: Color(0xFF333333),
                                ),
                                children: [
                                  const TextSpan(
                                      text: 'Already have an account? '),
                                  TextSpan(
                                    text: 'Login',
                                    style: const TextStyle(
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const CreateAccountScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Color(0xFFA3A4A6),
                                    thickness: 1,
                                  ),
                                ),
                                Container(
                                  color: const Color(0xFFFFF9EF),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: const Text(
                                    'Or continue with',
                                    style: TextStyle(
                                      fontFamily: 'Satoshi',
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
                            SizedBox(height: loginToPolicyGap),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Text(
                  l10n.policy,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
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
                    Color(0xFF0359E8),
                  ),
                ),
              )
            : child,
      ),
    );
  }
}
