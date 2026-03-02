# RunSOS — Where to get credentials, APIs, and keys

This repo’s Flutter code uses Firebase SDKs (not raw REST APIs), so most “credentials” are obtained by registering your app in the Firebase Console and adding the generated config files.

## 1) Firebase (Auth / Firestore / Realtime DB / Storage / FCM)

### What you need to create/download

1. Create a Firebase project
   - Firebase Console → **Add project**

2. Enable Firebase products
   - **Authentication** → Sign-in method → enable **Phone**
   - **Firestore Database** → Create database
   - **Realtime Database** → Create database
   - **Storage** → Get started
   - **Cloud Messaging** (FCM) is available once Firebase is set up

3. Register your mobile apps (this is where the main “keys” come from)

- Firebase Console → Project settings → **Your apps**

**Android app**
- Add Android app → enter your package name (e.g. `com.example.runsos`)
- Download **google-services.json**
- Place it at: `android/app/google-services.json`

**iOS app**
- Add iOS app → enter your bundle ID
- Download **GoogleService-Info.plist**
- Place it at: `ios/Runner/GoogleService-Info.plist`

Important: this workspace currently doesn’t include `android/` and `ios/` folders. You’ll need to generate them first (typical ways):
- Create a normal Flutter app (`flutter create`) and copy `lib/` + `assets/` into it, OR
- If this folder is meant to be a Flutter project root, run `flutter create .` once.

### Phone OTP requirement (Android certificates)

For Phone Auth to work reliably on Android you must add SHA fingerprints:

- Firebase Console → Project settings → Your apps → Android app → **SHA certificate fingerprints**
- Add **SHA-1** and **SHA-256** from your keystore

Typical commands (on your machine):
- Debug keystore SHA: `keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android`

### Do you need a “Firebase API key”?

- The Firebase client config contains an API key, but it’s not treated like a secret in mobile apps.
- For the Flutter SDK flow, you do **not** manually paste this key into Dart code; you use the config files above.

If you’re using REST calls (like the Postman collection in this repo), then you’ll need the **Web API Key**:
- Firebase Console → Project settings → General → **Web API Key**
- Put it in your Postman Environment as: `FIREBASE_WEB_API_KEY`

## 2) Google Maps API key (for the map screen)

### Where to get it

- Google Cloud Console → APIs & Services → **Library**
  - Enable: **Maps SDK for Android** and/or **Maps SDK for iOS**
- Google Cloud Console → APIs & Services → **Credentials**
  - Create an **API key**

### Where to put it

Once you have `android/` and `ios/` folders in your project:

**Android**
- Put it in `android/app/src/main/AndroidManifest.xml` as:
  - `<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_KEY" />`

**iOS**
- Common patterns:
  - Provide it in `ios/Runner/AppDelegate.swift` using `GMSServices.provideAPIKey("YOUR_KEY")`, OR
  - Configure it via Info.plist depending on your iOS setup

### Restrict your Maps key

- Restrict by **Android app** (package name + SHA-1) and/or **iOS app** (bundle ID)
- Restrict by API: allow only Maps SDK(s)

## 3) FCM (Push notifications)

### Client-side

No extra secret key is required in the app.
- When the app runs, it gets an FCM registration token and saves it under:
  - `users/{uid}/fcmTokens/{token}` (Firestore)

### Server-side sending

If you send push from **Cloud Functions using firebase-admin**, you typically do **not** download a service account key.
- The function runs with a default service account in your Firebase project.

If you send from an **external server** (not Cloud Functions), then you’ll need a service account credential:
- Google Cloud Console → IAM & Admin → Service Accounts → create key (JSON)
- Keep it private (never commit it).

## 4) SMS fallback

In the current MVP, SMS fallback is done by opening the phone’s SMS composer (device UI).
- No API key is required.

If you want **automatic SMS sending** (without user interaction), that’s not supported directly by Firebase.
You’d integrate an SMS provider (e.g. Twilio) on a backend and then you will have provider keys/secrets.

## 5) Where to store keys safely

- Don’t hardcode secrets in Dart.
- Don’t commit service account JSON files.
- For Maps key, prefer platform-specific config + restrictions.

### Local development (this repo)

- Use a local `.env` file at the repo root for your own reference (ignored by git).
  - Template: `.env.example` (safe to commit)
  - Real file: `.env` (DO NOT commit)

### Flutter app

- Prefer build-time defines for non-secret config:
  - Example: `flutter run --dart-define=API_BASE_URL=https://example.com`
- Avoid putting real secrets in Flutter builds (mobile apps can be reverse engineered).

#### Flutter Web + Firebase (important)

For Flutter Web, `Firebase.initializeApp()` needs explicit `FirebaseOptions`.

This repo expects you to provide web config via `--dart-define` (or generate via FlutterFire CLI).

Required defines:
- `FIREBASE_WEB_API_KEY`
- `FIREBASE_WEB_APP_ID`
- `FIREBASE_WEB_MESSAGING_SENDER_ID`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_WEB_AUTH_DOMAIN`
- `FIREBASE_STORAGE_BUCKET`

Where to get them:
- Firebase Console -> Project settings -> Your apps -> Web app -> SDK setup

### Cloud Functions (Node)

- Don’t store secrets in `functions/index.js`.
- For local experimentation you can use `functions/.env` (ignored by git).
- For real deployments, use Firebase/Google Cloud secret management (so secrets aren’t in source control).

### Postman

- Don’t paste keys directly into collection URLs.
- Use a Postman Environment:
  - Example file: `docs/postman_environment.example.json`
  - Variables used by the collection: `FIREBASE_WEB_API_KEY`, `FIREBASE_PROJECT_ID`, `FIREBASE_STORAGE_BUCKET`, `FIREBASE_ID_TOKEN`

