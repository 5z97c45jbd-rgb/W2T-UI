import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

/// Prepares the Android Google Maps renderer before any [GoogleMap] is built.
///
/// Creating a map first throws:
/// `Trying to create a platform view of unregistered type:
/// plugins.flutter.dev/google_maps_android`.
class GoogleMapsBootstrap {
  GoogleMapsBootstrap._();

  static Future<bool>? _future;

  static Future<bool> ensureInitialized() {
    return _future ??= _initialize();
  }

  static Future<bool> _initialize() async {
    if (kIsWeb) return false;
    try {
      final implementation = GoogleMapsFlutterPlatform.instance;
      if (implementation is GoogleMapsFlutterAndroid) {
        await implementation.initializeWithRenderer(
          AndroidMapRenderer.latest,
        );
        await implementation.warmup();
      }
      return true;
    } catch (error, stack) {
      debugPrint('[maps] Google Maps init failed: $error\n$stack');
      return false;
    }
  }
}
