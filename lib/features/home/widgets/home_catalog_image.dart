import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class HomeCatalogImage extends StatelessWidget {
  const HomeCatalogImage({
    super.key,
    required this.imageAsset,
    required this.size,
    this.overlay,
    this.backgroundColor = AppColors.homeSurface,
  });

  final String imageAsset;
  final double size;
  final Widget? overlay;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(HomeLayout.imageRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: backgroundColor),
            Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
            if (overlay != null) overlay!,
          ],
        ),
      ),
    );
  }
}
