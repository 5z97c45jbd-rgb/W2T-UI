import 'package:equatable/equatable.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetOtpRequested extends ResetPasswordEvent {
  const ResetOtpRequested({
    required this.userUq,
    required this.password,
    required this.confirmPassword,
  });

  final String userUq;
  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [userUq, password, confirmPassword];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  const ResetPasswordSubmitted({
    required this.userUq,
    required this.password,
    required this.confirmPassword,
    required this.otp,
  });

  final String userUq;
  final String password;
  final String confirmPassword;
  final String otp;

  @override
  List<Object?> get props => [userUq, password, confirmPassword, otp];
}
