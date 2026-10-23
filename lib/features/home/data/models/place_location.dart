class PlaceLocation {
  const PlaceLocation({
    required this.city,
    required this.latitude,
    required this.longitude,
    this.country,
  });

  /// Matches the location chip currently shown on the home header.
  static const current = PlaceLocation(
    city: 'Hanamkonda',
    country: 'India',
    latitude: 18.0072,
    longitude: 79.55896,
  );

  final String city;
  final String? country;
  final double latitude;
  final double longitude;
}
