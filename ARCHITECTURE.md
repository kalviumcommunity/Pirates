        # System Overview

        **Project:** RunSOS
        Emergency & Live Community Alert System for runners and cyclists.

        ## Tech Stack

        * Flutter (UI)
        * Dart
        * Firebase Authentication
        * Cloud Firestore
        * Firebase Storage
        * Firebase Cloud Messaging (optional)
        * Cloud Functions (optional)

        ---

        ## High-Level Architecture

        ```
        Flutter App
            ↓
        Firebase Authentication
            ↓
        Cloud Firestore ←→ Firebase Storage
            ↓
        Push Notifications (FCM)
        ```

        ---

        ## Directory Structure

        ```
        lib/
        ┣ main.dart
        ┣ screens/
        ┃ ┣ login_screen.dart
        ┃ ┣ home_screen.dart
        ┃ ┣ alert_screen.dart
        ┣ widgets/
        ┣ services/
        ┃ ┣ auth_service.dart
        ┃ ┣ firestore_service.dart
        ┃ ┗ storage_service.dart
        ┣ models/
        ┃ ┗ alert_model.dart
        ┗ utils/
        ```

        ---

        ## Data Flow

        Mermaid diagram (GitHub supports this):

        ```mermaid
        flowchart TD
        User --> FlutterApp
        FlutterApp --> FirebaseAuth
        FlutterApp --> Firestore
        FlutterApp --> Storage
        Firestore --> CommunityUsers
        ```

        ---
# RunSOS Architecture

RunSOS is an Emergency & Live Safety System for runners/cyclists/solo outdoor users.

## Core Idea

- **One-tap SOS** creates an emergency event and shares live location.
- **Live tracking** continuously updates the user’s location in **Firebase Realtime Database**.
- **Emergency contacts** receive **push notifications via FCM** (and SMS fallback from the sender device).

## Tech Stack

- Flutter (Material 3, dark theme)
- Firebase Authentication (Phone OTP)
- Cloud Firestore (profiles, emergency contacts, SOS events, FCM tokens)
- Firebase Realtime Database (live location stream)
- Firebase Cloud Messaging (push notifications)
- Google Maps (map view)

## High-Level Architecture

```text
Flutter App
    ├─ Firebase Auth (Phone OTP)
    ├─ Firestore
    │   ├─ users/{uid} (profile)
    │   ├─ users/{uid}/emergencyContacts (contacts)
    │   ├─ users/{uid}/fcmTokens (device tokens)
    │   ├─ phone_index/{e164} → uid (contact lookup)
    │   └─ sos_events/{eventId} (SOS metadata)
    ├─ Realtime Database
    │   └─ locations/{uid} (live position)
    └─ FCM
            └─ Cloud Function trigger on sos_events/* sends push to contacts
```

## Screen Flow

```text
Login (phone OTP)
    → Profile setup (name/photo/blood group + emergency contacts)
    → Home (SOS button + start/stop tracking)
    → Run Mode (tracking + share tracking code)
    → SOS (event created + contacts notified + map link)
```

## App Structure (Feature-based)

The RunSOS MVP lives under `lib/runsos/`.

```text
lib/
    runsos/
        app/            # Auth gate + navigation
        features/       # Screens grouped by feature
        models/         # Plain Dart models
        services/       # Firebase + device integrations
        theme/          # Dark safety theme
        utils/          # SMS helper etc
        widgets/        # SOS button etc
```

## Data Flow (MVP)

```mermaid
flowchart TD
    A[User taps SOS] --> B[Get current GPS position]
    B --> C[Create Firestore sos_events doc]
    C --> D[Cloud Function fires]
    D --> E[Resolve emergency contacts]
    E --> F[Send FCM pushes to contacts]
    A --> G[Update RTDB locations/{uid} isSosActive=true]
    H[Contacts open push] --> I[Open Live Map screen]
    I --> J[Listen to RTDB locations/{uid}]
```

## Security Model (Design)

- Users can write **their own** profile and location.
- Emergency contacts can **read** a runner’s live location *only when explicitly shared* (V1 recommended via shareable link or per-contact grants).
- In MVP code, location reads are shown via a tracking UID; rules should restrict this.

Practical recommendation for V1:

- Introduce `location_shares/{uid}/viewers/{viewerUid}` grants and enforce RTDB reads accordingly.

## Notes About This Repo

This workspace contains the Dart code and Firebase/Cloud Function skeletons.
To run on a device/emulator you also need the usual Flutter platform folders (`android/`, `ios/`) and Firebase config files (e.g. `google-services.json`).
