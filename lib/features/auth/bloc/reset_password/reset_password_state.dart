import 'package:equatable/equatable.dart';

enum ResetPasswordStatus { idle, loading, failure, success }

class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.status = ResetPasswordStatus.idle,
    this.otpSent = false,
    this.errorMessage,
  });

  final ResetPasswordStatus status;
  final bool otpSent;
  final String? errorMessage;

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    bool? otpSent,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      otpSent: otpSent ?? this.otpSent,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, otpSent, errorMessage];
}
