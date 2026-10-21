import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/home_content.dart';
import 'package:w2t_mobile/features/home/data/models/category_item.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class HomeCategoriesGrid extends StatelessWidget {
  const HomeCategoriesGrid({super.key});

  static const _columns = 5;
  static const _tileHeight = 86.0;

  @override
  Widget build(BuildContext context) {
    final categories = HomeContent.categories;
    final rows = (categories.length / _columns).ceil();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HomeLayout.horizontalPadding,
        18,
        HomeLayout.horizontalPadding,
        4,
      ),
      child: Column(
        children: [
          for (var row = 0; row < rows; row++) ...[
            if (row > 0) const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var col = 0; col < _columns; col++) ...[
                  if (col > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _CategoryTile(
                      item: row * _columns + col < categories.length
                          ? categories[row * _columns + col]
                          : null,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.item});

  final CategoryItem? item;

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return const SizedBox(height: HomeCategoriesGrid._tileHeight);
    }

    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.05,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: item!.background,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: item!.emoji != null
                    ? Text(
                        item!.emoji!,
                        style: const TextStyle(fontSize: 28, height: 1),
                      )
                    : const _MoreIcon(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item!.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreIcon extends StatelessWidget {
  const _MoreIcon();

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFB8BFC6);

    Widget square() {
      return Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2.5),
        ),
      );
    }

    return SizedBox(
      width: 22,
      height: 22,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [square(), square()],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [square(), square()],
          ),
        ],
      ),
    );
  }
}
