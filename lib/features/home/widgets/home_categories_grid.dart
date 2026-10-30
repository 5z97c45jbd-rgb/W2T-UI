import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/home_content.dart';
import 'package:w2t_mobile/features/home/data/models/category_item.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class HomeCategoriesGrid extends StatelessWidget {
  const HomeCategoriesGrid({super.key});

  static const _rowColumns = 3;
  static const _referenceColumns = 5;
  static const _gap = 8.0;
  static const _iconAspectRatio = 1.05;

  static double _tileWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const horizontalInset = HomeLayout.horizontalPadding * 2;
    final available = screenWidth - horizontalInset - _gap * (_referenceColumns - 1);
    return available / _referenceColumns;
  }

  @override
  Widget build(BuildContext context) {
    const categories = HomeContent.categories;
    final rows = (categories.length / _rowColumns).ceil();
    final tileWidth = _tileWidth(context);
    final iconHeight = tileWidth / _iconAspectRatio;

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
                for (var col = 0; col < _rowColumns; col++) ...[
                  if (col > 0) const SizedBox(width: _gap),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _CategoryTile(
                        item: row * _rowColumns + col < categories.length ? categories[row * _rowColumns + col] : null,
                        width: tileWidth,
                        iconHeight: iconHeight,
                      ),
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
  const _CategoryTile({
    required this.item,
    required this.width,
    required this.iconHeight,
  });

  final CategoryItem? item;
  final double width;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return SizedBox(width: width, height: iconHeight + 32);
    }

    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            SizedBox(
              width: width,
              height: iconHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: item!.background,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: item!.imageAsset != null
                      ? Image.asset(
                          item!.imageAsset!,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        )
                      : Center(
                          child: Text(
                            item!.emoji ?? '',
                            style: const TextStyle(fontSize: 28, height: 1),
                          ),
                        ),
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
      ),
    );
  }
}
