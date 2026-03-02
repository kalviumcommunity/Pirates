import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
  ///   --dart-define=FIREBASE_STORAGE_BUCKET=...
  static FirebaseOptions get web {
    const apiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
    const appId = String.fromEnvironment('FIREBASE_WEB_APP_ID');
    const messagingSenderId =
        String.fromEnvironment('FIREBASE_WEB_MESSAGING_SENDER_ID');
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
    const authDomain = String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN');
    const storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

    final missing = <String>[];
    if (apiKey.isEmpty) missing.add('FIREBASE_WEB_API_KEY');
    if (appId.isEmpty) missing.add('FIREBASE_WEB_APP_ID');
    if (messagingSenderId.isEmpty) missing.add('FIREBASE_WEB_MESSAGING_SENDER_ID');
    if (projectId.isEmpty) missing.add('FIREBASE_PROJECT_ID');
    if (authDomain.isEmpty) missing.add('FIREBASE_WEB_AUTH_DOMAIN');
    if (storageBucket.isEmpty) missing.add('FIREBASE_STORAGE_BUCKET');

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

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain,
      storageBucket: storageBucket,
    );
  }
}
