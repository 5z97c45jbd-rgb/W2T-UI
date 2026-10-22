import 'package:flutter/material.dart';

class RestaurantBrand {
  const RestaurantBrand({
    required this.background,
    required this.icon,
    this.iconColor = Colors.white,
    this.accent,
  });

  final Color background;
  final IconData icon;
  final Color iconColor;
  final Color? accent;
}

class RestaurantItem {
  const RestaurantItem({
    required this.name,
    required this.imageAsset,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.brand,
    required this.priceForTwo,
    required this.distanceKm,
    required this.cuisines,
    this.offerLabel,
    this.offerHighlight = false,
  });

  final String name;
  final String imageAsset;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final RestaurantBrand brand;
  final int priceForTwo;
  final double distanceKm;
  final List<String> cuisines;
  final String? offerLabel;
  final bool offerHighlight;

  String get formattedReviewCount {
    if (reviewCount >= 1000) {
      final value = reviewCount / 1000;
      final label = value == value.roundToDouble()
          ? value.toStringAsFixed(0)
          : value.toStringAsFixed(1);
      return '${label}K';
    }
    return '$reviewCount';
  }

  int get minDeliveryMinutes {
    final match = RegExp(r'\d+').firstMatch(deliveryTime);
    return int.tryParse(match?.group(0) ?? '') ?? 0;
  }
}
