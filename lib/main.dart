import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/core/theme/app_theme.dart';
import 'package:w2t_mobile/features/auth/bloc/login/login_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/profile/profile_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/reset_password/reset_password_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/signup/signup_bloc.dart';
import 'package:w2t_mobile/features/auth/data/auth_api.dart';
import 'package:w2t_mobile/features/auth/data/device_token_service.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';
import 'package:w2t_mobile/features/auth/data/session_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DeviceTokenService.ensureInitialized();
  final session = await SessionStore().read();
  runApp(W2tApp(initialSession: session));
}

class W2tApp extends StatefulWidget {
  const W2tApp({super.key, this.initialSession});

  final AuthSession? initialSession;

  @override
  State<W2tApp> createState() => _W2tAppState();
}

class _W2tAppState extends State<W2tApp> {
  late final AuthTokenHolder _tokenHolder;
  late final SessionStore _sessionStore;
  late final AuthApi _api;

  @override
  void initState() {
    super.initState();
    _tokenHolder = AuthTokenHolder()
      ..accessToken = widget.initialSession?.accessToken;
    _sessionStore = SessionStore();
    _api = AuthApi(DioClient(_tokenHolder));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SessionBloc(
            api: _api,
            store: _sessionStore,
            tokenHolder: _tokenHolder,
            initialSession: widget.initialSession,
          ),
        ),
        BlocProvider(
          create: (context) => LoginBloc(
            api: _api,
            sessionBloc: context.read<SessionBloc>(),
          ),
        ),
        BlocProvider(
          create: (context) => SignupBloc(
            api: _api,
            sessionBloc: context.read<SessionBloc>(),
          ),
        ),
        BlocProvider(
          create: (_) => ResetPasswordBloc(api: _api),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            api: _api,
            sessionBloc: context.read<SessionBloc>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'W2T',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: appRouter,
      ),
    );
  }
}
