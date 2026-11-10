import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class HomeCatalogImage extends StatelessWidget {
  const HomeCatalogImage({
    super.key,
    required this.imageAsset,
    required this.size,
    this.imageUrl,
    this.overlay,
    this.backgroundColor = AppColors.homeSurface,
  });

  final String imageAsset;
  final String? imageUrl;
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
            HomeFillImage(
              imageUrl: imageUrl,
              fallbackAsset: imageAsset,
            ),
            if (overlay != null) overlay!,
          ],
        ),
      ),
    );
  }
}

class HomeFillImage extends StatelessWidget {
  const HomeFillImage({
    super.key,
    required this.fallbackAsset,
    this.imageUrl,
  });

  final String fallbackAsset;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = _usableUrl(imageUrl);
    final fallback = _AssetImage(asset: fallbackAsset);
    if (url == null) return fallback;

    return Image.network(
      url,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => fallback,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return fallback;
      },
    );
  }

  static String? _usableUrl(String? value) {
    final url = value?.trim() ?? '';
    if (url.isEmpty) return null;
    final lower = url.toLowerCase();
    if (lower == 'null' ||
        lower == 'undefined' ||
        lower == 'string' ||
        lower == 'none' ||
        lower == 'n/a' ||
        lower == '-' ||
        lower.endsWith('/null') ||
        lower.endsWith('/undefined')) {
      return null;
    }
    return url;
  }
}

class _AssetImage extends StatelessWidget {
  const _AssetImage({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
}
