import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';
import 'package:w2t_mobile/features/auth/data/models/user_profile.dart';

enum SessionStatus { restoring, authenticated, unauthenticated }

class SessionState extends Equatable {
  const SessionState({
    this.status = SessionStatus.restoring,
    this.session,
    this.profile,
    this.isLoggingOut = false,
    this.didExpire = false,
    this.isUpdatingProfile = false,
    this.profileUpdateError,
    this.avatarPath,
  });

  final SessionStatus status;
  final AuthSession? session;
  final UserProfile? profile;
  final bool isLoggingOut;
  final bool didExpire;
  final bool isUpdatingProfile;
  final String? profileUpdateError;
  final String? avatarPath;

  bool get needsPersonalization =>
      isSignedIn && (profile?.needsPersonalization ?? true);

  bool get isSignedIn =>
      status == SessionStatus.authenticated && session != null;

  bool get isResolved => status != SessionStatus.restoring;

  SessionState copyWith({
    SessionStatus? status,
    AuthSession? session,
    UserProfile? profile,
    bool? isLoggingOut,
    bool? didExpire,
    bool? isUpdatingProfile,
    String? profileUpdateError,
    String? avatarPath,
    bool clearSession = false,
    bool clearProfile = false,
    bool clearProfileUpdateError = false,
    bool clearAvatarPath = false,
  }) {
    return SessionState(
      status: status ?? this.status,
      session: clearSession ? null : session ?? this.session,
      profile: clearProfile ? null : profile ?? this.profile,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      didExpire: didExpire ?? this.didExpire,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
      profileUpdateError: clearProfileUpdateError
          ? null
          : profileUpdateError ?? this.profileUpdateError,
      avatarPath: clearAvatarPath ? null : avatarPath ?? this.avatarPath,
    );
  }

  @override
  List<Object?> get props => [
        status,
        session,
        profile,
        isLoggingOut,
        didExpire,
        isUpdatingProfile,
        profileUpdateError,
        avatarPath,
      ];
}
