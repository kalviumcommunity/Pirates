class AppConfig {
  static const trackingBaseUrl = String.fromEnvironment(
    'RUNSOS_TRACKING_BASE_URL',
    defaultValue: 'https://runsos.app/track',
  );
  static const phoneAuthTestMode = bool.fromEnvironment(
    'RUNSOS_PHONE_AUTH_TEST_MODE',
    defaultValue: false,
  );
  static const testPhoneNumber = String.fromEnvironment(
    'RUNSOS_TEST_PHONE_NUMBER',
  );
  static const testSmsCode = String.fromEnvironment(
    'RUNSOS_TEST_SMS_CODE',
  );
  static const useFirebaseEmulators = bool.fromEnvironment(
    'RUNSOS_USE_FIREBASE_EMULATORS',
    defaultValue: false,
  );
  static const useFirebaseAuthEmulatorFlag = bool.fromEnvironment(
    'RUNSOS_USE_FIREBASE_AUTH_EMULATOR',
    defaultValue: false,
  );
  static const useFirestoreEmulatorFlag = bool.fromEnvironment(
    'RUNSOS_USE_FIRESTORE_EMULATOR',
    defaultValue: false,
  );
  static const useDatabaseEmulatorFlag = bool.fromEnvironment(
    'RUNSOS_USE_DATABASE_EMULATOR',
    defaultValue: false,
  );
  static const authEmulatorHost = String.fromEnvironment(
    'RUNSOS_AUTH_EMULATOR_HOST',
    defaultValue: '127.0.0.1',
  );
  static const authEmulatorPort = int.fromEnvironment(
    'RUNSOS_AUTH_EMULATOR_PORT',
    defaultValue: 9099,
  );
  static const firestoreEmulatorHost = String.fromEnvironment(
    'RUNSOS_FIRESTORE_EMULATOR_HOST',
    defaultValue: '127.0.0.1',
  );
  static const firestoreEmulatorPort = int.fromEnvironment(
    'RUNSOS_FIRESTORE_EMULATOR_PORT',
    defaultValue: 8080,
  );
  static const databaseEmulatorHost = String.fromEnvironment(
    'RUNSOS_DATABASE_EMULATOR_HOST',
    defaultValue: '127.0.0.1',
  );
  static const databaseEmulatorPort = int.fromEnvironment(
    'RUNSOS_DATABASE_EMULATOR_PORT',
    defaultValue: 9000,
  );

  static String buildTrackingLink(String uid) {
    final base = trackingBaseUrl.endsWith('/')
        ? trackingBaseUrl.substring(0, trackingBaseUrl.length - 1)
        : trackingBaseUrl;
    return '$base?uid=$uid';
  }

  static String? extractTrackingUid(String rawInput) {
    final value = rawInput.trim();
    if (value.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(value);
    if (uri != null && (uri.hasScheme || uri.hasAuthority)) {
      final queryUid = uri.queryParameters['uid']?.trim();
      if (queryUid != null && queryUid.isNotEmpty) {
        return queryUid;
      }

      final segments = uri.pathSegments.where((segment) => segment.isNotEmpty);
      if (segments.isNotEmpty) {
        return segments.last.trim();
      }
    }

    return value;
  }

  static bool get hasTestPhoneAuthCredentials {
    return testPhoneNumber.trim().isNotEmpty && testSmsCode.trim().isNotEmpty;
  }

  static bool get useFirebaseAuthEmulator {
    return useFirebaseEmulators || useFirebaseAuthEmulatorFlag;
  }

  static bool get useFirestoreEmulator {
    return useFirebaseEmulators || useFirestoreEmulatorFlag;
  }

  static bool get useDatabaseEmulator {
    return useFirebaseEmulators || useDatabaseEmulatorFlag;
  }
}