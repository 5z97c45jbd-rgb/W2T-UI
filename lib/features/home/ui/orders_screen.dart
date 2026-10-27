import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/bloc/home_tab/home_tab_cubit.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_event.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_state.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';
import 'package:w2t_mobile/features/home/widgets/home_bottom_nav_bar.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';
import 'package:w2t_mobile/features/home/widgets/order_list_card.dart';
import 'package:w2t_mobile/features/home/widgets/orders_category_strip.dart';
import 'package:w2t_mobile/features/home/widgets/orders_header.dart';
import 'package:w2t_mobile/features/home/widgets/orders_side_toggle.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _searching = false;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      context.read<OrdersBloc>().add(OrdersQueryChanged(_searchController.text));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = HomeLayout.scrollBottomPadding(context);

    return ColoredBox(
      color: AppColors.homeBackground,
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          final orders = state.visibleOrders;
          return CustomScrollView(
            slivers: [
              SliverSafeArea(
                bottom: false,
                minimum: const EdgeInsets.only(top: 18),
                sliver: SliverToBoxAdapter(
                  child: OrdersHeader(
                    subtitle: state.subtitle,
                    searching: _searching,
                    controller: _searchController,
                    onBack: () {
                      HomeTabCubit.maybeOf(context)?.select(HomeTab.home);
                    },
                    onSearchToggled: () {
                      setState(() => _searching = !_searching);
                      if (_searching) return;
                      _searchController.clear();
                    },
                    onFilter: () => _showSortSheet(context, state.sort),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: OrdersSideToggle(
                  side: state.side,
                  onChanged: (side) {
                    context.read<OrdersBloc>().add(OrdersSideChanged(side));
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: OrdersCategoryStrip(
                  selected: state.category,
                  onSelected: (category) {
                    context
                        .read<OrdersBloc>()
                        .add(OrdersCategoryChanged(category));
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: _CountAndSort(
                  count: orders.length,
                  sort: state.sort,
                  onSort: () => _showSortSheet(context, state.sort),
                ),
              ),
              if (orders.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyOrders(),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    HomeLayout.horizontalPadding,
                    4,
                    HomeLayout.horizontalPadding,
                    bottomPadding,
                  ),
                  sliver: SliverList.separated(
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return OrderListCard(order: orders[index]);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showSortSheet(BuildContext context, OrderSort current) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final sort in OrderSort.values)
                  ListTile(
                    title: Text(
                      sort.label,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppColors.titleNavy,
                      ),
                    ),
                    trailing: sort == current
                        ? const Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: () {
                      context.read<OrdersBloc>().add(OrdersSortChanged(sort));
                      Navigator.of(sheetContext).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CountAndSort extends StatelessWidget {
  const _CountAndSort({
    required this.count,
    required this.sort,
    required this.onSort,
  });

  final int count;
  final OrderSort sort;
  final VoidCallback onSort;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HomeLayout.horizontalPadding,
        10,
        HomeLayout.horizontalPadding,
        8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$count orders',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onSort,
            child: Row(
              children: [
                const Icon(
                  Icons.swap_vert_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  sort.label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 48,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No orders yet',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
