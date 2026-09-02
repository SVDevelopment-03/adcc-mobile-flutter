import 'dart:async';

import 'package:adcc/core/services/api_client.dart';
import 'package:adcc/core/constants/api_endpoints.dart';
import 'package:adcc/core/services/user_api.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/shared/widgets/app_phone_number_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum _Step { verifyOld, enterNew, verifyNew, success }

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  _Step _step = _Step.verifyOld;

  final _newPhoneController = TextEditingController();
  final _oldOtpController = TextEditingController();
  final _newOtpController = TextEditingController();

  String? _changeToken;
  bool _loading = false;
  bool _sending = false;
  int _oldResendSeconds = 0;
  int _newResendSeconds = 0;
  Timer? _oldResendTimer;
  Timer? _newResendTimer;

  @override
  void dispose() {
    _newPhoneController.dispose();
    _oldOtpController.dispose();
    _newOtpController.dispose();
    _oldResendTimer?.cancel();
    _newResendTimer?.cancel();
    super.dispose();
  }

  Future<void> _sendOtp(String phone) async {
    setState(() => _sending = true);
    try {
      String recipient = phone;
      if (phone == 'current') {
        // fetch current user profile to obtain phone
        final resp = await ApiClient.instance.get(ApiEndpoints.authMe);
        final current = (resp.data is Map && resp.data['data'] is Map)
            ? (resp.data['data']['phone'] as String?)
            : null;
        if (current == null) throw Exception('Current phone not available');
        recipient = current;
      }
      // TODO: Client-side OTP send call — posts to /v1/otp/send on server
      // Server will send SMS to the configured gateway (Nexus/Twilio/etc.).
      await ApiClient.instance.post(ApiEndpoints.otpSend, data: {'recipient': recipient});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.otp_sent)));
      if (phone == 'current') _startOldResendCountdown();
      if (phone != 'current') _startNewResendCountdown();
    } catch (e) {
      // Log detailed error for debugging and show mapped message
      debugPrint('Send OTP error: $e');
      if (e is DioException) debugPrint('Send OTP response: ${e.response?.data}');
      _showError(e, AppLocalizations.of(context)!.failed_send_otp);
    } finally {
      setState(() => _sending = false);
    }
  }

  void _startOldResendCountdown() {
    _oldResendTimer?.cancel();
    setState(() => _oldResendSeconds = 60);
    _oldResendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _oldResendSeconds -= 1;
        if (_oldResendSeconds <= 0) {
          _oldResendTimer?.cancel();
        }
      });
    });
  }

  void _startNewResendCountdown() {
    _newResendTimer?.cancel();
    setState(() => _newResendSeconds = 60);
    _newResendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _newResendSeconds -= 1;
        if (_newResendSeconds <= 0) {
          _newResendTimer?.cancel();
        }
      });
    });
  }

  String _maskPhone(String phone) {
    if (phone.isEmpty) return '';
    // keep leading +country and last 4 digits
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 4) return phone;
    final last4 = digits.substring(digits.length - 4);
    final prefix = phone.startsWith('+') ? '+' + digits.substring(0, (digits.length - 4) > 3 ? 3 : digits.length - 4) : '';
    return '$prefix •••• $last4';
  }

  void _showError(Object e, String fallback) {
    String msg = fallback;
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final m = data['message'];
        if (m is String && m.isNotEmpty) msg = m;
        else if (m is List && m.isNotEmpty) msg = m.first.toString();
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _verifyOld() async {
    final oldCode = _oldOtpController.text.trim();
    if (oldCode.isEmpty) return;
    setState(() => _loading = true);
    try {
      final resp = await UserApi.startPhoneChange(oldCode);
      final data = resp.data;
      final changeToken = data['data']?['changeToken'] ?? data['changeToken'];
      setState(() {
        _changeToken = changeToken as String?;
        _step = _Step.enterNew;
      });
    } catch (e) {
      _showError(e, AppLocalizations.of(context)!.failed_verify_current);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _sendNewOtp() async {
    final phone = _newPhoneController.text.trim();
    if (phone.isEmpty) return;
    await _sendOtp(phone);
    setState(() => _step = _Step.verifyNew);
  }

  Future<void> _confirmNew() async {
    final newCode = _newOtpController.text.trim();
    final newPhone = _newPhoneController.text.trim();
    if (newCode.isEmpty || newPhone.isEmpty || _changeToken == null) return;
    setState(() => _loading = true);
    try {
      await UserApi.confirmPhoneChangeWithToken(_changeToken!, newPhone, newCode);
      setState(() => _step = _Step.success);
    } catch (e) {
      _showError(e, AppLocalizations.of(context)!.failed_confirm_new);
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildVerifyOld() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.change_phone_verify_current, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(AppLocalizations.of(context)!.change_phone_verify_explainer),
        const SizedBox(height: 12),
        TextField(controller: _oldOtpController, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.enter_otp_label)),
        const SizedBox(height: 12),
        Row(children: [
          ElevatedButton(onPressed: _loading ? null : _verifyOld, child: _loading ? const CircularProgressIndicator() : Text(AppLocalizations.of(context)!.verify_otp)),
          const SizedBox(width: 12),
          _oldResendSeconds > 0
              ? TextButton(onPressed: null, child: Text(AppLocalizations.of(context)!.resend_in('$_oldResendSeconds')))
              : ElevatedButton(onPressed: _sending ? null : () => _sendOtp('current'), child: _sending ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator()) : Text(AppLocalizations.of(context)!.send_otp)),
        ])
      ],
    );
  }

  Widget _buildEnterNew() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.enter_new_phone_header, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        AppPhoneNumberField(controller: _newPhoneController),
        const SizedBox(height: 12),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: _sending ? null : _sendNewOtp, child: _sending ? const CircularProgressIndicator() : Text(AppLocalizations.of(context)!.send_otp))),
      ],
    );
  }

  Widget _buildVerifyNew() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.verify_new_phone_header, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(AppLocalizations.of(context)!.verify_new_phone_explainer.replaceFirst('{phone}', _newPhoneController.text)) ,
        const SizedBox(height: 12),
        TextField(controller: _newOtpController, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.enter_otp_label)),
        const SizedBox(height: 12),
        Row(children: [
          ElevatedButton(onPressed: _loading ? null : _confirmNew, child: _loading ? const CircularProgressIndicator() : Text(AppLocalizations.of(context)!.verify_otp)),
          const SizedBox(width: 12),
          _newResendSeconds > 0
              ? TextButton(onPressed: null, child: Text(AppLocalizations.of(context)!.resend_in('$_newResendSeconds')))
              : TextButton(onPressed: _sending ? null : _sendNewOtp, child: Text(AppLocalizations.of(context)!.send_otp)),
          const SizedBox(width: 8),
          TextButton(onPressed: () => setState(() => _step = _Step.enterNew), child: Text(AppLocalizations.of(context)!.edit_number)),
        ])
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 72),
        const SizedBox(height: 12),
        Text(AppLocalizations.of(context)!.phone_changed_success, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(_maskPhone(_newPhoneController.text)),
        const SizedBox(height: 18),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.done))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_step) {
      case _Step.verifyOld:
        content = _buildVerifyOld();
        break;
      case _Step.enterNew:
        content = _buildEnterNew();
        break;
      case _Step.verifyNew:
        content = _buildVerifyNew();
        break;
      case _Step.success:
        content = _buildSuccess();
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Change Phone')),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: content),
    );
  }
}
