import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';

class KycGradientButton extends StatelessWidget {
  const KycGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.showArrow = false,
    this.height = 54,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool showArrow;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: enabled
              ? const LinearGradient(
                  colors: [
                    AppColors.kycGradientStart,
                    AppColors.kycGradientEnd
                  ],
                )
              : null,
          color: enabled ? null : AppColors.indicatorInactive,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(28),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  if (showArrow) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: AppColors.white,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
