import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_event.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_state.dart';
import 'package:w2t_mobile/features/auth/data/auth_api.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';
import 'package:w2t_mobile/features/auth/data/models/user_profile.dart';
import 'package:w2t_mobile/features/auth/data/session_store.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({
    required AuthApi api,
    required SessionStore store,
    required AuthTokenHolder tokenHolder,
    AuthSession? storedSession,
  })  : _api = api,
        _store = store,
        _tokenHolder = tokenHolder,
        _storedSession = storedSession,
        super(const SessionState()) {
    _tokenHolder.onUnauthorized = () {
      if (!isClosed) add(const SessionUnauthorized());
    };
    on<SessionStarted>(_onStarted);
    on<SessionSignedIn>(_onSignedIn);
    on<SessionUnauthorized>(_onUnauthorized);
    on<SessionLogoutRequested>(_onLogout);
    on<SessionPersonalizationSubmitted>(_onPersonalizationSubmitted);
    add(const SessionStarted());
  }

  final AuthApi _api;
  final SessionStore _store;
  final AuthTokenHolder _tokenHolder;
  final AuthSession? _storedSession;

  Future<void> _onStarted(
    SessionStarted event,
    Emitter<SessionState> emit,
  ) async {
    emit(const SessionState(status: SessionStatus.restoring));
    final stored = _storedSession ?? await _store.read();
    if (stored == null) {
      emit(const SessionState(status: SessionStatus.unauthenticated));
      return;
    }
    await _hydrate(
      stored,
      emit,
      allowWithoutProfile: false,
    );
  }

  Future<void> _onSignedIn(
    SessionSignedIn event,
    Emitter<SessionState> emit,
  ) async {
    _tokenHolder.accessToken = event.session.accessToken;
    await _store.write(event.session);
    await _hydrate(
      event.session,
      emit,
      allowWithoutProfile: true,
    );
  }

  Future<void> _onUnauthorized(
    SessionUnauthorized event,
    Emitter<SessionState> emit,
  ) async {
    if (!state.isSignedIn && state.status != SessionStatus.restoring) {
      return;
    }
    await _clearLocal();
    emit(const SessionState(
      status: SessionStatus.unauthenticated,
      didExpire: true,
    ));
  }

  Future<void> _onLogout(
    SessionLogoutRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(state.copyWith(isLoggingOut: true));
    try {
      await _api.logout();
    } catch (_) {}
    await _clearLocal();
    emit(const SessionState(status: SessionStatus.unauthenticated));
  }

  Future<void> _onPersonalizationSubmitted(
    SessionPersonalizationSubmitted event,
    Emitter<SessionState> emit,
  ) async {
    final session = state.session;
    if (session == null || !state.isSignedIn) return;
    emit(state.copyWith(
      isUpdatingProfile: true,
      clearProfileUpdateError: true,
    ));
    try {
      await _api.updateProfile(
        userId: session.userId,
        dateOfBirth: event.dateOfBirth,
        color: event.color,
      );
      try {
        final profile = await _api.getProfile(userId: session.userId);
        emit(state.copyWith(
          profile: profile,
          isUpdatingProfile: false,
          clearProfileUpdateError: true,
        ));
      } catch (_) {
        emit(state.copyWith(
          profile:
              (state.profile ?? UserProfile(userId: session.userId)).copyWith(
            dateOfBirth: event.dateOfBirth,
            color: event.color,
          ),
          isUpdatingProfile: false,
          clearProfileUpdateError: true,
        ));
      }
    } catch (error) {
      emit(state.copyWith(
        isUpdatingProfile: false,
        profileUpdateError: apiErrorMessage(error),
      ));
    }
  }

  Future<void> _hydrate(
    AuthSession session,
    Emitter<SessionState> emit, {
    required bool allowWithoutProfile,
  }) async {
    _tokenHolder.accessToken = session.accessToken;
    try {
      final profile = await _api.getProfile(userId: session.userId);
      emit(SessionState(
        status: SessionStatus.authenticated,
        session: session,
        profile: profile,
      ));
    } on ApiException catch (error) {
      if (error.isUnauthorized) {
        await _clearLocal();
        emit(const SessionState(
          status: SessionStatus.unauthenticated,
          didExpire: true,
        ));
        return;
      }
      if (allowWithoutProfile) {
        emit(SessionState(
          status: SessionStatus.authenticated,
          session: session,
        ));
        return;
      }
      emit(const SessionState(status: SessionStatus.unauthenticated));
    } catch (_) {
      if (allowWithoutProfile) {
        emit(SessionState(
          status: SessionStatus.authenticated,
          session: session,
        ));
        return;
      }
      emit(const SessionState(status: SessionStatus.unauthenticated));
    }
  }

  Future<void> _clearLocal() async {
    try {
      await _store.clear();
    } catch (_) {}
    _tokenHolder.accessToken = null;
  }

  @override
  Future<void> close() {
    if (_tokenHolder.onUnauthorized != null) {
      _tokenHolder.onUnauthorized = null;
    }
    return super.close();
  }
}
