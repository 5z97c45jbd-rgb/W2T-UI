import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_page.dart';
import 'package:w2t_mobile/features/auth/widgets/phone_login_fields.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  String _phone = '';

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: 'Phone Number',
      subtitle: 'Enter your 10-digit mobile number',
      children: [
        PhoneLoginFields(onChanged: (value) => _phone = value),
        const SizedBox(height: 22),
        PrimaryButton(
          label: 'Continue',
          showArrow: true,
          onPressed: () {
            if (_phone.length != 10) return;
            context.push(AppRoutes.confirmPassword);
          },
        ),
      ],
    );
  }
}
