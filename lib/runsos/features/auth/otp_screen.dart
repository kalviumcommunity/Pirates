import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../services/runsos_auth_service.dart';
import '../../services/user_profile_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
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
      );

      final user = cred.user;
      if (user != null) {
        await _profiles.upsertPhoneIndex(e164Phone: widget.phoneNumber, uid: user.uid);

        // Create an initial profile if missing.
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

      if (!mounted) return;
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Code sent to ${widget.phoneNumber}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'OTP code'),
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
                onPressed: _isLoading ? null : _verify,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verify & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
