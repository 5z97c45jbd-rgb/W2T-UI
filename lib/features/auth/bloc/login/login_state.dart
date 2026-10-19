import 'package:equatable/equatable.dart';

enum LoginStatus { idle, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.idle,
    this.errorMessage,
  });

  final LoginStatus status;
  final String? errorMessage;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
