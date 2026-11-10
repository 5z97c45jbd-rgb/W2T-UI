import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/models/tracked_order.dart';
import 'package:w2t_mobile/features/home/widgets/track_order/track_order_chrome.dart';

class TrackRouteMap extends StatelessWidget {
  const TrackRouteMap({
    super.key,
    required this.order,
    this.compact = false,
    this.showLocate = false,
  });

  final TrackedOrder order;
  final bool compact;
  final bool showLocate;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      compact ? AppAssets.trackOrderStrip : AppAssets.trackOrderMap,
      fit: compact ? BoxFit.fitWidth : BoxFit.cover,
      alignment: compact ? Alignment.center : const Alignment(0, -0.12),
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      gaplessPlayback: true,
      width: double.infinity,
      height: double.infinity,
    );

    return Stack(
      key: ValueKey(order.id),
      fit: StackFit.expand,
      children: [
        image,
        if (showLocate)
          Positioned(
            top: 12,
            right: 12,
            child: Material(
              color: AppColors.white,
              shape: const CircleBorder(),
              elevation: 2,
              shadowColor: Colors.black26,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.my_location_rounded,
                    size: 18,
                    color: TrackOrderStyle.navy,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
