import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_gradient_button.dart';

class KycBottomBar extends StatelessWidget {
  const KycBottomBar({
    super.key,
    required this.nextLabel,
    required this.onNext,
    this.onBack,
    this.nextEnabled = true,
    this.showNextArrow = false,
  });

  final String nextLabel;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final bool nextEnabled;
  final bool showNextArrow;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 12 + bottom),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F3F6))),
      ),
      child: onBack == null
          ? KycGradientButton(
              label: nextLabel,
              onPressed: nextEnabled ? onNext : null,
              showArrow: showNextArrow,
            )
          : Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: onBack,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.kycFieldBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        textStyle: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KycGradientButton(
                    label: nextLabel,
                    onPressed: nextEnabled ? onNext : null,
                    showArrow: showNextArrow,
                  ),
                ),
              ],
            ),
    );
  }
}
