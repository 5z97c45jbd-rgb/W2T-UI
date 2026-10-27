import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';
import 'package:w2t_mobile/features/home/data/orders_content.dart';

class OrdersState extends Equatable {
  const OrdersState({
    required this.orders,
    this.side = OrderSide.sold,
    this.category = 'Food',
    this.sort = OrderSort.latestFirst,
    this.query = '',
  });

  factory OrdersState.initial([List<OrderItem>? orders]) {
    return OrdersState(orders: orders ?? OrdersContent.orders);
  }

  final List<OrderItem> orders;
  final OrderSide side;
  final String category;
  final OrderSort sort;
  final String query;

  String get subtitle => side == OrderSide.sold
      ? 'Manage all your orders in one place'
      : 'Track everything you buy on W2T';

  List<OrderItem> get visibleOrders {
    final needle = query.trim().toLowerCase();
    final filtered = orders.where((order) {
      if (order.side != side) return false;
      if (!_matchesCategory(order)) return false;
      if (needle.isEmpty) return true;
      return order.partyName.toLowerCase().contains(needle) ||
          order.id.toLowerCase().contains(needle) ||
          order.category.toLowerCase().contains(needle);
    }).toList();

    filtered.sort((a, b) {
      final comparison = a.placedAt.compareTo(b.placedAt);
      return sort == OrderSort.latestFirst ? -comparison : comparison;
    });
    return filtered;
  }

  bool _matchesCategory(OrderItem order) => order.category == category;

  OrdersState copyWith({
    List<OrderItem>? orders,
    OrderSide? side,
    String? category,
    OrderSort? sort,
    String? query,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      side: side ?? this.side,
      category: category ?? this.category,
      sort: sort ?? this.sort,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [orders, side, category, sort, query];
}
