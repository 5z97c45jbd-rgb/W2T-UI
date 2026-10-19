import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/bloc/login/login_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/login/login_event.dart';
import 'package:w2t_mobile/features/auth/bloc/login/login_state.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_error_text.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_switch_link.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:w2t_mobile/features/auth/widgets/phone_number_field.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';
import 'package:w2t_mobile/features/auth/widgets/social_login_button.dart';
import 'package:w2t_mobile/features/auth/widgets/w2t_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _usePhone = false;

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<LoginBloc>().add(
          LoginSubmitted(
            identifier: _usePhone ? _phone.text : _email.text,
            password: _password.text,
            usePhone: _usePhone,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.status != LoginStatus.success &&
          current.status == LoginStatus.success,
      listener: (context, state) => context.go(AppRoutes.home),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                final loading = state.status == LoginStatus.loading;
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
                                'Welcome Back',
                                style: GoogleFonts.inter(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Login to continue your journey',
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
                        label: _usePhone ? 'Try Email' : 'Try Phone?',
                        onPressed: () => setState(() => _usePhone = !_usePhone),
                      ),
                      const SizedBox(height: 6),
                      AuthTextField(
                        hint: 'Password',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: true,
                        controller: _password,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push(AppRoutes.forgotPassword),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      AuthErrorText(state.errorMessage),
                      const SizedBox(height: 18),
                      PrimaryButton(
                        label: 'Login',
                        isLoading: loading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: 22),
                      const _OrDivider(),
                      const SizedBox(height: 22),
                      SocialLoginButton(
                        label: 'Continue with Google',
                        leading: Image.asset(
                          AppAssets.googleIcon,
                          width: 24,
                          height: 24,
                          filterQuality: FilterQuality.high,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 12),
                      SocialLoginButton(
                        label: 'Continue with Apple',
                        leading: const Icon(
                          Icons.apple,
                          size: 24,
                          color: AppColors.textPrimary,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.signup),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, height: 1)),
      ],
    );
  }
}
