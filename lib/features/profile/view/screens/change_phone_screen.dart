import 'package:adcc/core/constants/cosmatic_imgs.dart';
import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/user_api.dart';
import 'package:adcc/features/auth/Services/auth_services.dart';
import 'package:adcc/features/profile/repositories/profile_repository.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/shared/widgets/app_phone_number_field.dart';
import 'package:flutter/material.dart';

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  final _newPhoneController = TextEditingController();
  final _oldOtpController = TextEditingController();
  final _newOtpController = TextEditingController();
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  
  bool _sendingOld = false;
  bool _sendingNew = false;
  bool _confirming = false;
  bool _isEditingPhone = true;
  int _resendCountdown = 0;
  String _currentPhoneDisplay = '';

  @override
  void dispose() {
    _newPhoneController.dispose();
    _oldOtpController.dispose();
    _newOtpController.dispose();
    for (var node in _otpFocusNodes) node.dispose();
    for (var controller in _otpControllers) controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _oldOtpController.addListener(() => setState(() {}));
    _newOtpController.addListener(() => setState(() {}));
    _newPhoneController.addListener(() => setState(() {}));
  }

  Future<void> _sendOtp(String phone, bool isOld) async {
    try {
      setState(() => isOld ? _sendingOld = true : _sendingNew = true);
      if (isOld) {
        try {
          final resp = await ApiClient.instance.get<dynamic>(ApiEndpoints.authMe);
          final user = (resp.data?['user'] ?? resp.data?['profile'] ?? {}) as Map<String, dynamic>;
          final currentPhone = (user['phone'] ?? user['mobile'] ?? user['msisdn'])?.toString() ?? '';
          if (currentPhone.isEmpty) throw Exception('Current phone not available');
          await AuthService.sendOtpToServer(recipient: currentPhone);
          _currentPhoneDisplay = currentPhone;
        } catch (err) {
          throw Exception('Failed to fetch current phone or send OTP');
        }
      } else {
        await AuthService.sendOtpToServer(recipient: phone);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.otp_sent_mobile_number)));
      _startResendCountdown();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send OTP')));
    } finally {
      setState(() => isOld ? _sendingOld = false : _sendingNew = false);
    }
  }

  void _startResendCountdown() {
    setState(() => _resendCountdown = 59);
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() => _resendCountdown--);
        _startResendCountdown();
      }
    });
  }

  String _getOtpValue() => _otpControllers.map((c) => c.text).join();

  Future<void> _confirm() async {
    if (_newPhoneController.text.trim().isEmpty) return;
    final newPhone = _newPhoneController.text.trim();
    final oldCode = _oldOtpController.text.trim();
    final newCode = _getOtpValue();
    
    setState(() => _confirming = true);
    try {
      final resp = await UserApi.confirmPhoneChange(newPhone, oldCode, newCode);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Phone updated')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update phone')));
    } finally {
      setState(() => _confirming = false);
    }
  }

  void _handleOtpInput(int index, String value) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Change Phone Number', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              // Logo Section
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2D1B69), Color(0xFFD946EF)],
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.phone_outlined, color: Colors.white, size: 40),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'DARRAJA',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D1B69),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Header Text
              Text(
                'Verify youre new phone number',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the OTP sent to your new phone number',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Phone Number Display Box
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Phone Number',
                          style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _newPhoneController.text.isNotEmpty 
                              ? _newPhoneController.text 
                              : '+971 50 123 4567',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _isEditingPhone = true),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF455B6B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (_isEditingPhone)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('New Phone Number', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    AppPhoneNumberField(
                      controller: _newPhoneController,
                      hintText: AppLocalizations.of(context)!.phone_number_placeholder,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sendingNew || _newPhoneController.text.trim().isEmpty
                            ? null
                            : () {
                                _sendOtp(_newPhoneController.text.trim(), false);
                                setState(() => _isEditingPhone = false);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF455B6B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _sendingNew
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                              )
                            : const Text('Send OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter OTP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
                    const SizedBox(height: 16),
                    
                    // OTP Input Boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: 50,
                          height: 56,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _otpFocusNodes[index],
                            onChanged: (value) => _handleOtpInput(index, value),
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _otpFocusNodes[index].hasFocus
                                      ? Color(0xFF455B6B)
                                      : Color(0xFFDDDDDD),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF455B6B), width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFDDDDDD), width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Resend Timer
                    Text(
                      _resendCountdown > 0 
                          ? 'Resend the OTP in $_resendCountdown sec'
                          : 'Resend OTP',
                      style: TextStyle(
                        fontSize: 13,
                        color: _resendCountdown > 0 ? Color(0xFF999999) : Color(0xFF455B6B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Verify & Continue Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _confirming || _getOtpValue().length < 6 || _newPhoneController.text.trim().isEmpty
                            ? null
                            : _confirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF455B6B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          disabledBackgroundColor: Color(0xFFCCCCCC),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _confirming
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                              )
                            : const Text('Verify & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}