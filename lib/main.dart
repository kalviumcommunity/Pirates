import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'runsos/runsos_app.dart';
import 'firebase_options.dart';
import 'runsos/utils/app_config.dart';

FirebaseOptions? _firebaseOptionsOrNull() {
  try {
    return DefaultFirebaseOptions.currentPlatform;
  } on UnsupportedError {
    return null;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: _firebaseOptionsOrNull(),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: _firebaseOptionsOrNull(),
  );

  if (kIsWeb) {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
      webExperimentalForceLongPolling: true,
    );
  }

  if (AppConfig.useFirebaseAuthEmulator) {
    await FirebaseAuth.instance.useAuthEmulator(
      AppConfig.authEmulatorHost,
      AppConfig.authEmulatorPort,
    );
  }

  if (AppConfig.useFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator(
      AppConfig.firestoreEmulatorHost,
      AppConfig.firestoreEmulatorPort,
    );
  }

  if (AppConfig.useDatabaseEmulator) {
    FirebaseDatabase.instance.useDatabaseEmulator(
      AppConfig.databaseEmulatorHost,
      AppConfig.databaseEmulatorPort,
    );
  }

  if (kIsWeb && AppConfig.phoneAuthTestMode) {
    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: true,
      phoneNumber: AppConfig.hasTestPhoneAuthCredentials
          ? AppConfig.testPhoneNumber.trim()
          : null,
      smsCode: AppConfig.hasTestPhoneAuthCredentials
          ? AppConfig.testSmsCode.trim()
          : null,
    );
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const RunSosApp());
}
