import 'dart:async';

import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/services/user_api.dart';
import 'package:adcc/features/auth/Services/auth_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _Step { enterNew, verifyCurrent, enterNewAfterVerify, verifyNew, success }

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  _Step _step = _Step.enterNew;

  final _phoneController = TextEditingController(text: '501234567');
  final _otpController = TextEditingController();
  final _oldCodeController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  bool _sending = false;
  bool _loading = false;
  int _resendSeconds = 59;
  Timer? _resendTimer;
  String? _changeToken;
  String? _currentPhone;

  @override
  void initState() {
    super.initState();
    _loadCurrentPhone();
  }

  Future<void> _loadCurrentPhone() async {
    final phone = await _getCurrentPhone();
    if (!mounted) return;
    setState(() => _currentPhone = phone);
  }

  String _normalizePhone(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

  String _maskPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return '+971 ••• ••• •••';
    }

    final digits = _normalizePhone(phone);
    if (digits.length <= 2) {
      return '+971 $digits';
    }
    if (digits.length <= 4) {
      return '+971 ${digits.substring(0, digits.length)}';
    }
    if (digits.length <= 8) {
      final first = digits.substring(0, 2);
      return '+971 $first ••• •••';
    }

    final first = digits.substring(0, 2);
    final last = digits.substring(digits.length - 2);
    return '+971 $first ••• ••• $last';
  }

  Future<String?> _getCurrentPhone() async {
    try {
      final response = await ApiClient.instance.get<dynamic>(ApiEndpoints.authMe);
      final body = response.data is Map ? response.data as Map<String, dynamic> : <String, dynamic>{};
      final payload = body['data'] is Map ? body['data'] as Map<String, dynamic> : body;
      final user = payload['user'] is Map ? payload['user'] as Map<String, dynamic> : payload;
      final phone = [
        user['phone'],
        user['mobile'],
        user['msisdn'],
      ].firstWhere(
        (value) => value != null && value.toString().trim().isNotEmpty,
        orElse: () => null,
      );
      final result = phone?.toString().trim();
      return result != null && result.isNotEmpty ? result : null;
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _oldCodeController.dispose();
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
      _otpController.selection = const TextSelection.collapsed(offset: 6);
    } else {
      _otpController.value = TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }
    setState(() {});
  }

  Future<void> _sendCurrentPhoneOtp() async {
    final currentPhone = await _getCurrentPhone();
    if (currentPhone == null || currentPhone.isEmpty) {
      _showMessage('Current phone number not available');
      return;
    }

    setState(() => _sending = true);
    try {
      await AuthService.sendOtpToServer(recipient: currentPhone);
      if (!mounted) return;
      setState(() => _step = _Step.verifyCurrent);
      _showMessage('OTP sent to your current phone');
      _startCountdown();
    } catch (_) {
      _showMessage('Could not send OTP to current phone. Please try again.');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _verifyCurrentPhoneOtp() async {
    final oldCode = _oldCodeController.text.trim();
    if (oldCode.length != 6) {
      _showMessage('Please enter the 6-digit OTP sent to your current phone');
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await UserApi.startPhoneChange(oldCode);
      final responseData = response.data is Map ? response.data as Map<String, dynamic> : <String, dynamic>{};
      final payload = responseData['data'] is Map ? responseData['data'] as Map<String, dynamic> : responseData;
      final token = payload['changeToken']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Could not verify current phone.');
      }

      _changeToken = token;
      _oldCodeController.clear();
      if (!mounted) return;
      setState(() => _step = _Step.enterNewAfterVerify);
      _showMessage('Current phone verified. Please enter your new phone number');
    } catch (error) {
      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sendNewPhoneOtp() async {
    final phone = _normalizePhone(_phoneController.text);
    if (phone.isEmpty || phone.length < 8) {
      throw Exception('Please enter a valid new phone number');
    }
    await AuthService.sendOtpToServer(recipient: phone);
  }

  Future<void> _verifyNewPhoneOtp() async {
    final newCode = _otpController.text.trim();
    final newPhone = _normalizePhone(_phoneController.text);

    if (_changeToken == null || _changeToken!.isEmpty) {
      _showMessage('Current phone verification is required before updating the number');
      return;
    }

    if (newPhone.isEmpty || newCode.length != 6) {
      _showMessage('Please enter the 6-digit OTP sent to your new phone');
      return;
    }

    setState(() => _loading = true);
    try {
      await UserApi.confirmPhoneChangeWithToken(_changeToken!, newPhone, newCode);
      if (!mounted) return;
      setState(() => _step = _Step.success);
      _showMessage('Phone number updated successfully');
    } catch (error) {
      _showMessage(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
              onChanged: (_) => setState(() {}),
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
    final maskedPhone = _maskPhone(_currentPhone);

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
            'Current phone number',
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
            'We’ll send a verification code to your current number.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Current Phone Number',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(14),
            ),
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
                    child: Text('🇦🇪', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    maskedPhone,
                    style: const TextStyle(
                      color: Color(0xFF1B1B1B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _sending ? null : _sendCurrentPhoneOtp,
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
                      'Send OTP to current phone',
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

  Widget _buildVerifyCurrent() {
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
            'Verify your current phone number',
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
            'Enter the OTP sent to your current phone number.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 28),
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
                        controller: _oldCodeController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 6,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        onChanged: (value) {
                          final digits = value.replaceAll(RegExp(r'\D'), '');
                          _oldCodeController.value = TextEditingValue(
                            text: digits,
                            selection: TextSelection.collapsed(offset: digits.length),
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      final chars = _oldCodeController.text.padRight(6, ' ');
                      final char = chars.length > index ? chars[index] : '';
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
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _loading || _oldCodeController.text.trim().length < 6 ? null : _verifyCurrentPhoneOtp,
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
                      'Verify current phone',
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

  Widget _buildEnterNewAfterVerify() {
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Phone Number',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildPhoneInputField(),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: _sending || _normalizePhone(_phoneController.text).length < 8 ? null : () async {
                try {
                  setState(() => _sending = true);
                  await _sendNewPhoneOtp();
                  if (!mounted) return;
                  setState(() => _step = _Step.verifyNew);
                  _showMessage('OTP sent to your new phone');
                  _startCountdown();
                } catch (error) {
                  _showMessage(error.toString().replaceFirst('Exception: ', ''));
                } finally {
                  if (mounted) setState(() => _sending = false);
                }
              },
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
                      'Send OTP to new phone',
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
    final formattedPhone = _phoneController.text.trim().isEmpty
        ? '+971 50 123 4567'
        : '+971 ${_phoneController.text.trim()}';
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
                        formattedPhone,
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
                  onPressed: () => setState(() => _step = _Step.enterNewAfterVerify),
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter OTP',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 18),
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
              'Resend the OTP in $_resendSeconds sec',
              style: const TextStyle(
                color: Color(0xFF7A8497),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            )
          else
            TextButton(
              onPressed: _sending ? null : _sendNewPhoneOtp,
              child: const Text(
                'Send OTP to new phone',
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
              onPressed: _loading || _otpController.text.trim().length < 6 ? null : _verifyNewPhoneOtp,
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
                      'Update phone number',
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
          Center(
            child: Image.asset(
              'assets/icons/checkmark.gif',
              height: 196,
              width: 196,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Phone number changed\nsuccessfully',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1B1B1B),
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your phone number has been updated successfully',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFF4D5E73),
              borderRadius: BorderRadius.circular(20),
              
              image: const DecorationImage(
                image: CachedNetworkImageProvider(
                  'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/image-3771-1788550133756-2accb0bf00a7.png',
                ),
                fit: BoxFit.cover,
                
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
                        '+971 ${_phoneController.text.trim()}',
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
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: 'https://projet-adcc-image.s3.me-central-1.amazonaws.com/content/image-3812-1788550717169-7b139e1ffc93.png',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFFEFE9FF),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFFEFE9FF),
                  child: const Icon(Icons.image_not_supported_outlined, color: Color(0xFF4D5E73)),
                ),
              ),
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
      _Step.verifyCurrent => _buildVerifyCurrent(),
      _Step.enterNewAfterVerify => _buildEnterNewAfterVerify(),
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
