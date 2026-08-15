import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/features/auth/Services/auth_services.dart';
import 'package:adcc/features/auth/view/setupProfile/setup_profile_screen.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phone;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phone,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int seconds = 30;
  Timer? timer;
  bool canResend = false;
  bool _isLoading = false;
  bool _allowPop = false;
  String currentVerificationId = "";

  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    currentVerificationId = widget.verificationId;
    startTimer();
    debugPrint("🚨 OTP SCREEN OPENED");
  }

  @override
  void dispose() {
    timer?.cancel();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _clearOtp() {
    for (final controller in _otpControllers) {
      controller.clear();
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  // ⏱ TIMER
  void startTimer() {
    seconds = 30;
    canResend = false;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
        setState(() {
          canResend = true;
        });
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  // 🔁 RESEND OTP
  Future<void> resendOtp() async {
    debugPrint("🔁 Resending OTP...");
    debugPrint("📞 Phone: ${widget.phone}");

    final l10n = AppLocalizations.of(context)!;
    startTimer();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          debugPrint("✅ Auto verification success");
        },
        verificationFailed: (FirebaseAuthException e) {
          final message = e.code == 'too-many-requests'
              ? l10n.otp_too_many_attempts
              : (e.message ?? l10n.otp_resend_failed);
          debugPrint("❌ Resend FAILED (${e.code}): $message");
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint("📨 OTP RESENT");

          setState(() {
            currentVerificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      debugPrint("🔥 RESEND ERROR: $e");
    }
  }

  // 🔐 Retrieve Firebase ID token with retry logic
  Future<String> _getFirebaseIdToken(User user) async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        debugPrint("🔐 Token retrieval attempt ${retryCount + 1}/$maxRetries");
        final idToken = await user.getIdToken(true); // Force refresh

        if (idToken == null || idToken.isEmpty) {
          throw Exception("Firebase token is null or empty");
        }

        // Aggressive whitespace cleanup
        final cleanToken = idToken.trim().replaceAll(RegExp(r'\s+'), '');

        // Verify it looks like a JWT (3 parts)
        final parts = cleanToken.split('.');
        debugPrint("🔐 Token parts count: $parts.length");
        debugPrint("🔐 Token ID: $idToken");

        if (parts.length != 3) {
          debugPrint(
              "❌ Token format invalid: expected 3 parts, got ${parts.length}");
          debugPrint("🔍 Token preview: ${cleanToken.substring(0, 50)}...");
          throw Exception(
              "Invalid token format: expected 3 parts, got ${parts.length}");
        }

        debugPrint(
            "✅ Token retrieved successfully (length: $cleanToken.length)");
        return cleanToken;
      } catch (e) {
        retryCount++;
        debugPrint("⚠️ Token retrieval error (attempt $retryCount): $e");

        if (retryCount >= maxRetries) {
          debugPrint("🔥 Max retries reached for token retrieval");
          rethrow;
        }

        // Wait before retry
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    throw Exception(
        "Failed to retrieve Firebase token after $maxRetries attempts");
  }

  // 🔐 VERIFY OTP
  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    final l10n = AppLocalizations.of(context)!;

    debugPrint("🔐 VERIFY START");
    debugPrint("OTP: $otp");

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.otp_enter_valid_6_digit)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: currentVerificationId,
        smsCode: otp,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      debugPrint("🔐 Firebase user: ${userCredential.user?.uid}");

      // Get token with retry logic and validation
      final idToken = await _getFirebaseIdToken(userCredential.user!);

      await TokenStorageService.saveFirebaseToken(idToken);

      debugPrint("📡 Calling backend with token...");

      final response = await AuthService.verifyOtp(idToken);

      debugPrint("📦 RESPONSE: ${response.data}");

      if (!mounted) return;

      if (response.success) {
        final isNewUser = response.data?['isNewUser'] == true;

        if (isNewUser) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SetupProfileScreen()),
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? l10n.otp_failed_default)),
        );
      }
    } catch (e) {
      debugPrint("🔥 VERIFY ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: _allowPop,
        onPopInvokedWithResult: (didPop, result) {
          _clearOtp();
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFDCE6F5),
          body: Stack(
            children: [
              /// TOP BLUE SECTION
              Container(
                height: size.height * 0.47,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image:
                        CachedNetworkImageProvider(ProfileImgs.otpBackground),

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
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),

                            /// BACK + TITLE ON SAME LINE (CENTERED)
                            Row(
                              children: [
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
                                      _clearOtp();
                                      setState(() {
                                        _allowPop = true;
                                      });
                                      Navigator.of(context).maybePop();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      l10n.otp_verify_your_number,
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

                            /// SUBTITLE (centered)
                            Text(
                              l10n.otp_enter_code_sent,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                color: Color(0xFFDCE3EC),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            // const SizedBox(height: 26),

                            /// CYCLIST IMAGE
                            Image.asset(
                              "assets/images/otp.png",
                              height: 270,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                              errorBuilder: (_, __, ___) {
                                return SizedBox(
                                  height: 260,
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.image_unavailable,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.35),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      /// OTP CARD
                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.fromLTRB(18, 24, 18, 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(34),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// DESCRIPTION
                              Text(
                                l10n.otp_sent_mobile_number,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF666666),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                widget.phone,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF555555),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 26),

                              /// OTP BOXES
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  return Container(
                                    width: 48,
                                    height: 56,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: const Color(0xFFD0D0D0),
                                      ),
                                    ),
                                    child: KeyboardListener(
                                      focusNode: FocusNode(),
                                      onKeyEvent: (event) {
                                        if (event is KeyDownEvent &&
                                            event.logicalKey ==
                                                LogicalKeyboardKey.backspace &&
                                            _otpControllers[index]
                                                .text
                                                .isEmpty &&
                                            index > 0) {
                                          _otpControllers[index - 1].clear();
                                          _focusNodes[index - 1].requestFocus();
                                        }
                                      },
                                      child: TextField(
                                        controller: _otpControllers[index],
                                        focusNode: _focusNodes[index],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(1),
                                        ],
                                        style: const TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onChanged: (value) {
                                          _onOtpChanged(index, value);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(height: 20),

                              /// RESEND
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF6A6A6A),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: l10n.otp_resend_in,
                                    ),
                                    TextSpan(
                                      text: canResend
                                          ? l10n.otp_resend_now
                                          : '$seconds ${l10n.otp_seconds}',
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF555555),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = canResend
                                            ? () => resendOtp()
                                            : null,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              /// CONTINUE BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _verifyOtp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4D6483),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: _isLoading
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
                            ],
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
      ),
    );
  }
}
