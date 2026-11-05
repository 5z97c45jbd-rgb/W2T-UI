class CityBanner {
  const CityBanner({
    required this.imageUrl,
    this.headline,
  });

  static const fallbackHeadline = 'Local Favorites Delivered to You';

  final String imageUrl;
  final String? headline;

  String get displayHeadline {
    final value = headline?.trim();
    if (value == null || value.isEmpty) return fallbackHeadline;
    return value;
  }
}
