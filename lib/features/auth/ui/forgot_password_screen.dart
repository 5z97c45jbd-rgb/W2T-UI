import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/bloc/reset_password/reset_password_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/reset_password/reset_password_event.dart';
import 'package:w2t_mobile/features/auth/bloc/reset_password/reset_password_state.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_error_text.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_page.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _userUq = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _otp = TextEditingController();

  @override
  void dispose() {
    _userUq.dispose();
    _password.dispose();
    _confirm.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _requestOtp() {
    context.read<ResetPasswordBloc>().add(
          ResetOtpRequested(
            userUq: _userUq.text,
            password: _password.text,
            confirmPassword: _confirm.text,
          ),
        );
  }

  void _reset() {
    context.read<ResetPasswordBloc>().add(
          ResetPasswordSubmitted(
            userUq: _userUq.text,
            password: _password.text,
            confirmPassword: _confirm.text,
            otp: _otp.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listenWhen: (previous, current) =>
          previous.status != ResetPasswordStatus.success &&
          current.status == ResetPasswordStatus.success,
      listener: (context, state) => context.go(AppRoutes.login),
      child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
        builder: (context, state) {
          final loading = state.status == ResetPasswordStatus.loading;
          return AuthPage(
            title: 'Reset Password',
            subtitle: 'Enter your email or phone and a new password',
            children: [
              AuthTextField(
                hint: 'Email or phone',
                prefixIcon: Icons.person_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                controller: _userUq,
              ),
              const SizedBox(height: 14),
              AuthTextField(
                hint: 'Password',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                controller: _password,
              ),
              const SizedBox(height: 14),
              AuthTextField(
                hint: 'Confirm password',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                controller: _confirm,
              ),
              if (state.otpSent) ...[
                const SizedBox(height: 14),
                AuthTextField(
                  hint: 'Enter OTP',
                  prefixIcon: Icons.pin_outlined,
                  keyboardType: TextInputType.number,
                  controller: _otp,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                ),
              ],
              AuthErrorText(state.errorMessage),
              const SizedBox(height: 22),
              PrimaryButton(
                label: state.otpSent ? 'Reset Password' : 'Get OTP',
                isLoading: loading,
                onPressed: state.otpSent ? _reset : _requestOtp,
              ),
              if (state.otpSent) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: loading ? null : _requestOtp,
                  child: Text(
                    'Resend OTP',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
