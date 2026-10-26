import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HomeLayout.horizontalPadding,
        6,
        HomeLayout.horizontalPadding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore',
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.titleNavy,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Watch • Learn • Share',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              _HeaderIconButton(
                icon: Icons.search_rounded,
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _HeaderIconButton(
                    icon: Icons.notifications_none_rounded,
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 15,
                      height: 15,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.cartBadge,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '2',
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                  color: AppColors.homeChip,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 19,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search recipes, food, grocery, pharmacy, more...',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
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
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
