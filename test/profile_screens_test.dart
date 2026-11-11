import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_state.dart';
import 'package:w2t_mobile/features/auth/data/auth_api.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';
import 'package:w2t_mobile/features/auth/data/models/user_profile.dart';
import 'package:w2t_mobile/features/auth/data/session_store.dart';
import 'package:w2t_mobile/features/home/ui/edit_profile_screen.dart';
import 'package:w2t_mobile/features/home/ui/profile_screen.dart';
import 'package:w2t_mobile/features/home/ui/select_vehicle_screen.dart';

class _MemoryStore extends SessionStore {
  _MemoryStore(this.session);

  AuthSession? session;

  @override
  Future<AuthSession?> read() async => session;

  @override
  Future<void> write(AuthSession value) async => session = value;

  @override
  Future<void> clear() async => session = null;
}

class _FakeAuthApi extends AuthApi {
  _FakeAuthApi(this.profile) : super(DioClient(AuthTokenHolder()));

  UserProfile profile;
  Map<String, dynamic>? lastUpdate;

  @override
  Future<UserProfile> getProfile({required String userId}) async => profile;

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
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'color': color,
    };
    profile = profile.copyWith(
      fullName: fullName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      color: color,
    );
  }

  @override
  Future<void> logout() async {}
}

const _session = AuthSession(userId: 'user-1', accessToken: 'token-1');

({SessionBloc bloc, _FakeAuthApi api}) _signedIn() {
  final api = _FakeAuthApi(
    UserProfile(
      userId: 'user-1',
      fullName: 'Akhilesh V',
      email: 'akhilesh@example.com',
      phoneNumber: '9876543210',
      dateOfBirth: DateTime(1994, 1, 25),
      color: 'Blue',
      location: 'Hanamkonda, Warangal',
      gender: 'Male',
    ),
  );
  return (
    bloc: SessionBloc(
      api: api,
      store: _MemoryStore(_session),
      tokenHolder: AuthTokenHolder(),
      storedSession: _session,
    ),
    api: api,
  );
}

Future<SessionBloc> _signedInBloc() async {
  final signedIn = _signedIn();
  await signedIn.bloc.stream
      .firstWhere((value) => value.status != SessionStatus.restoring);
  return signedIn.bloc;
}

void main() {
  testWidgets('profile screen keeps logout and adds distributor CTA',
      (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final bloc = await _signedInBloc();
    addTearDown(bloc.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.text('View your profile information'), findsOneWidget);
    expect(find.text('Akhilesh V'), findsWidgets);
    expect(find.text('Favourite Color'), findsOneWidget);
    expect(find.text('Blue'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Account Type'), 80);
    expect(find.text('Account Type'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Be a Distributor'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
    expect(find.text('Verified'), findsWidgets);
  });

  testWidgets('edit profile matches the form layout', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final bloc = await _signedInBloc();
    addTearDown(bloc.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: const MaterialApp(home: EditProfileScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Update your information'), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.textContaining('Full Name'), findsWidgets);
    expect(find.textContaining('Phone Number'), findsOneWidget);
    expect(find.textContaining('Email Address'), findsOneWidget);
    expect(find.textContaining('Location'), findsOneWidget);
    expect(find.textContaining('Date of Birth'), findsOneWidget);
    expect(find.textContaining('Gender'), findsOneWidget);
    expect(find.textContaining('Favourite Color'), findsOneWidget);
    expect(find.text('Blue'), findsOneWidget);
  });

  testWidgets('edit profile save posts the profile update', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final signedIn = _signedIn();
    addTearDown(signedIn.bloc.close);
    await signedIn.bloc.stream
        .firstWhere((value) => value.status != SessionStatus.restoring);

    await tester.pumpWidget(
      BlocProvider.value(
        value: signedIn.bloc,
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const EditProfileScreen(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Akhilesh Reddy');
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(signedIn.api.lastUpdate?['fullName'], 'Akhilesh Reddy');
    expect(signedIn.api.lastUpdate?['phoneNumber'], '9876543210');
    expect(signedIn.api.lastUpdate?['color'], 'Blue');
  });

  testWidgets('select vehicle screen shows saved vehicles and add form',
      (tester) async {
    tester.view.physicalSize = const Size(390, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: SelectVehicleScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Select Vehicle for Delivery'), findsOneWidget);
    expect(
      tester.getSize(find.byType(ClipRRect)).height,
      greaterThan(tester.view.physicalSize.height * 0.9),
    );
    expect(find.text('Your Saved Vehicles'), findsOneWidget);
    expect(find.text('My Vehicles'), findsNothing);
    expect(find.byTooltip('Add'), findsOneWidget);
    expect(find.byTooltip('Edit'), findsNWidgets(2));
    expect(find.byTooltip('Delete'), findsNWidgets(2));
    expect(find.text('Tata Ace – TS03AB1234'), findsOneWidget);
    expect(find.text('Hero Splendor – TS03EF5678'), findsOneWidget);

    await tester.tap(find.byTooltip('Add'));
    await tester.pumpAndSettle();
    expect(find.text('Add New Vehicle'), findsOneWidget);
    expect(find.text('Save Vehicle'), findsOneWidget);
    expect(find.text('Truck'), findsOneWidget);
    expect(find.text('Scooter'), findsOneWidget);
  });
}
