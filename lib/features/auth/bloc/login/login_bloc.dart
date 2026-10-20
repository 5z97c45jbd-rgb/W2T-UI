import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/features/auth/bloc/login/login_event.dart';
import 'package:w2t_mobile/features/auth/bloc/login/login_state.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_event.dart';
import 'package:w2t_mobile/features/auth/data/auth_api.dart';
import 'package:w2t_mobile/features/auth/data/auth_validators.dart';

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
    if (state.status == LoginStatus.loading) return;

    final error = AuthValidators.login(
      identifier: event.identifier,
      password: event.password,
      usePhone: event.usePhone,
    );
    if (error != null) {
      emit(LoginState(
        status: LoginStatus.failure,
        errorMessage: error,
      ));
      return;
    }

    emit(const LoginState(status: LoginStatus.loading));
    try {
      final identifier = event.identifier.trim();
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
