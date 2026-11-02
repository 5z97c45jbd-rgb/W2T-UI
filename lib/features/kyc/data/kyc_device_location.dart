import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';

class KycGeoResult {
  const KycGeoResult({
    required this.latitude,
    required this.longitude,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.pincode,
    this.state,
  });

  final double latitude;
  final double longitude;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? pincode;
  final String? state;
}

abstract final class KycDeviceLocation {
  /// GPS + reverse geocode. Returns null if permission is denied or lookup fails.
  static Future<KycGeoResult?> fetch() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever ||
          permission == LocationPermission.unableToDetermine) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      String? line1;
      String? line2;
      String? city;
      String? pincode;
      String? state;
      try {
        final marks = await Geocoding().placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (marks.isNotEmpty) {
          final mark = marks.first;
          final street = [
            mark.subThoroughfare,
            mark.thoroughfare,
          ].where((part) => part != null && part.trim().isNotEmpty).join(' ');
          line1 = street.isEmpty ? mark.street : street;
          line2 = mark.subLocality;
          city = mark.locality?.trim().isNotEmpty == true
              ? mark.locality
              : mark.subAdministrativeArea;
          pincode = mark.postalCode;
          state = _matchIndianState(mark.administrativeArea);
        }
      } catch (_) {}

      return KycGeoResult(
        latitude: position.latitude,
        longitude: position.longitude,
        addressLine1: _nonEmpty(line1),
        addressLine2: _nonEmpty(line2),
        city: _nonEmpty(city),
        pincode: _nonEmpty(pincode),
        state: state,
      );
    } catch (_) {
      return null;
    }
  }

  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  static String? _matchIndianState(String? value) {
    final trimmed = _nonEmpty(value);
    if (trimmed == null) return null;
    final lower = trimmed.toLowerCase();
    for (final name in KycValidators.indianStates) {
      if (name.toLowerCase() == lower ||
          lower.contains(name.toLowerCase()) ||
          name.toLowerCase().contains(lower)) {
        return name;
      }
    }
    return trimmed;
  }
}
