import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:w2t_mobile/core/notifications/local_notification_service.dart';
import 'package:w2t_mobile/firebase_options.dart';

void printPushPayload(String source, RemoteMessage message) {
  final payload = <String, dynamic>{
    'loadedFrom': source,
    'messageId': message.messageId,
    'from': message.from,
    'senderId': message.senderId,
    'category': message.category,
    'collapseKey': message.collapseKey,
    'sentTime': message.sentTime?.toIso8601String(),
    'ttl': message.ttl,
    'notification': {
      'title': message.notification?.title,
      'body': message.notification?.body,
      'androidChannelId': message.notification?.android?.channelId,
      'androidClickAction': message.notification?.android?.clickAction,
      'androidImageUrl': message.notification?.android?.imageUrl,
      'appleImageUrl': message.notification?.apple?.imageUrl,
    },
    'data': message.data,
  };
  final encoded = const JsonEncoder.withIndent('  ').convert(payload);
  debugPrint('[push] ========== PAYLOAD ==========');
  debugPrint('[push] loaded from: $source');
  debugPrint('[push] $encoded');
  debugPrint('[push] =============================');
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  printPushPayload('FCM background handler (app background/terminated)', message);
  await LocalNotificationService.instance.ensureInitialized();
  await LocalNotificationService.instance.showRemoteMessage(message);
}

class PushNotificationService {
  static bool _ready = false;

  static Future<void> ensureInitialized() async {
    if (_ready || Firebase.apps.isEmpty) return;
    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await LocalNotificationService.instance.ensureInitialized();
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((message) {
        printPushPayload('FCM onMessage (app foreground)', message);
        LocalNotificationService.instance.showRemoteMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        printPushPayload('FCM onMessageOpenedApp (tapped from background)', message);
      });

      final initial = await messaging.getInitialMessage();
      if (initial != null) {
        printPushPayload(
          'FCM getInitialMessage (tapped from terminated state)',
          initial,
        );
      } else {
        debugPrint('[push] no initial notification payload (cold start without tap)');
      }

      _ready = true;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[push] init failed: $error');
      }
    }
  }
}
