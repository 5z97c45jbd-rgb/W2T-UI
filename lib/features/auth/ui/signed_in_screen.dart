import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_event.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_state.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';
import 'package:w2t_mobile/features/auth/widgets/w2t_logo.dart';

class SignedInScreen extends StatelessWidget {
  const SignedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listenWhen: (previous, current) => previous.isSignedIn && !current.isSignedIn,
      listener: (context, state) => context.go(AppRoutes.login),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocBuilder<SessionBloc, SessionState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 32),
                    const W2tLogo(width: 140),
                    const SizedBox(height: 28),
                    Text(
                      'You are signed in',
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.session?.userId ?? '',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: 'Log out',
                      isLoading: state.isLoggingOut,
                      onPressed: () {
                        context.read<SessionBloc>().add(const SessionLogoutRequested());
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
