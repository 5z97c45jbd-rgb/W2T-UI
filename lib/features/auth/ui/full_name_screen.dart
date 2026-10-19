import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/bloc/profile/profile_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/profile/profile_event.dart';
import 'package:w2t_mobile/features/auth/bloc/profile/profile_state.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_error_text.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_page.dart';
import 'package:w2t_mobile/features/auth/widgets/auth_text_field.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';

class FullNameScreen extends StatefulWidget {
  const FullNameScreen({super.key});

  @override
  State<FullNameScreen> createState() => _FullNameScreenState();
}

class _FullNameScreenState extends State<FullNameScreen> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          previous.status != ProfileStatus.readyForPhone &&
          current.status == ProfileStatus.readyForPhone,
      listener: (context, state) => context.push(AppRoutes.phone),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return AuthPage(
            title: 'Full Name',
            subtitle: 'Tell the world who you are',
            children: [
              AuthTextField(
                hint: 'Full name',
                prefixIcon: Icons.badge_outlined,
                keyboardType: TextInputType.name,
                controller: _name,
              ),
              AuthErrorText(
                state.status == ProfileStatus.failure ? state.errorMessage : null,
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: 'Continue',
                showArrow: true,
                onPressed: () {
                  context.read<ProfileBloc>().add(ProfileNameSubmitted(_name.text));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
