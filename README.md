        # RunSOS

        Emergency & Live Community Alert System for runners and cyclists.

        ## API Documentation

       git Postman Collection:
        `/docs/flutter_firebase_postman.json`

        Version: **1.0.0**
        Last Updated: **2025-11-13**
        Authentication: Firebase Token

        ---

        ## Architecture

        See: `ARCHITECTURE.md`

        ---

        ## Responsive UI – Sprint 2

        This screen demonstrates a responsive layout built using Flutter that adapts to different screen sizes, device types, and orientations.

        ### Features

        * Phone: Single-column list layout
        * Tablet/Landscape: Multi-column grid layout
        * Dynamic padding and font sizes
        * Adaptive button sizing

        ### MediaQuery Logic

        ```dart
        final width = MediaQuery.of(context).size.width;
        bool isTablet = width > 600;
        ```

        ### LayoutBuilder Usage

        LayoutBuilder is used to rebuild UI based on available screen constraints and orientation.

        ### Screenshots

        (Add images)

        * Phone Portrait
        * Phone Landscape
        * Tablet Portrait
        * Tablet Landscape

        ### Reflection

        Challenges:

        * Handling layout differences between phone and tablet
        * Avoiding overflow in landscape mode
        * Maintaining consistent spacing and alignment

        Benefits of Responsive Design:

        * Better user experience across devices
        * Supports tablets and large screens
        * Future-ready for multiple screen sizes

        ---

        ## Firebase Integration – Sprint 2

        This screen demonstrates Firebase Authentication and Firestore usage with login, signup, and real-time notes.

        ### Screenshots

        (Add images)

        * Signup success
        * Login success
        * Home screen showing notes
        * Firebase Console - Authentication
        * Firebase Console - Firestore data

        ### Reflection

        Challenges:

        * Firebase setup and configuration
        * Handling async operations
        * Firestore real-time updates

        Benefits of Firebase:

        * No backend needed
        * Real-time data sync
        * Secure authentication
        * Scalable cloud infrastructure

        ## Reflection

        API documentation helps:

        * Faster onboarding for new developers
        * Clear understanding of endpoints and data structure
        * Easier debugging and testing
        * Version tracking prevents breaking changes
