import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_event.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_state.dart';
import 'package:w2t_mobile/features/home/data/orders_api.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc({required OrdersApi api})
      : _api = api,
        super(const OrdersState()) {
    on<OrdersRequested>(_onRequested);
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
    add(const OrdersRequested());
  }

  final OrdersApi _api;

  Future<void> _onRequested(
    OrdersRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading, errorMessage: null));
    try {
      final orders = await _api.fetchOrders();
      emit(state.copyWith(status: OrdersStatus.success, orders: orders));
    } catch (error) {
      emit(
        state.copyWith(
          status: OrdersStatus.failure,
          errorMessage: apiErrorMessage(error),
        ),
      );
    }
  }
}
