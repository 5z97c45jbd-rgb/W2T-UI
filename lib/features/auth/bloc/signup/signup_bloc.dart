import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_event.dart';
import 'package:w2t_mobile/features/auth/bloc/signup/signup_event.dart';
import 'package:w2t_mobile/features/auth/bloc/signup/signup_state.dart';
import 'package:w2t_mobile/features/auth/data/auth_api.dart';
import 'package:w2t_mobile/features/auth/data/auth_validators.dart';
import 'package:w2t_mobile/features/auth/data/device_token_service.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required AuthApi api,
    required SessionBloc sessionBloc,
  })  : _api = api,
        _sessionBloc = sessionBloc,
        super(const SignupState()) {
    on<SignupOtpRequested>(_onOtpRequested);
    on<SignupSubmitted>(_onSubmitted);
  }

  final AuthApi _api;
  final SessionBloc _sessionBloc;

  Future<void> _onOtpRequested(
    SignupOtpRequested event,
    Emitter<SignupState> emit,
  ) async {
    if (state.status == SignupStatus.loading) return;

    final error = AuthValidators.signup(
      identifier: event.identifier,
      usePhone: event.usePhone,
      password: event.password,
      confirmPassword: event.confirmPassword,
    );
    if (error != null) {
      emit(SignupState(
        status: SignupStatus.failure,
        otpSent: state.otpSent,
        errorMessage: error,
      ));
      return;
    }

    emit(state.copyWith(status: SignupStatus.loading, clearError: true));
    try {
      final contact = _contact(event.identifier, event.usePhone);
      final deviceToken = await DeviceTokenService.current();
      await _api.requestRegisterOtp(
        email: contact.email,
        phoneNumber: contact.phoneNumber,
        password: event.password,
        deviceToken: deviceToken,
      );
      emit(const SignupState(status: SignupStatus.idle, otpSent: true));
    } catch (error) {
      emit(SignupState(
        status: SignupStatus.failure,
        otpSent: state.otpSent,
        errorMessage: apiErrorMessage(error),
      ));
    }
  }

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    if (state.status == SignupStatus.loading) return;

    final error = AuthValidators.signup(
      identifier: event.identifier,
      usePhone: event.usePhone,
      password: event.password,
      confirmPassword: event.confirmPassword,
      otp: event.otp,
      requireOtp: true,
    );
    if (error != null) {
      emit(SignupState(
        status: SignupStatus.failure,
        otpSent: state.otpSent,
        errorMessage: error,
      ));
      return;
    }
    final otp = event.otp.trim();

    emit(state.copyWith(status: SignupStatus.loading, clearError: true));
    try {
      final contact = _contact(event.identifier, event.usePhone);
      await _api.verifyRegisterOtp(
        email: contact.email,
        phoneNumber: contact.phoneNumber,
        password: event.password,
        otpCode: otp,
      );
      final session = await _api.login(
        email: contact.email,
        phoneNumber: contact.phoneNumber,
        password: event.password,
      );
      _sessionBloc.add(SessionSignedIn(session));
      emit(const SignupState(
        status: SignupStatus.registered,
        otpSent: true,
      ));
    } catch (error) {
      emit(SignupState(
        status: SignupStatus.failure,
        otpSent: true,
        errorMessage: apiErrorMessage(error),
      ));
    }
  }

  ({String? email, String? phoneNumber}) _contact(String identifier, bool usePhone) {
    final trimmed = identifier.trim();
    if (usePhone) return (email: null, phoneNumber: '+91$trimmed');
    return (email: trimmed, phoneNumber: null);
  }
}
