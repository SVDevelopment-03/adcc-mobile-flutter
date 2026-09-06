import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/services/api_exception.dart';
import 'package:adcc/core/services/api_response.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/features/auth/view/otpScreen/otp.dart';
import 'package:adcc/features/auth/Services/auth_services.dart';
import 'package:adcc/features/auth/view/setupProfile/setup_profile_screen.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/shared/widgets/app_phone_number_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  bool _isSendingOtp = false;
  bool _isEmailSubmitting = false;
  bool _isGuestLoading = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String countryCode = "+971";
  String _selectedAuthMode = 'phone';

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // void _submitForm() {
  //   setState(() {
  //     _autoValidateMode = AutovalidateMode.onUserInteraction;
  //   });

  //   if (_formKey.currentState!.validate()) {
  //     debugPrint('Phone: ${_phoneController.text}');
  //     debugPrint('Email: ${_emailController.text}');
  //      Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (_) => const OtpScreen()),
  //     );
  //   }
  // }

  void _submitForm() async {
    if (_isSendingOtp) return;

    setState(() {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
    });

    if (_formKey.currentState!.validate()) {
      final raw = _phoneController.text;
      String digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.startsWith('971') && digits.length > 10) {
        digits = digits.substring(3);
      }
      if (digits.startsWith('0')) {
        digits = digits.substring(1);
      }
      final phone = digits.startsWith('971') ? '+$digits' : '+971$digits';

      debugPrint("📱 Sending OTP to: $phone");
      setState(() {
        _isSendingOtp = true;
      });

      try {
        final resp = await AuthService.sendOtpToServer(
          recipient: phone,
          category: 'TXN',
        );

        if (!mounted) return;
        setState(() {
          _isSendingOtp = false;
        });

        if (resp.success) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.otp_sent_mobile_number)),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OtpScreen(phone: phone)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(resp.message ?? AppLocalizations.of(context)!.otp_failed)),
          );
        }
      } catch (e) {
        debugPrint('❌ sendOtp error: $e');
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.otp_failed), backgroundColor: Colors.red),
        );
        setState(() => _isSendingOtp = false);
      }
    }
  }

  Future<void> _submitEmailForm() async {
    if (_isEmailSubmitting) return;

    setState(() {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!(_emailFormKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isEmailSubmitting = true;
    });

    try {
      ApiResponse<Map<String, dynamic>> response;
      bool shouldAttemptRegister = false;

      try {
        response = await AuthService.emailLogin(
          email: email,
          password: password,
        );
      } on ApiException catch (e) {
        final statusCode = e.statusCode;
        final message = e.toString().toLowerCase();

        if (statusCode == 404 ||
            message.contains('no account found') ||
            message.contains('please create an account first')) {
          shouldAttemptRegister = true;
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        response = await AuthService.emailRegister(
          fullName: email.split('@').first,
          email: email,
          password: password,
          gender: 'Male',
        );
      }

      if (!mounted) return;

      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);

      if (response.success) {
        final data = response.data ?? {};
        final user = data['user'];
        final userFullName = (user is Map<String, dynamic>
                ? user['fullName']
                : (user is Map ? user['fullName'] : null))
            ?.toString()
            .trim();
        if (userFullName != null && userFullName.isNotEmpty) {
          await TokenStorageService.saveUserName(userFullName);
        }

        final isNewUser = shouldAttemptRegister || data['isNewUser'] == true;
        final isProfileIncomplete = data['isProfileIncomplete'] == true;

        if (isNewUser || isProfileIncomplete) {
          await TokenStorageService.saveProfileComplete(false);
          if (!mounted) return;
          navigator.pushReplacement(
            MaterialPageRoute(
              builder: (_) => SetupProfileScreen(
                initialEmail: email,
                authMode: 'email',
              ),
            ),
          );
        } else {
          await TokenStorageService.saveProfileComplete(true);
          if (!mounted) return;
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Email authentication failed.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email auth error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isEmailSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFDCE6F5),
        body: Stack(
          children: [
            /// TOP BLUE BACKGROUND
            Container(
              height: size.height * 0.47,
              width: double.infinity,
              decoration: const BoxDecoration(
                // color: Color(0xFF5F7593),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      ProfileImgs.loginphoneBackground),

                  fit: BoxFit.cover,
                  // alignment: Alignment(1, 30),
                ),

                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(42),
                  bottomRight: Radius.circular(42),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// TOP CONTENT
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          /// BACK BUTTON + TITLE ON THE SAME LINE
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 6),
                              Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    l10n.create_account_heading,
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 36),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// SUBTITLE
                          Text(
                            l10n.create_account_title,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFFDCE3EC),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          const SizedBox(height: 13),

                          /// CYCLIST IMAGE
                          Image.asset(
                            "assets/images/login-bg-img.png",
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            errorBuilder: (_, __, ___) {
                              return SizedBox(
                                height: 230,
                                child: Center(
                                  child: Text(
                                      AppLocalizations.of(context)!.image_unavailable,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    /// WHITE CARD
                    Transform.translate(
                      offset: const Offset(0, -26),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 26),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(34),
                        ),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _autoValidateMode,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6EBF5),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _selectedAuthMode = 'phone'),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 180),
                                          curve: Curves.easeInOut,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: _selectedAuthMode == 'phone'
                                                ? const Color(0xFF4D6483)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Continue as phone',
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                color: _selectedAuthMode == 'phone'
                                                    ? Colors.white
                                                    : const Color(0xFF3A485E),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(() => _selectedAuthMode = 'email'),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 180),
                                          curve: Curves.easeInOut,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          decoration: BoxDecoration(
                                            color: _selectedAuthMode == 'email'
                                                ? const Color(0xFF4D6483)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Continue as email',
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                color: _selectedAuthMode == 'email'
                                                    ? Colors.white
                                                    : const Color(0xFF3A485E),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 22),

                              if (_selectedAuthMode == 'phone') ...[
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
                                    debugPrint(
                                      'Selected country: ${country.name} (+${country.phoneCode})',
                                    );
                                  },
                                ),
                                const SizedBox(height: 26),
                                Text(
                                  l10n.create_account_phone_prompt,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF6B6B6B),
                                    fontSize: 14,
                                    height: 1.4,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _isSendingOtp ? null : _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4D6483),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: _isSendingOtp
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            l10n.continue_button,
                                            style: const TextStyle(
                                              fontFamily: 'Outfit',
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ] else ...[
                                Form(
                                  key: _emailFormKey,
                                  autovalidateMode: _autoValidateMode,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Email address',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD7DDE7),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD7DDE7),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF4D6483),
                                              width: 1.2,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 16,
                                          ),
                                        ),
                                        validator: (value) {
                                          final email = value?.trim() ?? '';
                                          if (email.isEmpty) return 'Email is required';
                                          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Password',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD7DDE7),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFD7DDE7),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(14),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF4D6483),
                                              width: 1.2,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 16,
                                          ),
                                        ),
                                        validator: (value) {
                                          if ((value ?? '').trim().isEmpty) {
                                            return 'Password is required';
                                          }
                                          if ((value ?? '').length < 6) {
                                            return 'Password must be at least 6 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 26),
                                      const Text(
                                        'Use your email address and password to continue.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          color: Color(0xFF6B6B6B),
                                          fontSize: 14,
                                          height: 1.4,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 28),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: _isEmailSubmitting ? null : _submitEmailForm,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF4D6483),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                          ),
                                          child: _isEmailSubmitting
                                              ? const SizedBox(
                                                  width: 22,
                                                  height: 22,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Text(
                                                  'Continue',
                                                  style: TextStyle(
                                                    fontFamily: 'Outfit',
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 34),

                              /// OR DIVIDER
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: const Color(0xFFE0E0E0),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      l10n.common_or,
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF707070),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: const Color(0xFFE0E0E0),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              /// GUEST BUTTON
                              GestureDetector(
                                onTap: _isGuestLoading
                                    ? null
                                    : () async {
                                        setState(() {
                                          _isGuestLoading = true;
                                        });

                                        final l10n = AppLocalizations.of(context)!;

                                        try {
                                          final response =
                                              await AuthService.guestLogin();
                                          if (response.success) {
                                            if (!mounted) return;
                                            if (context.mounted) {
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const HomeScreen(
                                                          fromGuest: true),
                                                ),
                                                (route) => false,
                                              );
                                            }
                                          } else {
                                            if (!mounted) return;
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      response.message ??
                                                          l10n.guest_login_failed),
                                                ),
                                              );
                                            }
                                          }
                                        } catch (e) {
                                          if (!mounted) return;
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(e.toString()),
                                              ),
                                            );
                                          }
                                        } finally {
                                          if (mounted) {
                                            setState(() {
                                              _isGuestLoading = false;
                                            });
                                          }
                                        }
                                      },
                                child: Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: const Color(0xFFE1E1E1),
                                    ),
                                  ),
                                  child: Center(
                                    child: _isGuestLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.person_outline,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                l10n.register_continue_as_guest,
                                                style: const TextStyle(
                                                  fontFamily: 'Outfit',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              /// SOCIAL LOGIN
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _socialButton(
                                    child: const Icon(
                                      Icons.apple,
                                      color: Colors.black,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  _socialButton(
                                    child: Image.asset(
                                      "assets/icons/google_icon.png",
                                      width: 24,
                                      errorBuilder: (_, __, ___) =>
                                          const Text("G"),
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  _socialButton(
                                    child: Image.asset(
                                      "assets/icons/facebook.png",
                                      width: 24,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.facebook,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
      ),
    );
  }

  Widget _socialButton({
    required Widget child,
  }) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE7E7E7),
        ),
      ),
      child: Center(child: child),
    );
  }
}
