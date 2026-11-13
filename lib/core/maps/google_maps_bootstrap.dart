import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return !kIsWeb;
    }

    // Hot restart rebuilds the Dart isolate before the Android plugin
    // reattaches MapsInitializerApi. Pigeon then returns a null reply, which
    // surfaces as channel-error. That miss must not stick for the session.
    Object? lastError;
    StackTrace? lastStack;
    for (var attempt = 0; attempt < 6; attempt++) {
      try {
        final implementation = GoogleMapsFlutterPlatform.instance;
        if (implementation is GoogleMapsFlutterAndroid) {
          await _requestLatestRenderer(implementation);
          await implementation.warmup();
        }
        return true;
      } on PlatformException catch (error, stack) {
        lastError = error;
        lastStack = stack;
        if (error.code != 'channel-error' || attempt == 5) break;
        await Future<void>.delayed(Duration(milliseconds: 120 * (attempt + 1)));
      } catch (error, stack) {
        lastError = error;
        lastStack = stack;
        break;
      }
    }

    debugPrint('[maps] Google Maps init failed: $lastError\n$lastStack');
    _future = null;
    return false;
  }

  static Future<void> _requestLatestRenderer(
    GoogleMapsFlutterAndroid implementation,
  ) async {
    try {
      await implementation.initializeWithRenderer(AndroidMapRenderer.latest);
    } on PlatformException catch (error) {
      // The native initializer survives hot restart and rejects a second call.
      if (error.code == 'Renderer already initialized') return;
      rethrow;
    }
  }
}
