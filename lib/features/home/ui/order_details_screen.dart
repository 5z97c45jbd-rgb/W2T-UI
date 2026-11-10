import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/ui/app_snack_bar.dart';
import 'package:w2t_mobile/features/home/data/models/tracked_order.dart';
import 'package:w2t_mobile/features/home/ui/live_order_tracking_screen.dart';
import 'package:w2t_mobile/features/home/widgets/home_catalog_image.dart';
import 'package:w2t_mobile/features/home/widgets/track_order/track_order_chrome.dart';
import 'package:w2t_mobile/features/home/widgets/track_order/track_route_map.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final TrackedOrder order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _summaryOpen = true;

  TrackedOrder get order => widget.order;

  void _openMap() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LiveOrderTrackingScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            TrackOrderAppBar(
              onBack: () => Navigator.of(context).pop(),
              onShare: () {},
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
                children: [
                  const TrackSectionTitle('Order Details'),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Order ID: ${order.displayId}',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: order.displayId),
                                    );
                                    AppSnackBar.show(context, 'Order ID copied');
                                  },
                                  child: const Icon(
                                    Icons.copy_rounded,
                                    size: 15,
                                    color: Color(0xFFB7C0C8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Placed ${order.steps.isNotEmpty ? order.steps.first.subtitle : order.placedAtShort}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TrackStatusBadge(order: order),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _MerchantCard(order: order),
                  const SizedBox(height: 22),
                  Text(
                    'Delivery Status',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: TrackOrderStyle.navy,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _Timeline(order: order),
                  const SizedBox(height: 16),
                  TrackRiderCard(partner: order.partner),
                  const SizedBox(height: 20),
                  _LiveTrackingPreview(order: order, onOpenMap: _openMap),
                  const SizedBox(height: 18),
                  _OrderSummary(
                    order: order,
                    open: _summaryOpen,
                    onToggle: () => setState(() => _summaryOpen = !_summaryOpen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MerchantCard extends StatelessWidget {
  const _MerchantCard({required this.order});

  final TrackedOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF2F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        order.merchantName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: TrackOrderStyle.navy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified_rounded,
                      size: 15,
                      color: Color(0xFF2F7BFF),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  order.merchantMeta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.order});

  final TrackedOrder order;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < order.steps.length; i++)
          _TimelineRow(
            step: order.steps[i],
            isLast: i == order.steps.length - 1,
            etaLabel: i == 4 && order.steps[i].state == DeliveryStepState.current
                ? 'ETA: ${order.etaLabel}'
                : null,
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.step,
    required this.isLast,
    this.etaLabel,
  });

  final DeliveryStep step;
  final bool isLast;
  final String? etaLabel;

  @override
  Widget build(BuildContext context) {
    final color = switch (step.state) {
      DeliveryStepState.done => TrackOrderStyle.onWayGreen,
      DeliveryStepState.current => AppColors.primary,
      DeliveryStepState.pending => const Color(0xFFD5DEE4),
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Column(
              children: [
                _Dot(state: step.state, color: color),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: step.state == DeliveryStepState.done
                          ? TrackOrderStyle.onWayGreen.withValues(alpha: 0.28)
                          : const Color(0xFFE3EAEE),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: step.state == DeliveryStepState.pending
                          ? const Color(0xFFC0C8CE)
                          : TrackOrderStyle.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          step.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            height: 1.3,
                            color: step.state == DeliveryStepState.pending
                                ? const Color(0xFFC0C8CE)
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (etaLabel != null)
                        Text(
                          etaLabel!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
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

class _Dot extends StatelessWidget {
  const _Dot({required this.state, required this.color});

  final DeliveryStepState state;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (state == DeliveryStepState.done) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, size: 13, color: Colors.white),
      );
    }
    if (state == DeliveryStepState.current) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2.4),
          color: Colors.white,
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      );
    }
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        color: Colors.white,
      ),
    );
  }
}

class _LiveTrackingPreview extends StatelessWidget {
  const _LiveTrackingPreview({
    required this.order,
    required this.onOpenMap,
  });

  final TrackedOrder order;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Live Tracking',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: TrackOrderStyle.navy,
                ),
              ),
            ),
            GestureDetector(
              onTap: onOpenMap,
              child: Text(
                'View on Map >',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onOpenMap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1024 / 258,
              child: TrackRouteMap(order: order, compact: true),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.order,
    required this.open,
    required this.onToggle,
  });

  final TrackedOrder order;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF2F5)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Text(
                  'Order Summary',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: TrackOrderStyle.navy,
                  ),
                ),
                const Spacer(),
                Icon(
                  open
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: TrackOrderStyle.navy,
                ),
              ],
            ),
          ),
          if (open) ...[
            const SizedBox(height: 12),
            for (final item in order.items) ...[
              Row(
                children: [
                  HomeCatalogImage(
                    imageAsset: item.imageAsset,
                    imageUrl: item.imageUrl,
                    size: 40,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${item.name}   x${item.quantity}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: TrackOrderStyle.navy,
                      ),
                    ),
                  ),
                  Text(
                    item.amountLabel,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: TrackOrderStyle.navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            const Divider(height: 20, color: Color(0xFFEEF2F5)),
            Row(
              children: [
                Text(
                  'Total Paid',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: TrackOrderStyle.navy,
                  ),
                ),
                const Spacer(),
                Text(
                  order.totalLabel,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: TrackOrderStyle.navy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Paid via  ${order.paymentLabel}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
