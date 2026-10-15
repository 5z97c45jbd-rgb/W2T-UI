import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_page.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';

class FullNameScreen extends StatelessWidget {
  const FullNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: 'Full Name',
      subtitle: 'Tell the world who you are',
      children: [
        const AuthTextField(
          hint: 'Full name',
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 22),
        PrimaryButton(
          label: 'Continue',
          showArrow: true,
          onPressed: () => context.push(AppRoutes.phone),
        ),
      ],
    );
  }
}
