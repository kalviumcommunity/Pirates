import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../services/runsos_auth_service.dart';
import '../../services/user_profile_service.dart';
import '../../utils/app_config.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String? verificationId;
  final bool isLocalDevMock;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    this.verificationId,
    this.isLocalDevMock = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _auth = RunSosAuthService();
  final _profiles = UserProfileService();
  final _codeController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.length < 4) {
      setState(() => _error = 'Enter the OTP.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cred = await _auth.verifySmsCode(
        verificationId: widget.verificationId,
        smsCode: code,
        isLocalDevMock: widget.isLocalDevMock,
      );

      final user = cred.user;
      if (user != null) {
        if (!widget.isLocalDevMock) {
          await _profiles.upsertPhoneIndex(
            e164Phone: widget.phoneNumber,
            uid: user.uid,
          );

          final existing = await _profiles.getProfile(user.uid);
          if (existing == null) {
            await _profiles.upsertProfile(
              profile: UserProfile(
                uid: user.uid,
                name: '',
                phoneNumber: user.phoneNumber ?? widget.phoneNumber,
              ),
            );
          }
        }
      }

      if (!mounted) return;
      if (widget.isLocalDevMock && AppConfig.phoneAuthTestMode) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        return;
      }

      Navigator.popUntil(context, (r) => r.isFirst);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.message ?? 'Verification failed.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Verification failed.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF07111E), Color(0xFF112743), Color(0xFF1E0F21)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verify access',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.isLocalDevMock
                            ? 'Enter the local test OTP for ${widget.phoneNumber}'
                            : 'Code sent to ${widget.phoneNumber}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'OTP code',
                          prefixIcon: Icon(Icons.password_rounded),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        Text(_error!, style: const TextStyle(color: Color(0xFFFF8A8A))),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _verify,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.verified_user_outlined),
                          label: Text(_isLoading ? 'Verifying...' : 'Verify & Continue'),
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
