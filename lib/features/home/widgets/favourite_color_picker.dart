import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/features/home/data/favourite_colors.dart';

class FavouriteColorPicker extends StatelessWidget {
  const FavouriteColorPicker({
    super.key,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
  });

  final FavouriteColor selected;
  final ValueChanged<FavouriteColor> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            for (final color in FavouriteColor.options)
              _ColorDot(
                color: color,
                selected: color.name == selected.name,
                onTap: enabled ? () => onSelected(color) : null,
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          selected.name,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final FavouriteColor color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isLight = color.name == 'White';
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.value,
          border: Border.all(
            color: selected
                ? const Color(0xFF2563EB)
                : isLight
                    ? const Color(0xFFE5E7EB)
                    : Colors.transparent,
            width: selected ? 3 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: selected
            ? Icon(
                Icons.check_rounded,
                size: 18,
                color: isLight ? const Color(0xFF2563EB) : Colors.white,
              )
            : null,
      ),
    );
  }
}
