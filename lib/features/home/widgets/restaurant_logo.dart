import 'package:flutter/material.dart';
import 'package:w2t_mobile/features/home/data/models/restaurant_item.dart';

class RestaurantLogo extends StatelessWidget {
  const RestaurantLogo({
    super.key,
    required this.brand,
    this.size = 34,
  });

  final RestaurantBrand brand;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: brand.background,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        brand.icon,
        size: size * 0.52,
        color: brand.iconColor,
      ),
    );
  }
}
