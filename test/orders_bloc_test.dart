import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_event.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_state.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';
import 'package:w2t_mobile/features/home/data/orders_api.dart';

class _FakeOrdersApi extends OrdersApi {
  _FakeOrdersApi({this.orders = const [], this.error})
      : super(DioClient(AuthTokenHolder()));

  final List<OrderItem> orders;
  final Object? error;

  @override
  Future<List<OrderItem>> fetchOrders() async {
    final thrown = error;
    if (thrown != null) throw thrown;
    return orders;
  }
}

void main() {
  final orders = [
    OrderItem(
      id: '#W2T1',
      side: OrderSide.sold,
      category: 'Food',
      partyName: 'Ravi Kumar',
      itemCount: 2,
      amountLabel: '₹420',
      placedAt: DateTime(2026, 10, 20, 13, 25),
      status: OrderStatus.delivered,
      imageAsset: AppAssets.noodleHub,
    ),
    OrderItem(
      id: '#W2T2',
      side: OrderSide.sold,
      category: 'Electronics',
      partyName: 'Amit Reddy',
      itemCount: 3,
      amountLabel: '₹560',
      placedAt: DateTime(2026, 10, 20, 11, 15),
      status: OrderStatus.delivered,
      imageAsset: AppAssets.skincarePersonalCare,
    ),
    OrderItem(
      id: '#W2T3',
      side: OrderSide.purchased,
      category: 'Fashion',
      partyName: 'StyleHub Fashion',
      itemCount: 1,
      amountLabel: '₹899',
      placedAt: DateTime(2026, 10, 18, 11, 45),
      status: OrderStatus.returnRequested,
      imageAsset: AppAssets.skincarePersonalCare,
    ),
  ];

  Future<OrdersBloc> loadedBloc() async {
    final bloc = OrdersBloc(api: _FakeOrdersApi(orders: orders));
    await bloc.stream.firstWhere((state) => state.status == OrdersStatus.success);
    return bloc;
  }

  test('defaults to sold orders, latest first', () async {
    final bloc = await loadedBloc();
    addTearDown(bloc.close);
    expect(bloc.state.side, OrderSide.sold);
    expect(bloc.state.visibleOrders.map((order) => order.id), ['#W2T1', '#W2T2']);
  });

  test('filters purchased orders', () async {
    final bloc = await loadedBloc();
    addTearDown(bloc.close);

    bloc.add(const OrdersSideChanged(OrderSide.purchased));
    await bloc.stream.first;

    expect(bloc.state.visibleOrders.single.partyName, 'StyleHub Fashion');
  });
}
