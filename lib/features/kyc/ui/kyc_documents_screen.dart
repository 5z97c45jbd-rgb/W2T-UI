import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_state.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_image_picker.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_page_scaffold.dart';

/// KYC step 3: document numbers plus optional Aadhaar photo upload.
class KycDocumentsScreen extends StatefulWidget {
  const KycDocumentsScreen({super.key, this.picker});

  final ImagePicker? picker;

  @override
  State<KycDocumentsScreen> createState() => _KycDocumentsScreenState();
}

class _KycDocumentsScreenState extends State<KycDocumentsScreen> {
  late final TextEditingController _pan;
  late final TextEditingController _gstin;
  late final TextEditingController _shop;
  late final TextEditingController _fssai;

  @override
  void initState() {
    super.initState();
    final state = context.read<KycRegistrationCubit>().state;
    _pan = TextEditingController(text: state.pan);
    _gstin = TextEditingController(text: state.gstin);
    _shop = TextEditingController(text: state.shopEstablishment);
    _fssai = TextEditingController(text: state.fssai);
  }

  @override
  void dispose() {
    _pan.dispose();
    _gstin.dispose();
    _shop.dispose();
    _fssai.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KycRegistrationCubit, KycRegistrationState>(
      builder: (context, state) {
        final cubit = context.read<KycRegistrationCubit>();
        return KycPageScaffold(
          step: KycWizardStep.location,
          nextLabel: 'Continue',
          showNextArrow: true,
          nextEnabled: state.canContinueDocuments,
          onBack: () => context.go(AppRoutes.kycLocation),
          onNext: state.canContinueDocuments
              ? () => context.push(AppRoutes.kycStoreImage)
              : null,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            children: [
              Text(
                'KYC Documents',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleNavy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                state.isSelfTalent
                    ? 'Enter your PAN so we can confirm you are an Indian resident'
                    : 'Please enter clear and valid document numbers',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              _DocumentNumberCard(
                icon: Icons.badge_outlined,
                title: 'PAN Card',
                hint: 'ABCDE1234F',
                helper: state.isSelfTalent
                    ? 'PAN is required to verify Indian residency'
                    : 'Enter your 10-character PAN',
                errorText: KycValidators.panError(state.pan),
                controller: _pan,
                required: true,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                  LengthLimitingTextInputFormatter(10),
                  const _UpperCaseFormatter(),
                ],
                onChanged: cubit.updatePan,
              ),
              if (state.requiresBusinessNumbers) ...[
                const SizedBox(height: 12),
                _DocumentNumberCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'GSTIN Number',
                  hint: '22AAAAA0000A1Z5',
                  helper: '15-character GST identification number',
                  errorText: KycValidators.gstinError(state.gstin),
                  controller: _gstin,
                  required: true,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                    LengthLimitingTextInputFormatter(15),
                    const _UpperCaseFormatter(),
                  ],
                  onChanged: cubit.updateGstin,
                ),
                const SizedBox(height: 12),
                _DocumentNumberCard(
                  icon: Icons.storefront_outlined,
                  title: 'Shop Establishment Number',
                  hint: 'TL/HNK/ALE/12345/2024',
                  helper: 'Shop and Establishment Act registration number',
                  errorText:
                      KycValidators.shopEstablishmentError(state.shopEstablishment),
                  controller: _shop,
                  required: true,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(40),
                    const _UpperCaseFormatter(),
                  ],
                  onChanged: cubit.updateShopEstablishment,
                ),
              ],
              if (state.requiresFssai) ...[
                const SizedBox(height: 12),
                _DocumentNumberCard(
                  icon: Icons.restaurant_outlined,
                  title: 'FSSAI Number',
                  hint: '11223344556677',
                  helper: '14-digit food safety licence number',
                  errorText: KycValidators.fssaiError(state.fssai),
                  controller: _fssai,
                  required: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(14),
                  ],
                  onChanged: cubit.updateFssai,
                ),
              ],
              const SizedBox(height: 12),
              _AadhaarUploadCard(
                path: state.aadhaarImagePath,
                onTap: () => _pickAadhaar(context),
              ),
              const SizedBox(height: 16),
              const _SecureInfoBanner(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAadhaar(BuildContext context) async {
    final path = await pickKycImage(context, picker: widget.picker);
    if (path == null || !context.mounted) return;
    context.read<KycRegistrationCubit>().updateAadhaarImagePath(path);
  }
}

class _AadhaarUploadCard extends StatelessWidget {
  const _AadhaarUploadCard({required this.path, required this.onTap});

  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final file = path == null ? null : File(path!);
    final hasImage = file != null && file.existsSync();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kycFieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.kycSoftBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.credit_card_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aadhaar Card',
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.titleNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Optional. Add a clear photo of your Aadhaar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                height: 132,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FBFD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.kycFieldBorder),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: hasImage
                      ? Image.file(file, fit: BoxFit.cover)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_a_photo_outlined,
                              color: AppColors.primary,
                              size: 26,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add Aadhaar photo',
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.titleNavy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'PNG or JPG (Max 5 MB)',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentNumberCard extends StatelessWidget {
  const _DocumentNumberCard({
    required this.icon,
    required this.title,
    required this.hint,
    required this.helper,
    required this.controller,
    required this.onChanged,
    required this.inputFormatters,
    this.errorText,
    this.keyboardType,
    this.required = false,
  });

  final IconData icon;
  final String title;
  final String hint;
  final String helper;
  final String? errorText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType? keyboardType;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kycFieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.kycSoftBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: title,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.titleNavy,
                        ),
                        children: [
                          if (required)
                            const TextSpan(
                              text: ' *',
                              style: TextStyle(color: Color(0xFFE53935)),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      helper,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: GoogleFonts.inter(
              fontSize: 14.5,
              color: AppColors.textPrimary,
              letterSpacing: 0.4,
            ),
            decoration: InputDecoration(
              hintText: hint,
              errorText: errorText,
              errorStyle: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFFE53935),
              ),
              hintStyle: GoogleFonts.inter(
                fontSize: 14.5,
                color: AppColors.textMuted,
                letterSpacing: 0,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FBFD),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: _border(AppColors.kycFieldBorder),
              enabledBorder: _border(
                errorText == null
                    ? AppColors.kycFieldBorder
                    : const Color(0xFFE53935),
              ),
              focusedBorder: _border(
                errorText == null ? AppColors.primary : const Color(0xFFE53935),
              ),
              errorBorder: _border(const Color(0xFFE53935)),
              focusedErrorBorder: _border(const Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );
  }
}

class _SecureInfoBanner extends StatelessWidget {
  const _SecureInfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your information is secure',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We use industry standard encryption to keep your documents and information safe.',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    height: 1.35,
                    color: AppColors.textSecondary,
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

class _UpperCaseFormatter extends TextInputFormatter {
  const _UpperCaseFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
