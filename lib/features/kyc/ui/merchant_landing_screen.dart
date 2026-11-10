import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/core/router/safe_nav.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_gradient_button.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_header.dart';

class MerchantLandingScreen extends StatelessWidget {
  const MerchantLandingScreen({super.key});

  static const _benefits = [
    (Icons.assignment_turned_in_outlined, 'List your products or services'),
    (Icons.event_note_outlined, 'Manage orders easily'),
    (Icons.verified_user_outlined, 'Trusted & secure platform'),
    (Icons.groups_outlined, 'Reach local customers'),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE7F7FC),
                Color(0xFFF7FBFE),
                AppColors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      KycHeader(
                        onBack: () => goBackOr(context, AppRoutes.home),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Become a W2T Merchant',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.titleNavy,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Grow your business, reach more\ncustomers in your city',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.45,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 2, 12, 0),
                    child: Transform.scale(
                      scale: 1.08,
                      child: Image.asset(
                        AppAssets.w2tShop,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Column(
                    children: [
                      for (var i = 0; i < _benefits.length; i++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: i == _benefits.length - 1 ? 0 : 14,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: const BoxDecoration(
                                  color: AppColors.kycSoftBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _benefits[i].$1,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _benefits[i].$2,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.titleNavy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      KycGradientButton(
                        label: 'Start KYC Registration',
                        showArrow: true,
                        onPressed: () => context.push(AppRoutes.kycCategory),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
