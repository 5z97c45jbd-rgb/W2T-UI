import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_state.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_page_scaffold.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_phone_field.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_text_field.dart';

/// KYC step 2: business / store profile.
///
/// Continue goes to store location when category and business fields are valid.
class KycBusinessDetailsScreen extends StatefulWidget {
  const KycBusinessDetailsScreen({super.key});

  @override
  State<KycBusinessDetailsScreen> createState() =>
      _KycBusinessDetailsScreenState();
}

class _KycBusinessDetailsScreenState extends State<KycBusinessDetailsScreen> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _description;

  @override
  void initState() {
    super.initState();
    // Prefill from cubit when returning to this step.
    final state = context.read<KycRegistrationCubit>().state;
    _name = TextEditingController(text: state.businessName);
    _phone = TextEditingController(text: state.phone);
    _email = TextEditingController(text: state.email);
    _description = TextEditingController(text: state.description);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _description.dispose();
    super.dispose();
  }

  /// Bottom sheet of allowed business types (from [KycValidators.businessTypes]).
  Future<void> _pickBusinessType() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            for (final type in KycValidators.businessTypes)
              ListTile(
                title: Text(type, style: GoogleFonts.inter(fontSize: 15)),
                onTap: () => Navigator.of(context).pop(type),
              ),
          ],
        );
      },
    );
    if (selected != null && mounted) {
      context.read<KycRegistrationCubit>().updateBusinessType(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KycRegistrationCubit, KycRegistrationState>(
      builder: (context, state) {
        final cubit = context.read<KycRegistrationCubit>();
        return KycPageScaffold(
          step: KycWizardStep.business,
          nextLabel: 'Continue',
          nextEnabled: state.canContinueBusinessDetails,
          onBack: () => context.go(AppRoutes.kycCategory),
          onNext: state.canContinueBusinessDetails
              ? () => context.push(AppRoutes.kycLocation)
              : null,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            children: [
              Text(
                'Business Details',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleNavy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tell us about your store',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              KycTextField(
                label: 'Business Name',
                hint: 'FreshMart Groceries',
                required: true,
                controller: _name,
                textCapitalization: TextCapitalization.words,
                onChanged: cubit.updateBusinessName,
              ),
              const SizedBox(height: 16),
              KycSelectField(
                label: 'Business Type',
                hint: 'Select type',
                value: state.businessType,
                required: true,
                onTap: _pickBusinessType,
              ),
              const SizedBox(height: 16),
              // Required label with red asterisk, matching other KYC fields.
              Text.rich(
                TextSpan(
                  text: 'Store Type',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleNavy,
                  ),
                  children: const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Color(0xFFE53935)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _StoreTypeChip(
                      label: 'Offline Store',
                      selected: state.storeType == KycStoreType.offline,
                      onTap: () => cubit.updateStoreType(KycStoreType.offline),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StoreTypeChip(
                      label: 'Online Only',
                      selected: state.storeType == KycStoreType.online,
                      onTap: () => cubit.updateStoreType(KycStoreType.online),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              KycPhoneField(
                controller: _phone,
                onChanged: cubit.updatePhone,
              ),
              const SizedBox(height: 16),
              KycTextField(
                label: 'Business Email',
                hint: 'freshmart@example.com',
                required: true,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                onChanged: cubit.updateEmail,
              ),
              const SizedBox(height: 16),
              KycTextField(
                label: 'Store Description',
                hint:
                    'Fresh groceries, fruits, vegetables and daily essentials',
                required: true,
                controller: _description,
                maxLines: 4,
                maxLength: KycValidators.descriptionMaxLength,
                onChanged: cubit.updateDescription,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Toggle chip for Offline Store vs Online Only.
class _StoreTypeChip extends StatelessWidget {
  const _StoreTypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.kycSoftBlue : AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.kycFieldBorder,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
