import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class OrdersSideToggle extends StatelessWidget {
  const OrdersSideToggle({
    super.key,
    required this.side,
    required this.onChanged,
  });

  final OrderSide side;
  final ValueChanged<OrderSide> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HomeLayout.horizontalPadding,
        16,
        HomeLayout.horizontalPadding,
        0,
      ),
      child: Container(
        height: 46,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: _Segment(
                label: 'Sold',
                selected: side == OrderSide.sold,
                onTap: () => onChanged(OrderSide.sold),
              ),
            ),
            Expanded(
              child: _Segment(
                label: 'Purchased',
                selected: side == OrderSide.purchased,
                onTap: () => onChanged(OrderSide.purchased),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
