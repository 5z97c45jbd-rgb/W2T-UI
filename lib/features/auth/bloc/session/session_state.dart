import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';

class SessionState extends Equatable {
  const SessionState({this.session, this.isLoggingOut = false});

  final AuthSession? session;
  final bool isLoggingOut;

  bool get isSignedIn => session != null;

  SessionState copyWith({
    AuthSession? session,
    bool? isLoggingOut,
    bool clearSession = false,
  }) {
    return SessionState(
      session: clearSession ? null : session ?? this.session,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  List<Object?> get props => [session, isLoggingOut];
}
