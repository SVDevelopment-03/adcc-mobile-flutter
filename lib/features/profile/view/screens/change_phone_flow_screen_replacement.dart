import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _Step { enterNew, verifyNew, success }

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  _Step _step = _Step.enterNew;

  final _phoneController = TextEditingController(text: '501234567');
  final _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  bool _sending = false;
  bool _loading = false;
  int _resendSeconds = 59;
  Timer? _resendTimer;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _otpFocusNode.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 59);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendSeconds <= 1) {
        timer.cancel();
        setState(() => _resendSeconds = 0);
        return;
      }
      setState(() => _resendSeconds -= 1);
    });
  }

  void _handleOtpInput(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 6) {
      _otpController.text = digits.substring(0, 6);
      _otpController.selection = TextSelection.collapsed(offset: 6);
    } else {
      _otpController.value = TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }
    setState(() {});
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.trim().isEmpty) return;
    setState(() => _sending = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _sending = false;
      _step = _Step.verifyNew;
    });
    _startCountdown();
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 6) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _step = _Step.success;
    });
  }

  Widget _buildPhoneInputField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E2E2)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFE3FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      '🇦🇪',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '+971',
                  style: TextStyle(
                    color: Color(0xFF1B1B1B),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 24,
                  color: const Color(0xFFEDEDED),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '50 123 4567',
                hintStyle: TextStyle(
                  color: Color(0xFFB9B9B9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              style: const TextStyle(
                color: Color(0xFF1B1B1B),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterNew() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 18),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D6FF),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Center(
              child: Icon(Icons.phone_rounded, color: Color(0xFF7A4FD6), size: 28),
            ),
          ),
          const SizedBox(height: 34),
          const Text(
            'Enter your new phone number',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF121212),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'We’ll send a verification code to your new number.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Phone Number',
              style: TextStyle(
                color: const Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildPhoneInputField(),
          const SizedBox(height: 10),
          const Text(
            'You’ll receive an OTP on this number',
            style: TextStyle(
              color: Color(0xFF7A8497),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _sending || _phoneController.text.trim().isEmpty ? null : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4D5E73),
                disabledBackgroundColor: const Color(0xFFCBD5E1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: _sending
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Send OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyNew() {
    final digits = _otpController.text.padRight(6, ' ');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 18),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D6FF),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Center(
              child: Icon(Icons.phone_rounded, color: Color(0xFF7A4FD6), size: 28),
            ),
          ),
          const SizedBox(height: 34),
          const Text(
            'Verify your new phone number',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF121212),
              fontSize: 31,
              fontWeight: FontWeight.w700,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'We’ve sent a verification code to your new phone number.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDEE3EB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_rounded, color: Color(0xFF32455B), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New Phone Number',
                        style: TextStyle(
                          color: Color(0xFF7A8497),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _phoneController.text.isEmpty ? '+971 50 123 4567' : '+971 ${_phoneController.text}',
                        style: const TextStyle(
                          color: Color(0xFF101828),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _step = _Step.enterNew),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF4D5E73),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: const Size(0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter OTP',
              style: TextStyle(
                color: const Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: () => _otpFocusNode.requestFocus(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0,
                      child: TextField(
                        focusNode: _otpFocusNode,
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        onChanged: _handleOtpInput,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final char = digits.length > index ? digits[index] : '';
                      final active = char != ' ' && char.isNotEmpty;
                      return Container(
                        width: 46,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: active ? const Color(0xFFF3F6FF) : Colors.white,
                          border: Border.all(
                            color: active ? const Color(0xFF4D5E73) : const Color(0xFFE2E8F0),
                            width: active ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          char.trim(),
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          if (_resendSeconds > 0)
            Text(
              'Resend the OTP in ${_resendSeconds} sec',
              style: const TextStyle(
                color: Color(0xFF7A8497),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            )
          else
            TextButton(
              onPressed: _sending ? null : _sendOtp,
              child: const Text(
                'Send OTP',
                style: TextStyle(
                  color: Color(0xFF4D5E73),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _loading || _otpController.text.trim().length < 6 ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4D5E73),
                disabledBackgroundColor: const Color(0xFFCBD5E1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Verify & Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 28),
          Container(
            width: 82,
            height: 82,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Color(0xFF4CAF50), size: 48),
          ),
          const SizedBox(height: 28),
          const Text(
            'Phone number changed\nsuccessfully',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1B1B1B),
              fontSize: 46,
              fontWeight: FontWeight.w700,
              height: 1.02,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Your phone number has been updated successfully',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF6E4AC5), Color(0xFF4D5E73)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_rounded, color: Color(0xFF4D5E73), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New Phone Number',
                        style: TextStyle(
                          color: Color(0xFFEAE6FF),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+971 ${_phoneController.text}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            height: 210,
            width: double.infinity,
            child: CustomPaint(
              painter: _CyclistPlaceholderPainter(),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: () => Navigator.maybePop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4D5E73),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = switch (_step) {
      _Step.enterNew => _buildEnterNew(),
      _Step.verifyNew => _buildVerifyNew(),
      _Step.success => _buildSuccess(),
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Change Phone Number',
          style: TextStyle(
            color: Color(0xFF121212),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1B1B1B)),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(child: screen),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CyclistPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = const Color(0xFFEDE2FA);
    final dark = Paint()..color = const Color(0xFFD9C4F5);
    final body = Paint()..color = const Color(0xFFDDD3F3);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size.height * 0.18, size.width, size.height * 0.82),
        const Radius.circular(30),
      ),
      fill,
    );

    final palmPaint = Paint()..color = const Color(0xFFDBCCF6);
    canvas.drawPath(
      Path()
        ..moveTo(12, size.height * 0.62)
        ..lineTo(18, size.height * 0.38)
        ..lineTo(22, size.height * 0.62)
        ..close(),
      palmPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width - 28, size.height * 0.63)
        ..lineTo(size.width - 20, size.height * 0.36)
        ..lineTo(size.width - 12, size.height * 0.63)
        ..close(),
      palmPaint,
    );

    final wheel1 = Offset(size.width * 0.25, size.height * 0.72);
    final wheel2 = Offset(size.width * 0.68, size.height * 0.72);
    final radius = 52.0;
    canvas.drawCircle(wheel1, radius, dark);
    canvas.drawCircle(wheel2, radius, dark);
    canvas.drawCircle(wheel1, radius * 0.53, fill);
    canvas.drawCircle(wheel2, radius * 0.53, fill);

    final bikeLine = Paint()
      ..color = const Color(0xFFCBB9F0)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(size.width * 0.25, size.height * 0.72), Offset(size.width * 0.45, size.height * 0.55), bikeLine);
    canvas.drawLine(Offset(size.width * 0.45, size.height * 0.55), Offset(size.width * 0.68, size.height * 0.72), bikeLine);
    canvas.drawLine(Offset(size.width * 0.45, size.height * 0.55), Offset(size.width * 0.52, size.height * 0.65), bikeLine);
    canvas.drawLine(Offset(size.width * 0.52, size.height * 0.65), Offset(size.width * 0.39, size.height * 0.65), bikeLine);
    canvas.drawLine(Offset(size.width * 0.39, size.height * 0.65), Offset(size.width * 0.25, size.height * 0.72), bikeLine);

    final cyclist = Paint()..color = const Color(0xFFCCC1F1);
    canvas.drawCircle(Offset(size.width * 0.52, size.height * 0.42), 22, cyclist);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.52, size.height * 0.52),
          width: 46,
          height: 54,
        ),
        const Radius.circular(20),
      ),
      cyclist,
    );
    canvas.drawLine(Offset(size.width * 0.52, size.height * 0.52), Offset(size.width * 0.48, size.height * 0.62), bikeLine);
    canvas.drawLine(Offset(size.width * 0.52, size.height * 0.52), Offset(size.width * 0.60, size.height * 0.62), bikeLine);
    canvas.drawLine(Offset(size.width * 0.52, size.height * 0.52), Offset(size.width * 0.45, size.height * 0.72), bikeLine);
    canvas.drawLine(Offset(size.width * 0.52, size.height * 0.52), Offset(size.width * 0.61, size.height * 0.72), bikeLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
