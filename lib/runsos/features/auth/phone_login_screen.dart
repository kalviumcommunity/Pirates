import 'package:flutter/material.dart';

import '../../services/runsos_auth_service.dart';
import 'otp_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _auth = RunSosAuthService();
  final _phoneController = TextEditingController(text: '+');

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final phone = _phoneController.text.trim();
    if (!phone.startsWith('+') || phone.length < 8) {
      setState(() => _error = 'Enter phone in E.164 format (e.g. +15551234567).');
      return;
    }

    setState(() {
      _error = null;
      _isLoading = true;
    });

    await _auth.startPhoneNumberSignIn(
      phoneNumber: phone,
      codeSent: (verificationId, resendToken) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(
              phoneNumber: phone,
              verificationId: verificationId,
            ),
          ),
        );
      },
      onFailed: (e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _error = e.message ?? 'Failed to send code.';
        });
      },
      onAutoRetrievalTimeout: (verificationId) {
        // No-op for MVP.
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RunSOS Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign in with your phone number',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                hintText: '+15551234567',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendCode,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
