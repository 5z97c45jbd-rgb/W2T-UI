import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';
import 'package:w2t_mobile/features/auth/widgets/w2t_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.personBackground,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
                child: Column(
                  children: [
                    const W2tLogo(width: 168),
                    const Spacer(),
                    PrimaryButton(
                      label: 'Get Started',
                      showArrow: true,
                      height: 54,
                      onPressed: () => context.push(AppRoutes.login),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Discover. Share. Connect.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
