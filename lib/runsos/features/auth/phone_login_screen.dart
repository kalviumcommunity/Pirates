import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/runsos_auth_service.dart';
import '../../utils/app_config.dart';
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

  bool get _localWebPhoneAuthBlocked {
    if (!kIsWeb || AppConfig.phoneAuthTestMode) {
      return false;
    }

    final host = Uri.base.host.toLowerCase();
    return host == 'localhost' || host == '127.0.0.1' || host == '0.0.0.0';
  }

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

    try {
      final challenge = await _auth.startPhoneNumberSignIn(
        phoneNumber: phone,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            phoneNumber: phone,
            verificationId: challenge.verificationId,
            isLocalDevMock: challenge.isLocalDevMock,
          ),
        ),
      );
    } on Exception catch (e) {
      if (!mounted) return;
      final message = e is FirebaseAuthException
          ? (e.message ?? 'Failed to send code.')
          : 'Failed to send code.';
      setState(() {
        _isLoading = false;
        _error = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RunSOS Login')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF08111E), Color(0xFF12324A), Color(0xFF33131C)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4B942),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.shield_moon, color: Color(0xFF1A1204)),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Fast access when it matters',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Use your phone number to enter RunSOS and keep emergency tools one tap away.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        enabled: !_localWebPhoneAuthBlocked,
                        decoration: const InputDecoration(
                          labelText: 'Phone number',
                          hintText: '+15551234567',
                          prefixIcon: Icon(Icons.phone_iphone_outlined),
                        ),
                      ),
                      if (_localWebPhoneAuthBlocked) ...[
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF16233A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF2F5D8A)),
                          ),
                          child: const Text(
                            'Local web phone sign-in is disabled for this Firebase project. Run Chrome with --dart-define-from-file=.env and use a Firebase fictional test phone number, or use a deployed domain configured in Firebase Authentication.',
                            style: TextStyle(color: Colors.white70, height: 1.4),
                          ),
                        ),
                      ],
                      if (AppConfig.phoneAuthTestMode) ...[
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0x3329B6A6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF71D6C9)),
                          ),
                          child: Text(
                            AppConfig.hasTestPhoneAuthCredentials
                                ? 'Local test mode is enabled. Use the configured test phone number and OTP from your .env-powered dart-defines.'
                                : 'Phone auth test mode is enabled. Add a Firebase fictional number and OTP to your local .env if you want reCAPTCHA-free testing.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        Text(_error!, style: const TextStyle(color: Color(0xFFFF8A8A))),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading || _localWebPhoneAuthBlocked ? null : _sendCode,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.arrow_forward_rounded),
                          label: Text(_isLoading ? 'Sending...' : 'Send OTP'),
                        ),
                      ),
                    ],
                  ),
              ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
