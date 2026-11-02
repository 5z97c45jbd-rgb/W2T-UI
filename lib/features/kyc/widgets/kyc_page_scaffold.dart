import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_state.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_bottom_bar.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_header.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_stepper.dart';

class KycPageScaffold extends StatelessWidget {
  const KycPageScaffold({
    super.key,
    required this.step,
    required this.body,
    required this.nextLabel,
    required this.onNext,
    this.onBack,
    this.onHeaderBack,
    this.nextEnabled = true,
    this.showHeaderBack = true,
    this.showNextArrow = false,
  });

  final KycWizardStep step;
  final Widget body;
  final String nextLabel;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final VoidCallback? onHeaderBack;
  final bool nextEnabled;
  final bool showHeaderBack;
  final bool showNextArrow;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              KycHeader(onBack: showHeaderBack ? onHeaderBack ?? onBack : null),
              KycStepper(current: step),
              const SizedBox(height: 4),
              Expanded(child: body),
              KycBottomBar(
                nextLabel: nextLabel,
                onNext: onNext,
                onBack: onBack,
                nextEnabled: nextEnabled,
                showNextArrow: showNextArrow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
