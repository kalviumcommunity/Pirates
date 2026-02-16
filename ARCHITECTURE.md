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

    ## Firebase Integration

    ### Authentication

    * Email/Password login
    * Firebase returns ID Token
    * Token used for secure requests

    ### Firestore Collections

    ```
    users/
    alerts/
    emergency_contacts/
    ```

    Alert Document Example:

    ```
    alertId
    userId
    location
    status
    createdAt
    ```

    ---

    ## Security

    * Firebase Auth required for all operations
    * Firestore Rules:

    ```
    allow read, write: if request.auth != null;
    ```

    ---

    ## Deployment

    ### Flutter

    ```
    flutter build apk
    ```

    or

    ```
    flutter build appbundle
    ```

    ### Firebase Setup

    1. Add `google-services.json`
    2. Enable Auth + Firestore + Storage
    3. Configure Firebase project

    ---

    ## Documentation Update Checklist

    When adding a feature:

    * Update Postman Collection
    * Update ARCHITECTURE.md
    * Update Firestore structure
    * Increase version if API changes
