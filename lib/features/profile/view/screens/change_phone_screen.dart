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
  bool _sendingOld = false;
  bool _sendingNew = false;
  bool _confirming = false;

  @override
  void dispose() {
    _newPhoneController.dispose();
    _oldOtpController.dispose();
    _newOtpController.dispose();
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
        // Fetch current user phone from /v1/auth/me
        try {
          final resp = await ApiClient.instance.get<dynamic>(ApiEndpoints.authMe);
          final user = (resp.data?['user'] ?? resp.data?['profile'] ?? {}) as Map<String, dynamic>;
          final currentPhone = (user['phone'] ?? user['mobile'] ?? user['msisdn'])?.toString() ?? '';
          if (currentPhone.isEmpty) throw Exception('Current phone not available');
          await AuthService.sendOtpToServer(recipient: currentPhone);
        } catch (err) {
          throw Exception('Failed to fetch current phone or send OTP');
        }
      } else {
        await AuthService.sendOtpToServer(recipient: phone);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.otp_sent_mobile_number)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send OTP')));
    } finally {
      setState(() => isOld ? _sendingOld = false : _sendingNew = false);
    }
  }

  Future<void> _confirm() async {
    if (_newPhoneController.text.trim().isEmpty) return;
    final newPhone = _newPhoneController.text.trim();
    final oldCode = _oldOtpController.text.trim();
    final newCode = _newOtpController.text.trim();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Phone')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            AppPhoneNumberField(controller: _newPhoneController, hintText: AppLocalizations.of(context)!.phone_number_placeholder),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _sendingOld ? null : () => _sendOtp('', true),
                    child: _sendingOld ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator()) : const Text('Send OTP to current phone'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _sendingNew ? null : () => _sendOtp(_newPhoneController.text.trim(), false),
                    child: _sendingNew ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator()) : const Text('Send OTP to new phone'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(controller: _oldOtpController, decoration: InputDecoration(labelText: 'OTP for current phone')),
            const SizedBox(height: 12),
            TextField(controller: _newOtpController, decoration: InputDecoration(labelText: 'OTP for new phone')),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirming || _oldOtpController.text.trim().isEmpty || _newOtpController.text.trim().isEmpty || _newPhoneController.text.trim().isEmpty
                    ? null
                    : _confirm,
                child: _confirming ? const CircularProgressIndicator() : Text(AppLocalizations.of(context)!.confirm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
