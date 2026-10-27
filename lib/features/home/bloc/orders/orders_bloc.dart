import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_event.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_state.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({List<OrderItem>? orders})
      : super(OrdersState.initial(orders)) {
    on<OrdersSideChanged>(
      (event, emit) => emit(state.copyWith(side: event.side)),
    );
    on<OrdersCategoryChanged>(
      (event, emit) => emit(state.copyWith(category: event.category)),
    );
    on<OrdersSortChanged>(
      (event, emit) => emit(state.copyWith(sort: event.sort)),
    );
    on<OrdersQueryChanged>(
      (event, emit) => emit(state.copyWith(query: event.query)),
    );
  }
}
