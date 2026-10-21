import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_event.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_state.dart';
import 'package:w2t_mobile/features/home/ui/home_screen.dart';
import 'package:w2t_mobile/features/home/ui/locate_screen.dart';
import 'package:w2t_mobile/features/home/ui/orders_screen.dart';
import 'package:w2t_mobile/features/home/ui/profile_screen.dart';
import 'package:w2t_mobile/features/home/widgets/home_bottom_nav_bar.dart';
import 'package:w2t_mobile/features/home/widgets/personalize_profile_dialog.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  HomeTab _currentTab = HomeTab.home;
  bool _personalizeOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeShowPersonalize(context.read<SessionBloc>().state);
    });
  }

  void _maybeShowPersonalize(SessionState state) {
    if (!mounted || _personalizeOpen || !state.needsPersonalization) return;
    _personalizeOpen = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return BlocConsumer<SessionBloc, SessionState>(
          listenWhen: (previous, current) =>
              previous.needsPersonalization && !current.needsPersonalization,
          listener: (context, state) {
            Navigator.of(dialogContext).pop();
          },
          builder: (context, state) {
            return PersonalizeProfileDialog(
              initialDateOfBirth: state.profile?.dateOfBirth,
              initialColor: state.profile?.color,
              isSaving: state.isUpdatingProfile,
              errorMessage: state.profileUpdateError,
              onSave: (value) {
                context.read<SessionBloc>().add(
                      SessionPersonalizationSubmitted(
                        dateOfBirth: value.dateOfBirth,
                        color: value.color,
                      ),
                    );
              },
            );
          },
        );
      },
    ).whenComplete(() {
      if (mounted) _personalizeOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (!state.isSignedIn) {
          context.go(AppRoutes.login);
          return;
        }
        _maybeShowPersonalize(state);
      },
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
