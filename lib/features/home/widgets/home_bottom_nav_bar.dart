import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';

enum HomeTab { home, order, locate, profile }

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  final HomeTab currentTab;
  final ValueChanged<HomeTab> onTabSelected;

  static const _horizontalInset = 20.0;
  static const _barHeight = 66.0;
  static const _barVerticalPadding = 6.0;
  static const _bottomGap = 10.0;
  static const _fabSize = 56.0;
  static const _fabOverhang = 20.0;

  /// Total vertical space the home body should reserve above the system inset.
  static double contentBottomInset(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return _barHeight + _fabOverhang + _bottomGap + bottomInset;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _horizontalInset,
        0,
        _horizontalInset,
        bottomInset + _bottomGap,
      ),
      child: SizedBox(
        height: _barHeight + _fabOverhang,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final slotWidth = constraints.maxWidth / 4;
            final fabLeft = slotWidth * 2 + (slotWidth - _fabSize) / 2;
            final fabBottom = (_barHeight - _fabSize) / 2 + _fabOverhang * 0.35;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _NavSurface(
                    height: _barHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _barVerticalPadding,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _NavItem(
                              label: 'Home',
                              selectedIcon: Icons.home_rounded,
                              unselectedIcon: Icons.home_outlined,
                              selected: currentTab == HomeTab.home,
                              onTap: () => onTabSelected(HomeTab.home),
                            ),
                          ),
                          Expanded(
                            child: _NavItem(
                              label: 'Order',
                              selectedIcon: Icons.shopping_cart_rounded,
                              unselectedIcon: Icons.shopping_cart_outlined,
                              selected: currentTab == HomeTab.order,
                              onTap: () => onTabSelected(HomeTab.order),
                            ),
                          ),
                          const Expanded(child: SizedBox.shrink()),
                          Expanded(
                            child: _NavItem(
                              label: 'Profile',
                              selectedIcon: Icons.person_rounded,
                              unselectedIcon: Icons.person_outline_rounded,
                              selected: currentTab == HomeTab.profile,
                              onTap: () => onTabSelected(HomeTab.profile),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: fabLeft,
                  bottom: fabBottom,
                  width: _fabSize,
                  height: _fabSize,
                  child: _AiFab(
                    selected: currentTab == HomeTab.locate,
                    onTap: () => onTabSelected(HomeTab.locate),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavSurface extends StatelessWidget {
  const _NavSurface({
    required this.height,
    required this.child,
  });

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AiFab extends StatelessWidget {
  const _AiFab({
    required this.selected,
    required this.onTap,
  });

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'W2T AI',
      selected: selected,
      child: FloatingActionButton(
        heroTag: 'w2t_ai_fab',
        onPressed: onTap,
        elevation: selected ? 8 : 4,
        highlightElevation: 10,
        backgroundColor: selected ? AppColors.primaryDark : AppColors.primary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.auto_awesome_rounded, size: 26),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final bool selected;
  final VoidCallback onTap;

  static const _iconSize = 24.0;
  static const _iconSlotHeight = 28.0;
  static const _labelGap = 3.0;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        selected ? AppColors.textPrimary : AppColors.navInactive;
    final labelColor =
        selected ? AppColors.textPrimary : AppColors.navInactive;

    return Semantics(
      button: true,
      label: label,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: HomeBottomNavBar._barHeight - 8,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFF2F2F4) : Colors.transparent,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: _iconSlotHeight,
                  child: Center(
                    child: Icon(
                      selected ? selectedIcon : unselectedIcon,
                      size: _iconSize,
                      color: iconColor,
                    ),
                  ),
                ),
                const SizedBox(height: _labelGap),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: labelColor,
                    height: 1.1,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
