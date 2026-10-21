import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/ui/app_snack_bar.dart';
import 'package:w2t_mobile/features/auth/bloc/login/login_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/login/login_state.dart';
import 'package:w2t_mobile/features/auth/bloc/reset_password/reset_password_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/reset_password/reset_password_state.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_state.dart';
import 'package:w2t_mobile/features/auth/bloc/signup/signup_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/signup/signup_state.dart';

class AuthFeedbackListener extends StatelessWidget {
  const AuthFeedbackListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.status != LoginStatus.success &&
              current.status == LoginStatus.success,
          listener: (context, state) {
            AppSnackBar.show(context, 'Login successful');
          },
        ),
        BlocListener<SignupBloc, SignupState>(
          listenWhen: (previous, current) =>
              previous.status != SignupStatus.registered &&
              current.status == SignupStatus.registered,
          listener: (context, state) {
            AppSnackBar.show(context, 'Register successful');
          },
        ),
        BlocListener<SignupBloc, SignupState>(
          listenWhen: (previous, current) =>
              previous.status == SignupStatus.loading &&
              current.status == SignupStatus.idle &&
              current.otpSent,
          listener: (context, state) {
            AppSnackBar.show(context, 'OTP sent successfully');
          },
        ),
        BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listenWhen: (previous, current) =>
              previous.status != ResetPasswordStatus.success &&
              current.status == ResetPasswordStatus.success,
          listener: (context, state) {
            AppSnackBar.show(context, 'Password reset successfully');
          },
        ),
        BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listenWhen: (previous, current) =>
              previous.status == ResetPasswordStatus.loading &&
              current.status == ResetPasswordStatus.idle &&
              current.otpSent,
          listener: (context, state) {
            AppSnackBar.show(context, 'OTP sent successfully');
          },
        ),
        BlocListener<SessionBloc, SessionState>(
          listenWhen: (previous, current) =>
              previous.isSignedIn &&
              !current.isSignedIn &&
              !current.didExpire,
          listener: (context, state) {
            AppSnackBar.show(context, 'Logged out successfully');
          },
        ),
      ],
      child: child,
    );
  }
}
