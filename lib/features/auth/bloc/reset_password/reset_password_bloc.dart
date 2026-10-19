import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/features/auth/bloc/reset_password/reset_password_event.dart';
import 'package:w2t_mobile/features/auth/bloc/reset_password/reset_password_state.dart';
import 'package:w2t_mobile/features/auth/data/auth_api.dart';
import 'package:w2t_mobile/features/auth/data/device_token_service.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({required AuthApi api})
      : _api = api,
        super(const ResetPasswordState()) {
    on<ResetOtpRequested>(_onOtpRequested);
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  final AuthApi _api;

  Future<void> _onOtpRequested(
    ResetOtpRequested event,
    Emitter<ResetPasswordState> emit,
  ) async {
    final error = _validate(
      userUq: event.userUq,
      password: event.password,
      confirmPassword: event.confirmPassword,
    );
    if (error != null) {
      emit(ResetPasswordState(
        status: ResetPasswordStatus.failure,
        otpSent: state.otpSent,
        errorMessage: error,
      ));
      return;
    }

    emit(state.copyWith(status: ResetPasswordStatus.loading, clearError: true));
    try {
      final deviceToken = await DeviceTokenService.current();
      await _api.requestResetOtp(
        userUq: event.userUq.trim(),
        deviceToken: deviceToken,
      );
      emit(const ResetPasswordState(
        status: ResetPasswordStatus.idle,
        otpSent: true,
      ));
    } catch (error) {
      emit(ResetPasswordState(
        status: ResetPasswordStatus.failure,
        otpSent: state.otpSent,
        errorMessage: apiErrorMessage(error),
      ));
    }
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    final error = _validate(
      userUq: event.userUq,
      password: event.password,
      confirmPassword: event.confirmPassword,
    );
    if (error != null) {
      emit(ResetPasswordState(
        status: ResetPasswordStatus.failure,
        otpSent: state.otpSent,
        errorMessage: error,
      ));
      return;
    }
    final otp = event.otp.trim();
    if (otp.isEmpty) {
      emit(const ResetPasswordState(
        status: ResetPasswordStatus.failure,
        otpSent: true,
        errorMessage: 'Enter the OTP',
      ));
      return;
    }

    emit(state.copyWith(status: ResetPasswordStatus.loading, clearError: true));
    try {
      await _api.resetPassword(
        userUq: event.userUq.trim(),
        newPassword: event.password,
        otp: otp,
      );
      emit(const ResetPasswordState(
        status: ResetPasswordStatus.success,
        otpSent: true,
      ));
    } catch (error) {
      emit(ResetPasswordState(
        status: ResetPasswordStatus.failure,
        otpSent: true,
        errorMessage: apiErrorMessage(error),
      ));
    }
  }

  String? _validate({
    required String userUq,
    required String password,
    required String confirmPassword,
  }) {
    if (userUq.trim().isEmpty) {
      return 'Enter your email or phone number';
    }
    if (password.isEmpty || confirmPassword.isEmpty) {
      return 'Enter and confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
