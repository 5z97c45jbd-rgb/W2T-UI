import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:w2t_mobile/firebase_options.dart';

class DeviceTokenService {
  static bool _ready = false;

  static Future<void> ensureInitialized() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _ready = true;
    } catch (error) {
      _ready = false;
      if (kDebugMode) {
        debugPrint('[network] Firebase init failed: $error');
      }
    }
  }

  static Future<String> current() async {
    if (!_ready) {
      if (kDebugMode) {
        debugPrint('[network] deviceToken: empty (Firebase is not ready)');
      }
      return '';
    }
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      // Auth expects the FCM registration token. register()/onRegistered
      // returns a Firebase Installation ID, which is a different value.
      // ignore: deprecated_member_use
      final token = await messaging.getToken() ?? '';
      if (kDebugMode) {
        debugPrint('[network] deviceToken: ${token.isEmpty ? '(empty)' : token}');
      }
      return token;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[network] deviceToken failed: $error');
      }
      return '';
    }
  }
}
