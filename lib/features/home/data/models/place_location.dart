class PlaceLocation {
  const PlaceLocation({
    required this.district,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.country,
  });

  /// Value sent as the `city` query param on `/api/cities/images`.
  static const cityImagesCity = 'Warangal';

  /// Default location for city hero images and related API calls.
  static const current = PlaceLocation(
    district: 'Vizag',
    city: cityImagesCity,
    country: 'India',
    latitude: 18.0072,
    longitude: 79.55896,
  );

  final String district;
  final String city;
  final String? country;
  final double latitude;
  final double longitude;
}
