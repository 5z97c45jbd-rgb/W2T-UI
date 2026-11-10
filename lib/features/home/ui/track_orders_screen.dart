import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_state.dart';
import 'package:w2t_mobile/features/home/data/models/tracked_order.dart';
import 'package:w2t_mobile/features/home/data/track_orders_content.dart';
import 'package:w2t_mobile/features/home/ui/order_details_screen.dart';
import 'package:w2t_mobile/features/home/widgets/track_order/track_order_carousel_card.dart';
import 'package:w2t_mobile/features/home/widgets/track_order/track_order_chrome.dart';

class TrackOrdersScreen extends StatefulWidget {
  const TrackOrdersScreen({super.key, this.orders});

  final List<TrackedOrder>? orders;

  @override
  State<TrackOrdersScreen> createState() => _TrackOrdersScreenState();
}

class _TrackOrdersScreenState extends State<TrackOrdersScreen> {
  late final PageController _pageController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<TrackedOrder> _resolve(BuildContext context) {
    if (widget.orders != null) return widget.orders!;
    OrdersState? state;
    try {
      state = context.read<OrdersBloc>().state;
    } catch (_) {}
    if (state == null || state.status != OrdersStatus.success) {
      return TrackOrdersContent.samples;
    }
    return TrackOrdersContent.fromOrders(state.orders);
  }

  void _openDetails(TrackedOrder order) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OrderDetailsScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = _resolve(context);
    final rest = orders.length > 1
        ? [
            for (var i = 0; i < orders.length; i++)
              if (i != _index) orders[i],
          ]
        : const <TrackedOrder>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrackOrderAppBar(
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TrackSectionTitle('Track my orders'),
                  const SizedBox(height: 4),
                  Text(
                    'Swipe through your orders, then tap one to follow it live.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (orders.isEmpty)
              const Expanded(child: Center(child: Text('No orders to track')))
            else
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    SizedBox(
                      height: 286,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: orders.length,
                        onPageChanged: (index) => setState(() => _index = index),
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
                            animation: _pageController,
                            builder: (context, child) {
                              var scale = 1.0;
                              if (_pageController.hasClients &&
                                  _pageController.position.haveDimensions) {
                                final page = _pageController.page ??
                                    _index.toDouble();
                                scale = (1 -
                                        (page - index).abs() * 0.045)
                                    .clamp(0.95, 1.0);
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                child: Transform.scale(
                                  scale: scale,
                                  child: child,
                                ),
                              );
                            },
                            child: TrackOrderCarouselCard(
                              order: orders[index],
                              onTap: () => _openDetails(orders[index]),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < orders.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _index ? 18 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: i == _index
                                  ? AppColors.primary
                                  : const Color(0xFFD5DEE4),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                      ],
                    ),
                    if (rest.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
                        child: Text(
                          'More orders',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: TrackOrderStyle.navy,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            for (final order in rest) ...[
                              TrackOrderListTile(
                                order: order,
                                onTap: () => _openDetails(order),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
