import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/auth/widgets/w2t_logo.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';
import 'package:w2t_mobile/features/home/data/models/tracked_order.dart';

abstract final class TrackOrderStyle {
  static const Color page = Color(0xFFFFFFFF);
  static const Color navy = Color(0xFF1B2A4A);
  static const Color cardBorder = Color(0xFFEEF2F5);
  static const Color routeBlue = Color(0xFF2F7BFF);
  static const Color restaurantOrange = Color(0xFFFF7A2F);
  static const Color homeBlue = Color(0xFF2F6BFF);
  static const Color onWayGreen = Color(0xFF2F9E57);
  static const Color onWayFill = Color(0xFFE6F7ED);
  static const Color noticeFill = Color(0xFFEFF8FC);
  static const Color iconCircle = Color(0xFFF3F6F8);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
}

class TrackOrderAppBar extends StatelessWidget {
  const TrackOrderAppBar({
    super.key,
    required this.onBack,
    this.onSupport,
    this.onShare,
  });

  final VoidCallback onBack;
  final VoidCallback? onSupport;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 2),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 30,
              color: TrackOrderStyle.navy,
            ),
          ),
          const Expanded(
            child: Center(child: W2tLogo(width: 78)),
          ),
          _RoundIconButton(
            icon: Icons.headset_mic_outlined,
            onTap: onSupport ?? () {},
          ),
          if (onShare != null) ...[
            const SizedBox(width: 8),
            _RoundIconButton(icon: Icons.ios_share_rounded, onTap: onShare!),
          ],
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TrackOrderStyle.iconCircle,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 18, color: TrackOrderStyle.navy),
        ),
      ),
    );
  }
}

class TrackStatusBadge extends StatelessWidget {
  const TrackStatusBadge({super.key, required this.order});

  final TrackedOrder order;

  @override
  Widget build(BuildContext context) {
    final live = order.status == OrderStatus.outForDelivery;
    final color = live ? TrackOrderStyle.onWayGreen : order.status.foreground;
    final fill = live ? TrackOrderStyle.onWayFill : order.status.background;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            live ? Icons.local_shipping_outlined : Icons.timelapse_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            order.statusLabel,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class TrackRiderCard extends StatelessWidget {
  const TrackRiderCard({
    super.key,
    required this.partner,
    this.onCall,
    this.embedded = false,
  });

  final DeliveryPartner partner;
  final VoidCallback? onCall;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        embedded ? 0 : 12,
        embedded ? 0 : 10,
        embedded ? 0 : 4,
        embedded ? 0 : 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: embedded ? null : Border.all(color: TrackOrderStyle.cardBorder),
        boxShadow: embedded ? const [] : TrackOrderStyle.cardShadow,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFE8F4F8),
            child: Icon(
              Icons.delivery_dining_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner.name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: TrackOrderStyle.navy,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppColors.ratingStar,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        '${partner.rating} (${partner.deliveriesLabel})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _ActionCircle(
            icon: Icons.phone_outlined,
            onTap: onCall ?? () {},
          ),
        ],
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  const _ActionCircle({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF1F6F8),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 18, color: AppColors.primaryDark),
        ),
      ),
    );
  }
}

class TrackSectionTitle extends StatelessWidget {
  const TrackSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: TrackOrderStyle.navy,
      ),
    );
  }
}
