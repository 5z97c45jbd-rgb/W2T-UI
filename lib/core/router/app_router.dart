import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/ui/forgot_password_screen.dart';
import 'package:w2t_mobile/features/auth/ui/full_name_screen.dart';
import 'package:w2t_mobile/features/auth/ui/login_screen.dart';
import 'package:w2t_mobile/features/auth/ui/phone_number_screen.dart';
import 'package:w2t_mobile/features/home/bloc/merchant_list/merchant_list_bloc.dart';
import 'package:w2t_mobile/features/home/data/merchants_api.dart';
import 'package:w2t_mobile/features/home/data/models/merchant.dart';
import 'package:w2t_mobile/features/home/data/models/explore_reels_extra.dart';
import 'package:w2t_mobile/features/home/ui/explore_reels_screen.dart';
import 'package:w2t_mobile/features/home/ui/featured_restaurants_screen.dart';
import 'package:w2t_mobile/features/home/ui/home_shell.dart';
import 'package:w2t_mobile/features/auth/ui/signup_screen.dart';
import 'package:w2t_mobile/features/auth/ui/splash_screen.dart';
import 'package:w2t_mobile/features/auth/ui/welcome_screen.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_business_details_screen.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_category_screen.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_store_location_screen.dart';
import 'package:w2t_mobile/features/kyc/ui/merchant_landing_screen.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_scope.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String fullName = '/signup/full-name';
  static const String phone = '/signup/phone';
  static const String home = '/home';
  static const String featuredRestaurants = '/featured-restaurants';
  static const String exploreReels = '/explore/reels';
  static const String merchantsPath = '/merchants/:category';
  static const String kyc = '/kyc';
  static const String kycCategory = '/kyc/category';
  static const String kycBusiness = '/kyc/business';
  static const String kycLocation = '/kyc/location';

  static String merchants(MerchantCategory category) =>
      '/merchants/${category.apiValue}';
}

const _authGateRoutes = {
  AppRoutes.welcome,
  AppRoutes.login,
  AppRoutes.signup,
  AppRoutes.forgotPassword,
};

GoRouter createAppRouter(SessionBloc sessionBloc) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(sessionBloc.stream),
    redirect: (context, state) {
      final session = sessionBloc.state;
      final location = state.matchedLocation;

      if (!session.isResolved) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      if (session.isSignedIn) {
        if (_authGateRoutes.contains(location)) {
          return AppRoutes.home;
        }
        return null;
      }

      if (location == AppRoutes.home ||
          location == AppRoutes.featuredRestaurants ||
          location == AppRoutes.exploreReels ||
          location.startsWith('/merchants/') ||
          location.startsWith('/kyc')) {
        return session.didExpire ? AppRoutes.login : AppRoutes.welcome;
      }
      return null;
    },
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
          child: HomeShell(),
        ),
      ),
      GoRoute(
        path: AppRoutes.exploreReels,
        name: 'exploreReels',
        pageBuilder: (context, state) {
          final extra = state.extra;
          return MaterialPage(
            child: ExploreReelsScreen(
              extra: extra is ExploreReelsExtra ? extra : null,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.featuredRestaurants,
        name: 'featuredRestaurants',
        redirect: (_, __) => AppRoutes.merchants(MerchantCategory.food),
      ),
      ShellRoute(
        builder: (context, state, child) => KycScope(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.kyc,
            name: 'kyc',
            pageBuilder: (context, state) => const MaterialPage(
              child: MerchantLandingScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.kycCategory,
            name: 'kycCategory',
            pageBuilder: (context, state) => const MaterialPage(
              child: KycCategoryScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.kycBusiness,
            name: 'kycBusiness',
            pageBuilder: (context, state) => const MaterialPage(
              child: KycBusinessDetailsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.kycLocation,
            name: 'kycLocation',
            pageBuilder: (context, state) => const MaterialPage(
              child: KycStoreLocationScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.merchantsPath,
        name: 'merchants',
        pageBuilder: (context, state) {
          final category = MerchantCategory.tryParse(
                state.pathParameters['category'],
              ) ??
              MerchantCategory.food;
          return MaterialPage(
            child: BlocProvider(
              create: (context) => MerchantListBloc(
                api: context.read<MerchantsApi>(),
                category: category,
              ),
              child: FeaturedRestaurantsScreen(category: category),
            ),
          );
        },
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
