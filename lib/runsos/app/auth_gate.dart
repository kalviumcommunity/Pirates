import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../features/auth/phone_login_screen.dart';
import '../features/home/runsos_home_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/sos/sos_map_screen.dart';
import '../models/user_profile.dart';
import '../services/messaging_service.dart';
import '../services/user_profile_service.dart';
import '../runsos_app.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _profiles = UserProfileService();
  final _messaging = MessagingService();

  StreamSubscription<User?>? _authSub;
  String? _lastMessagingUid;

  @override
  void initState() {
    super.initState();

    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user?.uid != null) {
        _profiles.updateLastSeen(user!.uid);
        _initMessagingOnce(user.uid);
      }
    });
  }

  Future<void> _initMessagingOnce(String uid) async {
    if (_lastMessagingUid == uid) {
      return;
    }

    _lastMessagingUid = uid;

    await _messaging.init(
      uid: uid,
      onNotificationTap: (RemoteMessage message) {
        final trackUid = message.data['trackUid']?.toString() ??
            message.data['uid']?.toString();
        if (trackUid == null || trackUid.isEmpty) {
          return;
        }

        RunSosApp.navigatorKey.currentState?.pushNamed(
          SosMapScreen.routeName,
          arguments: SosMapArgs(trackUid: trackUid),
        );
      },
    );
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authSnap.data;
        if (user == null) {
          return const PhoneLoginScreen();
        }

        return StreamBuilder<UserProfile?>(
          stream: _profiles.watchProfile(user.uid),
          builder: (context, profileSnap) {
            if (profileSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final profile = profileSnap.data;
            if (profile == null || !profile.isComplete) {
              return const ProfileScreen();
            }

            return const RunSosHomeScreen();
          },
        );
      },
    );
  }
}
