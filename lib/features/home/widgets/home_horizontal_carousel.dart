import 'package:flutter/material.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class HomeHorizontalCarousel extends StatelessWidget {
  const HomeHorizontalCarousel({
    super.key,
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
  });

  final double height;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: HomeLayout.horizontalPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, __) =>
            const SizedBox(width: HomeLayout.itemSpacing),
        itemBuilder: (context, index) {
          return Align(
            alignment: Alignment.topCenter,
            child: itemBuilder(context, index),
          );
        },
      ),
    );
  }
}
