import 'package:equatable/equatable.dart';

enum SignupStatus { idle, loading, failure, registered }

class SignupState extends Equatable {
  const SignupState({
    this.status = SignupStatus.idle,
    this.otpSent = false,
    this.errorMessage,
  });

  final SignupStatus status;
  final bool otpSent;
  final String? errorMessage;

  SignupState copyWith({
    SignupStatus? status,
    bool? otpSent,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignupState(
      status: status ?? this.status,
      otpSent: otpSent ?? this.otpSent,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, otpSent, errorMessage];
}
