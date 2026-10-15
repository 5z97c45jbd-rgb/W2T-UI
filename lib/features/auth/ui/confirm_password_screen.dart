import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_page.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  const ConfirmPasswordScreen({super.key});

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (_password.text.isEmpty || _confirm.text.isEmpty) {
      setState(() => _error = 'Enter and confirm your password');
      return;
    }
    if (_password.text != _confirm.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: 'Confirm Password',
      subtitle: 'Choose a password for your account',
      children: [
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
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(
            _error!,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFE53935),
            ),
          ),
        ],
        const SizedBox(height: 22),
        PrimaryButton(
          label: 'Create Account',
          onPressed: _submit,
        ),
      ],
    );
  }
}
