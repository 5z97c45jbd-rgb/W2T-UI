import 'package:flutter/material.dart';
import 'package:w2t_mobile/features/home/widgets/home_bottom_nav_bar.dart';

abstract final class HomeLayout {
  static const double horizontalPadding = 16;
  static const double itemSpacing = 12;
  static const double imageRadius = 14;

  static double cardWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final available = screenWidth - (horizontalPadding * 2) - itemSpacing;
    return (available / 2.35).clamp(136, 156);
  }

  static double restaurantCarouselHeight(double cardWidth) => cardWidth + 84;

  static double catalogCarouselHeight(double cardWidth) => cardWidth + 68;

  static double scrollBottomPadding(BuildContext context) =>
      HomeBottomNavBar.contentBottomInset(context) + 28;
}
