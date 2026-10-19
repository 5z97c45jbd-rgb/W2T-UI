import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/features/auth/ui/forgot_password_screen.dart';
import 'package:w2t_mobile/features/auth/ui/full_name_screen.dart';
import 'package:w2t_mobile/features/auth/ui/login_screen.dart';
import 'package:w2t_mobile/features/auth/ui/phone_number_screen.dart';
import 'package:w2t_mobile/features/auth/ui/signed_in_screen.dart';
import 'package:w2t_mobile/features/auth/ui/signup_screen.dart';
import 'package:w2t_mobile/features/auth/ui/splash_screen.dart';
import 'package:w2t_mobile/features/auth/ui/welcome_screen.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String fullName = '/signup/full-name';
  static const String phone = '/signup/phone';
  static const String home = '/home';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      pageBuilder: (context, state) => const MaterialPage(
        child: SplashScreen(),
      ),
    ),
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
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      pageBuilder: (context, state) => const MaterialPage(
        child: SignupScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      pageBuilder: (context, state) => const MaterialPage(
        child: ForgotPasswordScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.fullName,
      name: 'fullName',
      pageBuilder: (context, state) => const MaterialPage(
        child: FullNameScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.phone,
      name: 'phone',
      pageBuilder: (context, state) => const MaterialPage(
        child: PhoneNumberScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      pageBuilder: (context, state) => const MaterialPage(
        child: SignedInScreen(),
      ),
    ),
  ],
);
