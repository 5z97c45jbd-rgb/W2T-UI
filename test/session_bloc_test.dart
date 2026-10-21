import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_event.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_state.dart';
import 'package:w2t_mobile/features/auth/data/auth_api.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';
import 'package:w2t_mobile/features/auth/data/models/user_profile.dart';
import 'package:w2t_mobile/features/auth/data/session_store.dart';

class _MemoryStore extends SessionStore {
  _MemoryStore([this.session]);

  AuthSession? session;

  @override
  Future<AuthSession?> read() async => session;

  @override
  Future<void> write(AuthSession value) async {
    session = value;
  }

  @override
  Future<void> clear() async {
    session = null;
  }
}

class _FakeAuthApi extends AuthApi {
  _FakeAuthApi({this.profile, this.profileError})
      : super(DioClient(AuthTokenHolder()));

  UserProfile? profile;
  Object? profileError;
  int profileCalls = 0;
  Map<String, dynamic>? lastUpdate;

  @override
  Future<UserProfile> getProfile({required String userId}) async {
    profileCalls += 1;
    final error = profileError;
    if (error != null) throw error;
    return profile ??
        UserProfile(userId: userId, fullName: 'Ada Lovelace');
  }

  @override
  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? color,
  }) async {
    lastUpdate = {
      'userId': userId,
      'dateOfBirth': dateOfBirth,
      'color': color,
    };
    profile = (profile ?? UserProfile(userId: userId)).copyWith(
      dateOfBirth: dateOfBirth,
      color: color,
    );
  }

  @override
  Future<void> logout() async {}
}

const _session = AuthSession(
  userId: 'user-1',
  accessToken: 'token-1',
);

void main() {
  test('startup without credentials stays logged out', () async {
    final bloc = SessionBloc(
      api: _FakeAuthApi(),
      store: _MemoryStore(),
      tokenHolder: AuthTokenHolder(),
    );

    final state = await bloc.stream.firstWhere((value) => value.isResolved);
    expect(state.status, SessionStatus.unauthenticated);
    expect(state.isSignedIn, isFalse);
    expect(state.didExpire, isFalse);
    await bloc.close();
  });

  test('startup with valid token hydrates profile and signs in', () async {
    final api = _FakeAuthApi(
      profile: const UserProfile(userId: 'user-1', fullName: 'Ada'),
    );
    final tokens = AuthTokenHolder();
    final bloc = SessionBloc(
      api: api,
      store: _MemoryStore(_session),
      tokenHolder: tokens,
      storedSession: _session,
    );

    final state = await bloc.stream.firstWhere((value) => value.isResolved);
    expect(state.isSignedIn, isTrue);
    expect(state.profile?.fullName, 'Ada');
    expect(tokens.accessToken, 'token-1');
    expect(api.profileCalls, 1);
    await bloc.close();
  });

  test('startup 401 clears storage and expires the session', () async {
    final store = _MemoryStore(_session);
    final tokens = AuthTokenHolder();
    final api = _FakeAuthApi(
      profileError: ApiException('expired', statusCode: 401),
    );
    final bloc = SessionBloc(
      api: api,
      store: store,
      tokenHolder: tokens,
      storedSession: _session,
    );

    final state = await bloc.stream.firstWhere((value) => value.isResolved);
    expect(state.isSignedIn, isFalse);
    expect(state.didExpire, isTrue);
    expect(store.session, isNull);
    expect(tokens.accessToken, isNull);
    await bloc.close();
  });

  test('login persists userId and accessToken then loads profile', () async {
    final store = _MemoryStore();
    final tokens = AuthTokenHolder();
    final bloc = SessionBloc(
      api: _FakeAuthApi(
        profile: const UserProfile(userId: 'user-1', email: 'ada@w2t.test'),
      ),
      store: store,
      tokenHolder: tokens,
    );
    await bloc.stream.firstWhere((value) => value.isResolved);

    bloc.add(const SessionSignedIn(_session));
    final state = await bloc.stream.firstWhere((value) => value.isSignedIn);

    expect(store.session, _session);
    expect(tokens.accessToken, 'token-1');
    expect(state.profile?.email, 'ada@w2t.test');
    await bloc.close();
  });

  test('login 401 from profile/me does not keep the user signed in', () async {
    final store = _MemoryStore();
    final bloc = SessionBloc(
      api: _FakeAuthApi(
        profileError: ApiException('unauthorized', statusCode: 401),
      ),
      store: store,
      tokenHolder: AuthTokenHolder(),
    );
    await bloc.stream.firstWhere((value) => value.isResolved);

    bloc.add(const SessionSignedIn(_session));
    final state = await bloc.stream.firstWhere((value) => value.didExpire);

    expect(state.isSignedIn, isFalse);
    expect(store.session, isNull);
    await bloc.close();
  });

  test('personalization POST updates profile dob and color', () async {
    final api = _FakeAuthApi(
      profile: const UserProfile(userId: 'user-1'),
    );
    final bloc = SessionBloc(
      api: api,
      store: _MemoryStore(_session),
      tokenHolder: AuthTokenHolder(),
      storedSession: _session,
    );
    await bloc.stream.firstWhere((value) => value.isSignedIn);
    expect(bloc.state.needsPersonalization, isTrue);

    final dob = DateTime(1994, 1, 25);
    bloc.add(SessionPersonalizationSubmitted(dateOfBirth: dob, color: 'Blue'));
    final state = await bloc.stream.firstWhere(
      (value) => value.profile?.needsPersonalization == false,
    );

    expect(api.lastUpdate?['color'], 'Blue');
    expect(api.lastUpdate?['dateOfBirth'], dob);
    expect(state.profile?.color, 'Blue');
    expect(state.needsPersonalization, isFalse);
    await bloc.close();
  });
}
