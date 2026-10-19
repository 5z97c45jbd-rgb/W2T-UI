import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/bloc/profile/profile_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/profile/profile_event.dart';
import 'package:w2t_mobile/features/auth/bloc/profile/profile_state.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_error_text.dart';
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
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          previous.status != ProfileStatus.saved &&
          current.status == ProfileStatus.saved,
      listener: (context, state) => context.go(AppRoutes.home),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final saving = state.status == ProfileStatus.saving;
          return AuthPage(
            title: 'Phone Number',
            subtitle: 'Enter your 10-digit mobile number',
            children: [
              PhoneLoginFields(onChanged: (value) => _phone = value),
              AuthErrorText(state.errorMessage),
              const SizedBox(height: 22),
              PrimaryButton(
                label: 'Continue',
                showArrow: true,
                isLoading: saving,
                onPressed: () {
                  context.read<ProfileBloc>().add(ProfilePhoneSubmitted(_phone));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
