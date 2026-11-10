import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/models/tracked_order.dart';
import 'package:w2t_mobile/features/home/widgets/home_catalog_image.dart';
import 'package:w2t_mobile/features/home/widgets/track_order/track_order_chrome.dart';
import 'package:w2t_mobile/features/home/widgets/track_order/track_route_map.dart';

class LiveOrderTrackingScreen extends StatelessWidget {
  const LiveOrderTrackingScreen({super.key, required this.order});

  final TrackedOrder order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            TrackOrderAppBar(
              onBack: () => Navigator.of(context).pop(),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TrackSectionTitle('Live Order Tracking'),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: TrackRouteMap(
                        order: order,
                        showLocate: true,
                      ),
                    ),
                  ),
                  _Sheet(order: order),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.order});

  final TrackedOrder order;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E6EA),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 10),
            TrackRiderCard(partner: order.partner, embedded: true),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Stat(
                  icon: Icons.two_wheeler_rounded,
                  title: order.remainingLabel,
                  subtitle: 'Remaining',
                ),
                _Stat(
                  icon: Icons.schedule_rounded,
                  title: order.etaLabel,
                  subtitle: 'ETA',
                ),
                _Stat(
                  icon: Icons.location_on_outlined,
                  title: 'Your Location',
                  subtitle: order.destinationLabel,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: TrackOrderStyle.noticeFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.isLive
                              ? 'Your order is on the way!'
                              : order.statusLabel,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: TrackOrderStyle.navy,
                          ),
                        ),
                        Text(
                          order.isLive
                              ? "We'll notify you once it's delivered."
                              : 'Thanks for ordering with W2T.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            height: 1.25,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _OrderDetailsCard(order: order),
          ],
        ),
      ),
    );
  }
}

class _OrderDetailsCard extends StatelessWidget {
  const _OrderDetailsCard({required this.order});

  final TrackedOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TrackOrderStyle.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Order Details',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: TrackOrderStyle.navy,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textMuted,
              ),
            ],
          ),
          Text(
            'Order ID: ${order.displayId}',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              HomeCatalogImage(
                imageAsset: order.imageAsset,
                imageUrl: order.imageUrl,
                size: 40,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.merchantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: TrackOrderStyle.navy,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${order.itemCountLabel}  •  ${order.totalLabel}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TrackStatusBadge(order: order),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: TrackOrderStyle.navy),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: TrackOrderStyle.navy,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
