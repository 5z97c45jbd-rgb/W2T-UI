import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceTokenService {
  static bool _ready = false;

  static Future<void> ensureInitialized() async {
    try {
      await Firebase.initializeApp();
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  static Future<String> current() async {
    if (!_ready) return '';
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      // Auth expects the FCM registration token. register()/onRegistered
      // returns a Firebase Installation ID, which is a different value.
      // ignore: deprecated_member_use
      return await messaging.getToken() ?? '';
    } catch (_) {
      return '';
    }
  }
}
