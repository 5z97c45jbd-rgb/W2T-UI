import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/core/ui/app_snack_bar.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_state.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_page_scaffold.dart';

/// KYC step 4: confirm details and pay to submit.
class KycReviewScreen extends StatelessWidget {
  const KycReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KycRegistrationCubit, KycRegistrationState>(
      listenWhen: (previous, current) =>
          (!previous.submitted && current.submitted) ||
          previous.submitError != current.submitError,
      listener: (context, state) {
        if (state.submitError != null && state.submitError!.isNotEmpty) {
          AppSnackBar.show(context, state.submitError!);
          return;
        }
        if (state.submitted) {
          AppSnackBar.show(context, 'Submitted for verification');
          context.go(AppRoutes.home);
        }
      },
      builder: (context, state) {
        final cubit = context.read<KycRegistrationCubit>();
        final canSubmit = state.canSubmit && !state.isSubmitting;
        return KycPageScaffold(
          step: KycWizardStep.review,
          nextLabel: state.isSubmitting ? 'Submitting...' : 'Pay and Submit',
          nextEnabled: canSubmit,
          onBack: () => context.go(AppRoutes.kycStoreImage),
          onNext: canSubmit
              ? () => cubit.submit(
                    userId: context.read<SessionBloc>().state.session?.userId,
                  )
              : null,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              Text(
                'Review & Submit',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleNavy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Please verify your details before submitting',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _BusinessDetailsCard(state: state),
              const SizedBox(height: 12),
              _NavRow(
                icon: Icons.location_on_outlined,
                title: 'Store Location',
                subtitle: [
                  state.addressLine1,
                  state.reviewLocationLine,
                ].where((part) => part.trim().isNotEmpty).join('\n'),
                onTap: () => context.go(AppRoutes.kycLocation),
              ),
              const SizedBox(height: 12),
              _NavRow(
                icon: Icons.description_outlined,
                title: 'KYC Documents',
                subtitle: state.documentsSummary,
                onTap: () => context.go(AppRoutes.kycDocuments),
              ),
              const SizedBox(height: 12),
              _RegistrationFeeCard(amount: state.registrationFeeLabel),
              const SizedBox(height: 16),
              _TermsRow(
                accepted: state.termsAccepted,
                onChanged: cubit.updateTermsAccepted,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BusinessDetailsCard extends StatelessWidget {
  const _BusinessDetailsCard({required this.state});

  final KycRegistrationState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.kycFieldBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A9FB2).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Business Details',
                    style: GoogleFonts.inter(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.titleNavy,
                    ),
                  ),
                ),
                _EditChip(
                  onTap: () => context.go(AppRoutes.kycBusiness),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEF3F6)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                _DetailRow(
                  label: 'Business Category',
                  value: state.category?.label ?? '—',
                ),
                const SizedBox(height: 12),
                _DetailRow(label: 'Business Name', value: state.businessName),
                const SizedBox(height: 12),
                _DetailRow(label: 'Business Type', value: state.businessType),
                const SizedBox(height: 12),
                _DetailRow(label: 'Store Type', value: state.storeTypeLabel),
                const SizedBox(height: 12),
                _DetailRow(label: 'Phone Number', value: state.formattedPhone),
                const SizedBox(height: 12),
                _DetailRow(label: 'Email Address', value: state.email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditChip extends StatelessWidget {
  const _EditChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kycSoftBlue,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.edit_outlined,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 5),
              Text(
                'Edit',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value.isEmpty ? '—' : value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: AppColors.titleNavy,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.kycFieldBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.kycSoftBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.titleNavy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFC5CDD3),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegistrationFeeCard extends StatelessWidget {
  const _RegistrationFeeCard({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kycFieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Registration Fee',
              style: GoogleFonts.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: AppColors.titleNavy,
              ),
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({
    required this.accepted,
    required this.onChanged,
  });

  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!accepted),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accepted ? AppColors.primary : AppColors.white,
              border: Border.all(
                color: accepted ? AppColors.primary : const Color(0xFFB9C8D0),
                width: 1.6,
              ),
            ),
            child: accepted
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                text:
                    'I hereby confirm that the information provided is true and correct. I agree to ',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: 'W2T merchant terms and conditions.',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: AppColors.titleNavy,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
