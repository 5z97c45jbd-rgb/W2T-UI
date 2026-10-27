import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class OrdersHeader extends StatelessWidget {
  const OrdersHeader({
    super.key,
    required this.subtitle,
    required this.searching,
    required this.controller,
    required this.onBack,
    required this.onSearchToggled,
    required this.onFilter,
  });

  final String subtitle;
  final bool searching;
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onSearchToggled;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HomeLayout.horizontalPadding,
        12,
        HomeLayout.horizontalPadding,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _CircleIconButton(
            icon: Icons.chevron_left_rounded,
            onPressed: onBack,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: searching
                ? TextField(
                    autofocus: true,
                    controller: controller,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search orders',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.titleNavy,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Orders',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.titleNavy,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
          ),
          _CircleIconButton(
            icon: searching ? Icons.close_rounded : Icons.search_rounded,
            onPressed: onSearchToggled,
          ),
          const SizedBox(width: 8),
          _CircleIconButton(
            icon: Icons.tune_rounded,
            onPressed: onFilter,
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 22, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
