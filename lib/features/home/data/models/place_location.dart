import 'package:equatable/equatable.dart';

class PlaceLocation extends Equatable {
  const PlaceLocation({
    required this.district,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    this.country,
  });

  static const current = PlaceLocation(
    district: 'Warangal',
    city: 'Warangal',
    state: 'Telangana',
    country: 'India',
    latitude: 18.0072,
    longitude: 79.55896,
  );

  /// District is sent as the `city` query param on `/api/cities/images`.
  final String district;
  final String city;
  final String state;
  final String? country;
  final double latitude;
  final double longitude;

  /// Home top-bar label: city and state.
  String get displayLabel {
    final parts = [
      city.trim(),
      state.trim(),
    ].where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return district;
    if (parts.length == 2 && parts[0].toLowerCase() == parts[1].toLowerCase()) {
      return parts[0];
    }
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [
        district,
        city,
        state,
        country,
        latitude,
        longitude,
      ];
}
