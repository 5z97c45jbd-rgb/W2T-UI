import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({
    required this.identifier,
    required this.password,
    required this.usePhone,
  });

  final String identifier;
  final String password;
  final bool usePhone;

  @override
  List<Object?> get props => [identifier, password, usePhone];
}
