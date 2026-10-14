import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';

class W2tLogo extends StatelessWidget {
  const W2tLogo({
    super.key,
    this.width = 140,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
