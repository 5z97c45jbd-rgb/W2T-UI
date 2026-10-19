import 'package:equatable/equatable.dart';

enum ProfileStatus { editing, readyForPhone, saving, saved, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.editing,
    this.fullName = '',
    this.errorMessage,
  });

  final ProfileStatus status;
  final String fullName;
  final String? errorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    String? fullName,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      fullName: fullName ?? this.fullName,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, fullName, errorMessage];
}
