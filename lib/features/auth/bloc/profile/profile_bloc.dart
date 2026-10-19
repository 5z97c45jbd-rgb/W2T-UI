import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/features/auth/bloc/profile/profile_event.dart';
import 'package:w2t_mobile/features/auth/bloc/profile/profile_state.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/data/auth_api.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required AuthApi api,
    required SessionBloc sessionBloc,
  })  : _api = api,
        _sessionBloc = sessionBloc,
        super(const ProfileState()) {
    on<ProfileNameSubmitted>(_onNameSubmitted);
    on<ProfilePhoneSubmitted>(_onPhoneSubmitted);
  }

  final AuthApi _api;
  final SessionBloc _sessionBloc;

  void _onNameSubmitted(
    ProfileNameSubmitted event,
    Emitter<ProfileState> emit,
  ) {
    final name = event.fullName.trim();
    if (name.isEmpty) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: 'Enter your full name',
      ));
      return;
    }
    emit(state.copyWith(
      status: ProfileStatus.editing,
      fullName: name,
      clearError: true,
    ));
    emit(state.copyWith(status: ProfileStatus.readyForPhone));
  }

  Future<void> _onPhoneSubmitted(
    ProfilePhoneSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    final phone = event.phoneNumber.trim();
    if (state.fullName.isEmpty) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: 'Enter your full name first',
      ));
      return;
    }
    if (phone.length != 10) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: 'Enter a 10-digit phone number',
      ));
      return;
    }
    final session = _sessionBloc.state.session;
    if (session == null) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: 'Your session expired. Please sign in again.',
      ));
      return;
    }

    emit(state.copyWith(status: ProfileStatus.saving, clearError: true));
    try {
      await _api.updateProfile(
        userId: session.userId,
        fullName: state.fullName,
        phoneNumber: '+91$phone',
      );
      emit(state.copyWith(status: ProfileStatus.saved));
    } catch (error) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMessage: apiErrorMessage(error),
      ));
    }
  }
}
