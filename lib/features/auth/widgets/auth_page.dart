import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/auth/widgets/w2t_logo.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                    padding: const EdgeInsets.only(left: 0, top: 8),
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(child: W2tLogo(width: 130)),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.45,
                      child: Image.asset(
                        AppAssets.loginMapBackground,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                ...children,
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
