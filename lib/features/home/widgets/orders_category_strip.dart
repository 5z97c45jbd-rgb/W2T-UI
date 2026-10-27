import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';
import 'package:w2t_mobile/features/home/data/orders_content.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class OrdersCategoryStrip extends StatelessWidget {
  const OrdersCategoryStrip({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          HomeLayout.horizontalPadding,
          16,
          HomeLayout.horizontalPadding,
          0,
        ),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: OrdersContent.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = OrdersContent.categories[index];
          return _CategoryChip(
            item: item,
            selected: item.label == selected,
            onTap: () => onSelected(item.label),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final OrderCategoryFilter item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : item.background,
                shape: BoxShape.circle,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: item.icon != null
                    ? Icon(
                        item.icon,
                        size: 22,
                        color: selected ? AppColors.white : AppColors.primary,
                      )
                    : Text(
                        item.emoji ?? '',
                        style: TextStyle(
                          fontSize: 22,
                          height: 1,
                          color: selected ? AppColors.white : null,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
