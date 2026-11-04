import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';

enum OrdersStatus { loading, success, failure }

class OrdersState extends Equatable {
  const OrdersState({
    this.status = OrdersStatus.loading,
    this.orders = const [],
    this.side = OrderSide.sold,
    this.sort = OrderSort.latestFirst,
    this.query = '',
    this.errorMessage,
  });

  final OrdersStatus status;
  final List<OrderItem> orders;
  final OrderSide side;
  final OrderSort sort;
  final String query;
  final String? errorMessage;

  String get subtitle => side == OrderSide.sold
      ? 'Manage all your orders in one place'
      : 'Track everything you buy on W2T';

  List<OrderItem> get visibleOrders {
    final needle = query.trim().toLowerCase();
    final filtered = orders.where((order) {
      if (order.side != side) return false;
      if (needle.isEmpty) return true;
      return order.partyName.toLowerCase().contains(needle) ||
          order.id.toLowerCase().contains(needle) ||
          order.category.toLowerCase().contains(needle) ||
          order.displayStatus.toLowerCase().contains(needle);
    }).toList();

    filtered.sort((a, b) {
      final comparison = a.placedAt.compareTo(b.placedAt);
      return sort == OrderSort.latestFirst ? -comparison : comparison;
    });
    return filtered;
  }

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderItem>? orders,
    OrderSide? side,
    OrderSort? sort,
    String? query,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      side: side ?? this.side,
      sort: sort ?? this.sort,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, orders, side, sort, query, errorMessage];
}
