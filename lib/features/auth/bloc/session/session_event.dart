import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionSignedIn extends SessionEvent {
  const SessionSignedIn(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

class SessionLogoutRequested extends SessionEvent {
  const SessionLogoutRequested();
}
