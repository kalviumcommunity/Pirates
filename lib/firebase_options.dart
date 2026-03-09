import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

const _defaultWebApiKey = 'AIzaSyBQZ_S1GXfnrZj7mG2SkhdO5RKVfmxsX-A';
const _defaultWebAppId = '1:480154772273:web:64df43c066fd4c343ac610';
const _defaultWebMessagingSenderId = '480154772273';
const _defaultProjectId = 'runsos';
const _defaultWebAuthDomain = 'runsos.firebaseapp.com';
const _defaultStorageBucket = 'runsos.firebasestorage.app';
const _defaultDatabaseUrl = 'https://runsos-default-rtdb.firebaseio.com';

/// Firebase options for platforms that require explicit configuration.
///
/// For Web: you MUST provide options.
///
/// Recommended: generate this file via FlutterFire CLI:
///   `dart pub global activate flutterfire_cli`
///   `flutterfire configure`
///
/// If you don't use FlutterFire CLI, paste values from:
/// Firebase Console -> Project settings -> Your apps -> Web app -> SDK setup.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform in this repo. '
          'For Android/iOS, prefer adding google-services.json / GoogleService-Info.plist. '
          'For full multi-platform support, run `flutterfire configure`.',
        );
    }
  }

  /// Web Firebase config.
  ///
  /// Provide these at build/run time (recommended) OR generate via FlutterFire CLI.
  ///
  /// Example:
  /// flutter run -d chrome \
  ///   --dart-define=FIREBASE_WEB_API_KEY=... \
  ///   --dart-define=FIREBASE_WEB_APP_ID=... \
  ///   --dart-define=FIREBASE_WEB_MESSAGING_SENDER_ID=... \
  ///   --dart-define=FIREBASE_PROJECT_ID=... \
  ///   --dart-define=FIREBASE_WEB_AUTH_DOMAIN=... \
  ///   --dart-define=FIREBASE_STORAGE_BUCKET=... \
  ///   --dart-define=FIREBASE_DATABASE_URL=...
  static FirebaseOptions get web {
    const apiKey = String.fromEnvironment(
      'FIREBASE_WEB_API_KEY',
      defaultValue: _defaultWebApiKey,
    );
    const appId = String.fromEnvironment(
      'FIREBASE_WEB_APP_ID',
      defaultValue: _defaultWebAppId,
    );
    const messagingSenderId = String.fromEnvironment(
      'FIREBASE_WEB_MESSAGING_SENDER_ID',
      defaultValue: _defaultWebMessagingSenderId,
    );
    const projectId = String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: _defaultProjectId,
    );
    const authDomain = String.fromEnvironment(
      'FIREBASE_WEB_AUTH_DOMAIN',
      defaultValue: _defaultWebAuthDomain,
    );
    const storageBucket = String.fromEnvironment(
      'FIREBASE_STORAGE_BUCKET',
      defaultValue: _defaultStorageBucket,
    );
    const databaseUrl = String.fromEnvironment(
      'FIREBASE_DATABASE_URL',
      defaultValue: _defaultDatabaseUrl,
    );

    final missing = <String>[];
    if (apiKey.isEmpty) missing.add('FIREBASE_WEB_API_KEY');
    if (appId.isEmpty) missing.add('FIREBASE_WEB_APP_ID');
    if (messagingSenderId.isEmpty) missing.add('FIREBASE_WEB_MESSAGING_SENDER_ID');
    if (projectId.isEmpty) missing.add('FIREBASE_PROJECT_ID');
    if (authDomain.isEmpty) missing.add('FIREBASE_WEB_AUTH_DOMAIN');
    if (storageBucket.isEmpty) missing.add('FIREBASE_STORAGE_BUCKET');
    if (databaseUrl.isEmpty) missing.add('FIREBASE_DATABASE_URL');

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing Firebase Web configuration for: ${missing.join(', ')}.\n'
        'Fix options:\n'
        '1) Run FlutterFire CLI: `flutterfire configure` (recommended), OR\n'
        '2) Pass values via --dart-define when running/building for web.\n'
        '\nWhere to get these values:\n'
        'Firebase Console -> Project settings -> Your apps -> Web app -> SDK setup.',
      );
    }

    return const FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain,
      storageBucket: storageBucket,
      databaseURL: databaseUrl,
    );
  }
}
