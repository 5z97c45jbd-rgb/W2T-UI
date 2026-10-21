import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_state.dart';
import 'package:w2t_mobile/features/home/ui/home_screen.dart';
import 'package:w2t_mobile/features/home/ui/locate_screen.dart';
import 'package:w2t_mobile/features/home/ui/orders_screen.dart';
import 'package:w2t_mobile/features/home/ui/profile_screen.dart';
import 'package:w2t_mobile/features/home/widgets/home_bottom_nav_bar.dart';
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  HomeTab _currentTab = HomeTab.home;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listenWhen: (previous, current) =>
          previous.isSignedIn && !current.isSignedIn,
      listener: (context, state) => context.go(AppRoutes.login),
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.homeBackground,
        body: IndexedStack(
          index: _currentTab.index,
          children: const [
            HomeScreen(),
            OrdersScreen(),
            LocateScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: HomeBottomNavBar(
          currentTab: _currentTab,
          onTabSelected: (tab) => setState(() => _currentTab = tab),
        ),
      ),
    );
  }
}
