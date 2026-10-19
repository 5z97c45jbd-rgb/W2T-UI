import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/features/auth/bloc/login/login_event.dart';
import 'package:w2t_mobile/features/auth/bloc/login/login_state.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_event.dart';
import 'package:w2t_mobile/features/auth/data/auth_api.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthApi api,
    required SessionBloc sessionBloc,
  })  : _api = api,
        _sessionBloc = sessionBloc,
        super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  final AuthApi _api;
  final SessionBloc _sessionBloc;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final identifier = event.identifier.trim();
    if (identifier.isEmpty) {
      emit(LoginState(
        status: LoginStatus.failure,
        errorMessage: event.usePhone
            ? 'Enter your phone number'
            : 'Enter your email',
      ));
      return;
    }
    if (event.usePhone && identifier.length != 10) {
      emit(const LoginState(
        status: LoginStatus.failure,
        errorMessage: 'Enter a 10-digit phone number',
      ));
      return;
    }
    if (event.password.isEmpty) {
      emit(const LoginState(
        status: LoginStatus.failure,
        errorMessage: 'Enter your password',
      ));
      return;
    }

    emit(const LoginState(status: LoginStatus.loading));
    try {
      final session = await _api.login(
        email: event.usePhone ? null : identifier,
        phoneNumber: event.usePhone ? '+91$identifier' : null,
        password: event.password,
      );
      _sessionBloc.add(SessionSignedIn(session));
      emit(const LoginState(status: LoginStatus.success));
    } catch (error) {
      emit(LoginState(
        status: LoginStatus.failure,
        errorMessage: apiErrorMessage(error),
      ));
    }
  }
}
