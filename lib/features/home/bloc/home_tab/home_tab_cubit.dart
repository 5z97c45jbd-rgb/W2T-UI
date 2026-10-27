import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/features/home/widgets/home_bottom_nav_bar.dart';

class HomeTabCubit extends Cubit<HomeTab> {
  HomeTabCubit({HomeTab initialTab = HomeTab.home}) : super(initialTab);

  static HomeTabCubit? maybeOf(BuildContext context) {
    try {
      return context.read<HomeTabCubit>();
    } catch (_) {
      return null;
    }
  }

  void select(HomeTab tab) {
    if (state == tab) return;
    emit(tab);
  }
}
