class RestaurantItem {
  const RestaurantItem({
    required this.name,
    required this.imageAsset,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
  });

  final String name;
  final String imageAsset;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
}
