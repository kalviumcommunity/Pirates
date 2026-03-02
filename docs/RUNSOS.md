# RunSOS (MVP) — Emergency + Live Safety System

## Setup (Keys & Credentials)

See [docs/SETUP_KEYS.md](docs/SETUP_KEYS.md) for where to pull Firebase config, Google Maps API keys, and FCM setup.

## What’s Implemented in This Workspace

- Phone OTP sign-in (Firebase Auth)
- Profile setup
  - Name
  - Photo (Firebase Storage upload)
  - Blood group (optional)
  - Emergency contacts (Firestore)
- Home
  - Large SOS button
  - Start/Stop tracking
- SOS
  - Creates a Firestore `sos_events` document
  - Captures current location and generates a Google Maps link
  - SMS fallback: opens the user’s SMS app with a prefilled alert message
- Live tracking
  - Continuously writes location updates to Realtime Database `locations/{uid}`
  - Map viewer screen that reads `locations/{uid}` and renders it on Google Maps
- FCM integration
  - Device token registration to Firestore
  - Foreground notifications via local notifications
  - Cloud Function skeleton (Firestore trigger) to send push notifications to contacts

## Screen Flow

Login → Profile → Home → Run Mode → SOS

Notes:
- Contacts who are also RunSOS users get push notifications (via the Cloud Function).
- Contacts who are not app users can still be alerted using SMS fallback.

## Recommended Flutter Packages

Already added to `pubspec.yaml`:

- `firebase_core`, `firebase_auth`, `cloud_firestore`
- `firebase_database` (live location stream)
- `firebase_messaging` + `flutter_local_notifications` (push + foreground display)
- `google_maps_flutter` (map UI)
- `geolocator` (location)
- `permission_handler` (runtime permissions)
- `firebase_storage` + `image_picker` (profile photo)
- `share_plus` (share run mode tracking code)
- `url_launcher` (SMS fallback)

## Firebase Data Model (MVP)

### Firestore

`users/{uid}`
```json
{
  "uid": "...",
  "phoneNumber": "+15551234567",
  "name": "Asha",
  "photoUrl": "https://...",
  "bloodGroup": "O+",
  "createdAt": "serverTimestamp",
  "updatedAt": "...",
  "lastSeenAt": "serverTimestamp"
}
```

`users/{uid}/emergencyContacts/{contactId}`
```json
{
  "name": "Mom",
  "phoneNumber": "+15550001111",
  "relationship": "Mother",
  "createdAt": "serverTimestamp",
  "updatedAt": "serverTimestamp"
}
```

`users/{uid}/fcmTokens/{token}`
```json
{
  "platform": "android",
  "updatedAt": "serverTimestamp"
}
```

`phone_index/{e164Phone}`
```json
{
  "uid": "resolvedUid",
  "updatedAt": "serverTimestamp"
}
```

`sos_events/{eventId}`
```json
{
  "uid": "senderUid",
  "userName": "Asha",
  "userPhone": "+15551234567",
  "lat": 12.9716,
  "lng": 77.5946,
  "mapsUrl": "https://www.google.com/maps?q=12.97,77.59",
  "status": "active",
  "createdAt": "serverTimestamp"
}
```

### Realtime Database

`locations/{uid}`
```json
{
  "lat": 12.9716,
  "lng": 77.5946,
  "accuracy": 8.0,
  "speed": 1.2,
  "heading": 90.0,
  "isTracking": true,
  "isRunMode": true,
  "isSosActive": true,
  "activeSosId": "eventId",
  "updatedAt": 1710000000000
}
```

## Security Rules (Recommended Direction)

MVP code focuses on the client and schema. For a real deployment:

- Firestore: users can read/write their own profile, contacts, and tokens.
- Realtime DB: users can write their own location.
- Location reads should be restricted (V1 suggestion):
  - Add `location_shares/{runnerUid}/viewers/{viewerUid}` grants and only allow those viewers to read.

## Cloud Function (FCM sending)

See `functions/index.js`:

- Trigger: on Firestore create `sos_events/{eventId}`
- Reads sender’s `emergencyContacts`
- Uses `phone_index` to map contact phone → contact uid
- Reads contact FCM tokens and sends multicast push with `data.trackUid = senderUid`

## V1 Roadmap (Planned)

- Background location tracking
- 5-second countdown before SOS + cancel
- Low battery alerts
- Proper shareable tracking link (Firebase Dynamic Links + web viewer)

## Advanced Roadmap (Planned)

- Auto SOS on no-movement / safety timer
- Fall detection using sensors
- Nearby community helper/volunteer mode
- Unsafe-area heatmap
