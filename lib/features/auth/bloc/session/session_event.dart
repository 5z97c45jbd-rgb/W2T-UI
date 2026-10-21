import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionStarted extends SessionEvent {
  const SessionStarted();
}

class SessionSignedIn extends SessionEvent {
  const SessionSignedIn(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

class SessionUnauthorized extends SessionEvent {
  const SessionUnauthorized();
}

class SessionLogoutRequested extends SessionEvent {
  const SessionLogoutRequested();
}

class SessionPersonalizationSubmitted extends SessionEvent {
  const SessionPersonalizationSubmitted({
    required this.dateOfBirth,
    required this.color,
  });

  final DateTime dateOfBirth;
  final String color;

  @override
  List<Object?> get props => [dateOfBirth, color];
}
