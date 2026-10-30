import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';

class AiMascot extends StatelessWidget {
  const AiMascot({super.key, this.size = 220});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.bot,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
