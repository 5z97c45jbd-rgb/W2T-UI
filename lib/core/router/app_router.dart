import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/features/auth/ui/login_screen.dart';
import 'package:w2t_mobile/features/auth/ui/welcome_screen.dart';

abstract final class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.welcome,
  routes: [
    GoRoute(
      path: AppRoutes.welcome,
      name: 'welcome',
      pageBuilder: (context, state) => const MaterialPage(
        child: WelcomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      pageBuilder: (context, state) => const MaterialPage(
        child: LoginScreen(),
      ),
    ),
  ],
);
