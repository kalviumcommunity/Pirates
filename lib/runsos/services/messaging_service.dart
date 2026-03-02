import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagingService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final FlutterLocalNotificationsPlugin _localNotifications;

  MessagingService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin();

  Future<void> init({
    required String uid,
    required void Function(RemoteMessage message) onNotificationTap,
  }) async {
    await _initLocalNotifications(onNotificationTap);

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('FCM permission: ${settings.authorizationStatus}');

    final token = await _messaging.getToken();
    if (token != null) {
      await _saveToken(uid: uid, token: token);
    }

    _messaging.onTokenRefresh.listen((t) {
      _saveToken(uid: uid, token: t);
    });

    FirebaseMessaging.onMessage.listen((message) {
      _showForegroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(onNotificationTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      onNotificationTap(initialMessage);
    }
  }

  Future<void> _saveToken({required String uid, required String token}) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('fcmTokens')
        .doc(token)
        .set({
      'platform': Platform.operatingSystem,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _initLocalNotifications(
    void Function(RemoteMessage message) onNotificationTap,
  ) async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // When user taps a local notification, we can’t reconstruct the whole
        // RemoteMessage reliably; keep it minimal.
        // For MVP, server-sent push taps are handled by onMessageOpenedApp.
      },
    );

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'runsos_alerts',
        'RunSOS Alerts',
        description: 'Emergency and tracking alerts',
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final title = message.notification?.title ?? 'RunSOS';
    final body = message.notification?.body ?? '';

    const androidDetails = AndroidNotificationDetails(
      'runsos_alerts',
      'RunSOS Alerts',
      channelDescription: 'Emergency and tracking alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      title.hashCode ^ body.hashCode,
      title,
      body,
      details,
    );
  }
}
