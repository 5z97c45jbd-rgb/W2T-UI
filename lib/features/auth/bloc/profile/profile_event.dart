import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileNameSubmitted extends ProfileEvent {
  const ProfileNameSubmitted(this.fullName);

  final String fullName;

  @override
  List<Object?> get props => [fullName];
}

class ProfilePhoneSubmitted extends ProfileEvent {
  const ProfilePhoneSubmitted(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object?> get props => [phoneNumber];
}
