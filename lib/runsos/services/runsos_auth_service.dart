import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RunSosAuthService {
  final FirebaseAuth _auth;

  RunSosAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() => _auth.signOut();

  Future<void> startPhoneNumberSignIn({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException error) onFailed,
    required void Function(String verificationId) onAutoRetrievalTimeout,
  }) async {
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
      verificationFailed: onFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: onAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> verifySmsCode({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return _auth.signInWithCredential(credential);
  }
}
