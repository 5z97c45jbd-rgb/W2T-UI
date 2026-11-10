import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_state.dart';
import 'package:w2t_mobile/features/home/data/track_orders_content.dart';
import 'package:w2t_mobile/features/home/ui/ai_register_screen.dart';
import 'package:w2t_mobile/features/home/ui/track_orders_screen.dart';
import 'package:w2t_mobile/features/home/widgets/ai_app_bar.dart';
import 'package:w2t_mobile/features/home/widgets/ai_mascot.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  void _openTrackOrders(BuildContext context) {
    OrdersState? state;
    try {
      state = context.read<OrdersBloc>().state;
    } catch (_) {}
    final orders = state != null && state.status == OrdersStatus.success
        ? TrackOrdersContent.fromOrders(state.orders)
        : TrackOrdersContent.samples;
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => TrackOrdersScreen(orders: orders),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = HomeLayout.scrollBottomPadding(context);

    return ColoredBox(
      color: const Color(0xFFF7FBFE),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AiAppBar(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  4,
                  20,
                  bottomInset,
                ),
                children: [
                  const Center(child: AiMascot(size: 236)),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '✨  Hello! I’m ',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1B2A4A),
                          ),
                        ),
                        TextSpan(
                          text: 'W2T AI',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your personal assistant for everything on W2T',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.shopping_cart_outlined,
                          iconColor: const Color(0xFF1AA3C4),
                          iconBackground: const Color(0xFFE7F7FB),
                          title: 'Track my order',
                          onTap: () => _openTrackOrders(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionTile(
                          icon: Icons.storefront_outlined,
                          iconColor: const Color(0xFF7B61C8),
                          iconBackground: const Color(0xFFF1ECFB),
                          title: 'Help me register as a merchant',
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const AiRegisterScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B2A4A),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
