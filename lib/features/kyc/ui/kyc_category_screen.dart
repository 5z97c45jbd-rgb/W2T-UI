import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_state.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_category.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_page_scaffold.dart';

class KycCategoryScreen extends StatelessWidget {
  const KycCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KycRegistrationCubit, KycRegistrationState>(
      builder: (context, state) {
        return KycPageScaffold(
          step: KycWizardStep.category,
          nextLabel: 'Next',
          nextEnabled: state.canContinueCategory,
          showHeaderBack: true,
          onHeaderBack: () => context.pop(),
          onNext: state.canContinueCategory
              ? () => context.push(AppRoutes.kycBusiness)
              : null,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
            children: [
              Text(
                'Select Your Category',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleNavy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose the category that best describes your business',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: KycCategory.all.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.86,
                ),
                itemBuilder: (context, index) {
                  final category = KycCategory.all[index];
                  final selected = state.categoryId == category.id;
                  return _CategoryTile(
                    category: category,
                    selected: selected,
                    onTap: () => context
                        .read<KycRegistrationCubit>()
                        .selectCategory(category.id),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final KycCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF3FBFD) : AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.kycFieldBorder,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: category.background,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: category.imageAsset != null
                    ? Image.asset(
                        category.imageAsset!,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      )
                    : Center(
                        child: Text(
                          category.emoji ?? '',
                          style: const TextStyle(fontSize: 22, height: 1),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  category.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleNavy,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
