import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/models/restaurant_item.dart';
import 'package:w2t_mobile/features/home/widgets/restaurant_logo.dart';

class FeaturedRestaurantListCard extends StatelessWidget {
  const FeaturedRestaurantListCard({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final RestaurantItem item;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImageHeader(
            item: item,
            isFavorite: isFavorite,
            onFavoriteTap: onFavoriteTap,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RestaurantLogo(brand: item.brand, size: 32),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.titleNavy,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.only(right: 3),
                            child: Icon(
                              Icons.star_rounded,
                              size: 13,
                              color: AppColors.ratingStar,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: item.rating.toStringAsFixed(1),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' (${item.formattedReviewCount})  ·  ₹${item.priceForTwo} for two  ·  ${item.distanceKm.toStringAsFixed(1)} km',
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: item.cuisines
                      .map(
                        (cuisine) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.chipFill,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            cuisine,
                            style: GoogleFonts.inter(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({
    required this.item,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final RestaurantItem item;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.28,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            item.imageAsset,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
          if (item.offerLabel != null)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.offerHighlight
                      ? AppColors.offerGreen
                      : AppColors.offerOrange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.offerLabel!,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 10,
            right: 10,
            child: Material(
              color: AppColors.white.withValues(alpha: 0.95),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onFavoriteTap,
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 16,
                    color: isFavorite
                        ? AppColors.cartBadge
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 11,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item.deliveryTime,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
