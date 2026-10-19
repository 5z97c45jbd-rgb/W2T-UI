import 'package:equatable/equatable.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignupOtpRequested extends SignupEvent {
  const SignupOtpRequested({
    required this.identifier,
    required this.usePhone,
    required this.password,
    required this.confirmPassword,
  });

  final String identifier;
  final bool usePhone;
  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [identifier, usePhone, password, confirmPassword];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted({
    required this.identifier,
    required this.usePhone,
    required this.password,
    required this.confirmPassword,
    required this.otp,
  });

  final String identifier;
  final bool usePhone;
  final String password;
  final String confirmPassword;
  final String otp;

  @override
  List<Object?> get props => [identifier, usePhone, password, confirmPassword, otp];
}
