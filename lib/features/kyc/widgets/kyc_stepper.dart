import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_state.dart';

class KycStepper extends StatelessWidget {
  const KycStepper({super.key, required this.current});

  final KycWizardStep current;

  static const _dotSize = 28.0;
  static const _labelWidth = 64.0;
  static const _labels = [
    'Category',
    'Business\nDetails',
    'KYC\nDocuments',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    final activeIndex = current.index;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 8),
      child: SizedBox(
        height: 62,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: (_labelWidth - _dotSize) / 2,
              ),
              child: SizedBox(
                height: _dotSize,
                child: Row(
                  children: [
                    for (var i = 0; i < _labels.length; i++) ...[
                      _StepDot(index: i, activeIndex: activeIndex),
                      if (i < _labels.length - 1)
                        Expanded(
                          child: Container(
                            height: 2.5,
                            color: i < activeIndex
                                ? AppColors.primary
                                : const Color(0xFFD8E6EC),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            Positioned(
              top: _dotSize + 6,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  for (var i = 0; i < _labels.length; i++) ...[
                    if (i > 0) const Spacer(),
                    SizedBox(
                      width: _labelWidth,
                      child: Text(
                        i < activeIndex ? '' : _labels[i],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          height: 1.2,
                          fontWeight: i == activeIndex
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: i == activeIndex
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.index, required this.activeIndex});

  final int index;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final completed = index < activeIndex;
    final active = index == activeIndex;
    return Container(
      width: KycStepper._dotSize,
      height: KycStepper._dotSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed || active ? AppColors.primary : AppColors.white,
        border: Border.all(
          color:
              completed || active ? AppColors.primary : const Color(0xFFD8E6EC),
          width: 1.6,
        ),
      ),
      child: completed
          ? const Icon(Icons.check_rounded, size: 15, color: AppColors.white)
          : Text(
              '${index + 1}',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: active ? AppColors.white : AppColors.textMuted,
              ),
            ),
    );
  }
}
