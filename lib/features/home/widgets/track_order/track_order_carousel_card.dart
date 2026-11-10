import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';
import 'package:w2t_mobile/features/home/data/models/tracked_order.dart';
import 'package:w2t_mobile/features/home/widgets/home_catalog_image.dart';
import 'package:w2t_mobile/features/home/widgets/track_order/track_order_chrome.dart';

class TrackOrderCarouselCard extends StatelessWidget {
  const TrackOrderCarouselCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  final TrackedOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final live = order.isLive;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A4C5C).withValues(alpha: 0.08),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 92,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        live
                            ? AppAssets.trackOrderStrip
                            : AppAssets.trackOrderMap,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00000000),
                              Color(0x14000000),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: TrackStatusBadge(order: order),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          HomeCatalogImage(
                            imageAsset: order.imageAsset,
                            imageUrl: order.imageUrl,
                            size: 48,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.merchantName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: TrackOrderStyle.navy,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${order.itemCountLabel}  •  ${order.totalLabel}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _StageRail(order: order),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Icon(
                            live
                                ? Icons.schedule_rounded
                                : Icons.check_circle_rounded,
                            size: 16,
                            color: live
                                ? AppColors.primary
                                : TrackOrderStyle.onWayGreen,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              live
                                  ? 'Arriving in ${order.etaLabel}'
                                  : order.status == OrderStatus.delivered
                                      ? 'Delivered'
                                      : order.statusLabel,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: TrackOrderStyle.navy,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Track',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 16,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StageRail extends StatelessWidget {
  const _StageRail({required this.order});

  final TrackedOrder order;

  static const _labels = ['Placed', 'Preparing', 'On the way', 'Delivered'];

  int get _active {
    return switch (order.status) {
      OrderStatus.preparing => 1,
      OrderStatus.outForDelivery => 2,
      OrderStatus.delivered => 3,
      OrderStatus.cancelled ||
      OrderStatus.paymentFailed ||
      OrderStatus.returnRequested =>
        0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final active = _active;
    final accent =
        order.isLive ? AppColors.primary : TrackOrderStyle.onWayGreen;

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < _labels.length; i++) ...[
              _Dot(filled: i <= active, color: accent),
              if (i != _labels.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: i < active ? accent : const Color(0xFFE6EEF2),
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            for (var i = 0; i < _labels.length; i++)
              Expanded(
                child: Text(
                  _labels[i],
                  textAlign: i == 0
                      ? TextAlign.left
                      : i == _labels.length - 1
                          ? TextAlign.right
                          : TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 9.5,
                    fontWeight: i == active ? FontWeight.w700 : FontWeight.w500,
                    color: i <= active
                        ? TrackOrderStyle.navy
                        : AppColors.textMuted,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.filled, required this.color});

  final bool filled;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: filled ? color : AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: filled ? color : const Color(0xFFD5DEE4),
          width: 1.6,
        ),
      ),
    );
  }
}

class TrackOrderListTile extends StatelessWidget {
  const TrackOrderListTile({
    super.key,
    required this.order,
    required this.onTap,
  });

  final TrackedOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
          child: Row(
            children: [
              HomeCatalogImage(
                imageAsset: order.imageAsset,
                imageUrl: order.imageUrl,
                size: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.merchantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: TrackOrderStyle.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.itemCountLabel}  •  ${order.totalLabel}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              TrackStatusBadge(order: order),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
