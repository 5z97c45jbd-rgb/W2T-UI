import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_page.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: 'Forgot Password',
      subtitle: 'Enter your email and we will send a reset link',
      children: [
        const AuthTextField(
          hint: 'Email',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 22),
        PrimaryButton(
          label: 'Send Reset Link',
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}
