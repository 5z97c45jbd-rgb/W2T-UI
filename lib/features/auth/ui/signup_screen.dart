import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/bloc/signup/signup_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/signup/signup_event.dart';
import 'package:w2t_mobile/features/auth/bloc/signup/signup_state.dart';
import 'package:w2t_mobile/features/auth/data/auth_validators.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_error_text.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_switch_link.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:w2t_mobile/features/auth/widgets/phone_number_field.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';
import 'package:w2t_mobile/features/auth/widgets/w2t_logo.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _otp = TextEditingController();
  bool _usePhone = false;

  @override
  void initState() {
    super.initState();
    for (final controller in [_email, _phone, _password, _confirm, _otp]) {
      controller.addListener(_onFieldsChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in [_email, _phone, _password, _confirm, _otp]) {
      controller.removeListener(_onFieldsChanged);
    }
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _onFieldsChanged() => setState(() {});

  bool _canRequestOtp() => AuthValidators.canRequestSignupOtp(
        identifier: _usePhone ? _phone.text : _email.text,
        usePhone: _usePhone,
        password: _password.text,
        confirmPassword: _confirm.text,
      );

  bool _canSignUp() => AuthValidators.canSubmitSignup(
        identifier: _usePhone ? _phone.text : _email.text,
        usePhone: _usePhone,
        password: _password.text,
        confirmPassword: _confirm.text,
        otp: _otp.text,
      );

  void _requestOtp() {
    if (!_canRequestOtp()) return;
    context.read<SignupBloc>().add(
          SignupOtpRequested(
            identifier: _usePhone ? _phone.text : _email.text,
            usePhone: _usePhone,
            password: _password.text,
            confirmPassword: _confirm.text,
          ),
        );
  }

  void _signUp() {
    if (!_canSignUp()) return;
    context.read<SignupBloc>().add(
          SignupSubmitted(
            identifier: _usePhone ? _phone.text : _email.text,
            usePhone: _usePhone,
            password: _password.text,
            confirmPassword: _confirm.text,
            otp: _otp.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (previous, current) =>
          previous.status != SignupStatus.registered &&
          current.status == SignupStatus.registered,
      listener: (context, state) => context.go(AppRoutes.home),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                final loading = state.status == SignupStatus.loading;
                return SingleChildScrollView(
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
                                'Sign up',
                                style: GoogleFonts.inter(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create your account to get started',
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
                      _usePhone
                          ? PhoneNumberField(
                              key: const ValueKey('phone'),
                              controller: _phone,
                            )
                          : AuthTextField(
                              key: const ValueKey('email'),
                              hint: 'Email',
                              prefixIcon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              controller: _email,
                            ),
                      AuthSwitchLink(
                        label: _usePhone ? 'Use email' : 'Use Phone?',
                        onPressed: () => setState(() => _usePhone = !_usePhone),
                      ),
                      const SizedBox(height: 6),
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
                      const SizedBox(height: 18),
                      PrimaryButton(
                        label: state.otpSent ? 'Sign Up' : 'Get OTP',
                        isLoading: loading,
                        onPressed: state.otpSent
                            ? (_canSignUp() ? _signUp : null)
                            : (_canRequestOtp() ? _requestOtp : null),
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.login),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
