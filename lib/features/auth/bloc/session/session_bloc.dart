import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_event.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_state.dart';
import 'package:w2t_mobile/features/auth/data/auth_api.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';
import 'package:w2t_mobile/features/auth/data/session_store.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({
    required AuthApi api,
    required SessionStore store,
    required AuthTokenHolder tokenHolder,
    AuthSession? initialSession,
  })  : _api = api,
        _store = store,
        _tokenHolder = tokenHolder,
        super(SessionState(session: initialSession)) {
    if (initialSession != null) {
      _tokenHolder.accessToken = initialSession.accessToken;
    }
    on<SessionSignedIn>(_onSignedIn);
    on<SessionLogoutRequested>(_onLogout);
  }

  final AuthApi _api;
  final SessionStore _store;
  final AuthTokenHolder _tokenHolder;

  Future<void> _onSignedIn(
    SessionSignedIn event,
    Emitter<SessionState> emit,
  ) async {
    _tokenHolder.accessToken = event.session.accessToken;
    await _store.write(event.session);
    emit(SessionState(session: event.session));
  }

  Future<void> _onLogout(
    SessionLogoutRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(state.copyWith(isLoggingOut: true));
    try {
      await _api.logout();
    } catch (_) {}
    try {
      await _store.clear();
    } catch (_) {}
    _tokenHolder.accessToken = null;
    emit(const SessionState());
  }
}
