import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:w2t_mobile/features/home/data/google_geocoding.dart';
import 'package:w2t_mobile/features/home/data/models/place_location.dart';

class CurrentLocationService {
  CurrentLocationService({
    GoogleGeocoding? geocoding,
    Future<Position?> Function()? readPosition,
    Future<PlaceLocation?> Function(double latitude, double longitude)?
        reverseGeocode,
  })  : _geocoding = geocoding ?? GoogleGeocoding(),
        _readPosition = readPosition,
        _reverseGeocode = reverseGeocode;

  final GoogleGeocoding _geocoding;
  final Future<Position?> Function()? _readPosition;
  final Future<PlaceLocation?> Function(double latitude, double longitude)?
      _reverseGeocode;

  Future<PlaceLocation?> fetch() async {
    try {
      final position = await (_readPosition ?? _devicePosition)();
      if (position == null) return null;

      final reverse = _reverseGeocode ?? _lookup;
      return await reverse(position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }

  Future<Position?> _devicePosition() async {
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

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  Future<PlaceLocation?> _lookup(double latitude, double longitude) async {
    try {
      final fromGoogle = await _geocoding.reverseGeocode(
        latitude: latitude,
        longitude: longitude,
      );
      if (fromGoogle != null) return fromGoogle;
    } catch (_) {}

    return _nativeLookup(latitude, longitude);
  }

  Future<PlaceLocation?> _nativeLookup(
    double latitude,
    double longitude,
  ) async {
    try {
      final marks = await Geocoding().placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (marks.isEmpty) return null;
      final mark = marks.first;
      final city = _nonEmpty(mark.locality) ??
          _nonEmpty(mark.subLocality) ??
          _nonEmpty(mark.subAdministrativeArea);
      final district = _nonEmpty(mark.subAdministrativeArea) ?? city;
      final state = _nonEmpty(mark.administrativeArea);
      if (city == null && district == null) return null;
      return PlaceLocation(
        district: district ?? city!,
        city: city ?? district!,
        state: state ?? '',
        country: _nonEmpty(mark.country),
        latitude: latitude,
        longitude: longitude,
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
}
