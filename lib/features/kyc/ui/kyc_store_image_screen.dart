import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/core/ui/picked_image.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_state.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_image_picker.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_page_scaffold.dart';

/// KYC step 3 continuation: shop / store photo.
class KycStoreImageScreen extends StatelessWidget {
  const KycStoreImageScreen({super.key, this.picker});

  final ImagePicker? picker;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KycRegistrationCubit, KycRegistrationState>(
      builder: (context, state) {
        return KycPageScaffold(
          step: KycWizardStep.location,
          nextLabel: 'Next',
          showNextArrow: true,
          nextEnabled: state.canContinueStoreImage,
          onBack: () => context.go(AppRoutes.kycDocuments),
          onNext: state.canContinueStoreImage
              ? () => context.push(AppRoutes.kycReview)
              : null,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            children: [
              Text(
                'Shop/Store Image',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleNavy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Upload a clear photo of your store',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _StoreImagePicker(
                path: state.storeImagePath,
                onTap: () => _pickImage(context),
              ),
              const SizedBox(height: 16),
              const _PhotoTipsCard(),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final path = await pickKycImage(context, picker: picker);
    if (path == null || !context.mounted) return;
    context.read<KycRegistrationCubit>().updateStoreImagePath(path);
  }
}

class _StoreImagePicker extends StatelessWidget {
  const _StoreImagePicker({required this.path, required this.onTap});

  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final image = pickedImageProvider(path);
    final hasImage = image != null;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Ink(
              height: 188,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFD7E7EE)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (hasImage)
                      Image(image: image!, fit: BoxFit.cover)
                    else
                      const ColoredBox(color: Color(0xFFF3FAFC)),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 18,
                      child: Center(
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.16),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.photo_camera_outlined,
                            color: Color(0xFF5B6B7A),
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Upload Store Image',
          style: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: AppColors.titleNavy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'PNG, JPG or PDF (Max 5 MB)',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _PhotoTipsCard extends StatelessWidget {
  const _PhotoTipsCard();

  static const _tips = [
    'Front view of your store',
    'Visible shop name / signboard',
    'Clear and well lit',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Make sure the photo shows:',
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.titleNavy,
            ),
          ),
          const SizedBox(height: 10),
          for (final tip in _tips)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Color(0xFF22C55E),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        color: AppColors.textSecondary,
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
