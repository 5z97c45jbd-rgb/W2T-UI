import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class OrdersSideChanged extends OrdersEvent {
  const OrdersSideChanged(this.side);

  final OrderSide side;

  @override
  List<Object?> get props => [side];
}

class OrdersCategoryChanged extends OrdersEvent {
  const OrdersCategoryChanged(this.category);

  final String category;

  @override
  List<Object?> get props => [category];
}

class OrdersSortChanged extends OrdersEvent {
  const OrdersSortChanged(this.sort);

  final OrderSort sort;

  @override
  List<Object?> get props => [sort];
}

class OrdersQueryChanged extends OrdersEvent {
  const OrdersQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
