import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  static const AndroidNotificationChannel androidChannel =
      AndroidNotificationChannel(
    'w2t_high_importance',
    'High Importance Notifications',
    description: 'W2T alerts and updates',
    importance: Importance.max,
    playSound: true,
  );

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> ensureInitialized() async {
    if (_ready) return;
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_stat_notification'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('[push] ========== LOCAL TAP ==========');
        debugPrint('[push] loaded from: flutter_local_notifications tap');
        debugPrint('[push] payload: ${response.payload}');
        debugPrint('[push] ===============================');
      },
    );

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(androidChannel);
    await android?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _ready = true;
  }

  Future<void> showRemoteMessage(RemoteMessage message) async {
    await ensureInitialized();
    final title = _firstNonEmpty([
      message.notification?.title,
      message.data['title'],
      message.data['Title'],
    ]);
    final body = _firstNonEmpty([
      message.notification?.body,
      message.data['body'],
      message.data['message'],
      message.data['Message'],
    ]);
    if (title == null && body == null) {
      debugPrint(
        '[push] skipped local notification: empty title/body messageId=${message.messageId} data=${message.data}',
      );
      return;
    }

    final id = (message.messageId ??
            DateTime.now().millisecondsSinceEpoch.toString())
        .hashCode
        .abs();
    await _plugin.show(
      id,
      title ?? 'W2T',
      body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/ic_stat_notification',
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
    debugPrint(
      '[push] local notification shown from FCM payload title="$title" body="$body" data=${jsonEncode(message.data)}',
    );
  }

  static String? _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }
}
