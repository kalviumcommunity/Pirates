import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../utils/app_config.dart';

class PhoneSignInChallenge {
  final String? verificationId;
  final bool isLocalDevMock;

  const PhoneSignInChallenge({
    this.verificationId,
    this.isLocalDevMock = false,
  });
}

class RunSosAuthService {
  final FirebaseAuth _auth;
  static ConfirmationResult? _webConfirmationResult;

  RunSosAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() => _auth.signOut();

  Future<PhoneSignInChallenge> startPhoneNumberSignIn({
    required String phoneNumber,
  }) async {
    try {
      if (kIsWeb) {
        if (_isLocalWebHost && AppConfig.phoneAuthTestMode) {
          final expectedPhone = AppConfig.testPhoneNumber.trim();
          if (!AppConfig.hasTestPhoneAuthCredentials || expectedPhone.isEmpty) {
            throw FirebaseAuthException(
              code: 'local-web-test-mode-misconfigured',
              message: 'Local web test mode is enabled, but the test phone number or OTP is missing from your dart-defines.',
            );
          }

          if (phoneNumber.trim() != expectedPhone) {
            throw FirebaseAuthException(
              code: 'local-web-test-phone-mismatch',
              message: 'Use the configured local test phone number: $expectedPhone',
            );
          }

          return const PhoneSignInChallenge(isLocalDevMock: true);
        }

        if (_isLocalWebHost && !AppConfig.phoneAuthTestMode) {
          throw FirebaseAuthException(
            code: 'local-web-phone-auth-requires-test-mode',
            message: 'Phone auth from localhost is not configured for this project. '
                'For local web testing, run Chrome with --dart-define-from-file=.env and use a Firebase fictional test phone number. '
                'For real phone auth, run the app from a deployed domain configured in Firebase Authentication.',
          );
        }

        _webConfirmationResult = await _auth.signInWithPhoneNumber(phoneNumber);
        return const PhoneSignInChallenge();
      }

      final completer = Completer<PhoneSignInChallenge>();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          try {
            await _auth.signInWithCredential(credential);
          } catch (e) {
            debugPrint('Auto verification sign-in failed: $e');
          }
        },
        verificationFailed: (error) {
          if (!completer.isCompleted) {
            completer.completeError(_normalizePhoneAuthError(error));
          }
        },
        codeSent: (verificationId, resendToken) {
          if (!completer.isCompleted) {
            completer.complete(
              PhoneSignInChallenge(verificationId: verificationId),
            );
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          if (!completer.isCompleted) {
            completer.complete(
              PhoneSignInChallenge(verificationId: verificationId),
            );
          }
        }
      );

      return completer.future;
    } on FirebaseAuthException catch (error) {
      throw _normalizePhoneAuthError(error);
    }
  }

  Future<UserCredential> verifySmsCode({
    String? verificationId,
    required String smsCode,
    bool isLocalDevMock = false,
  }) async {
    if (isLocalDevMock) {
      final expectedCode = AppConfig.testSmsCode.trim();
      if (expectedCode.isEmpty) {
        throw FirebaseAuthException(
          code: 'local-web-test-code-missing',
          message: 'No local test OTP is configured in your dart-defines.',
        );
      }

      if (smsCode.trim() != expectedCode) {
        throw FirebaseAuthException(
          code: 'invalid-verification-code',
          message: 'That OTP does not match the configured local test code.',
        );
      }

      try {
        return await _auth.signInAnonymously();
      } on FirebaseAuthException catch (error) {
        if (error.code == 'operation-not-allowed') {
          throw FirebaseAuthException(
            code: error.code,
            message: 'Enable Anonymous sign-in in Firebase Authentication to use the local dev OTP flow.',
          );
        }
        rethrow;
      }
    }

    if (kIsWeb) {
      final confirmationResult = _webConfirmationResult;
      if (confirmationResult == null) {
        throw FirebaseAuthException(
          code: 'missing-confirmation-result',
          message: 'Phone sign-in session expired. Request a new OTP and try again.',
        );
      }

      try {
        final credential = await confirmationResult.confirm(smsCode);
        _webConfirmationResult = null;
        return credential;
      } on FirebaseAuthException catch (error) {
        throw _normalizePhoneAuthError(error);
      }
    }

    if (verificationId == null || verificationId.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-verification-id',
        message: 'Phone sign-in session expired. Request a new OTP and try again.',
      );
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return _auth.signInWithCredential(credential);
  }

  FirebaseAuthException _normalizePhoneAuthError(FirebaseAuthException error) {
    if (!kIsWeb) {
      return error;
    }

    final summary = '${error.code} ${error.message ?? ''}'.toLowerCase();
    if (summary.contains('recaptcha') ||
        summary.contains('operation-not-allowed') ||
        summary.contains('invalid-app-credential') ||
        summary.contains('internal-error')) {
      return FirebaseAuthException(
        code: error.code,
        message: 'Web phone auth is not fully configured for this Firebase project. '
            'Enable Authentication > Sign-in method > Phone, make sure localhost is allowed in Authentication domains, '
            'and for local testing run Chrome with --dart-define-from-file=.env using a Firebase fictional test number.',
      );
    }

    return error;
  }

  bool get _isLocalWebHost {
    final host = Uri.base.host.toLowerCase();
    return host == 'localhost' || host == '127.0.0.1' || host == '0.0.0.0';
  }
}
