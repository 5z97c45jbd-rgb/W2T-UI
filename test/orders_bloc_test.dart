import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_event.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';

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
      category: 'Individuals',
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

  test('defaults to sold food orders, latest first', () {
    final bloc = OrdersBloc(orders: orders);
    addTearDown(bloc.close);
    expect(bloc.state.side, OrderSide.sold);
    expect(bloc.state.category, 'Food');
    expect(bloc.state.visibleOrders.map((order) => order.id), ['#W2T1']);
  });

  test('filters by individuals and purchased fashion', () async {
    final bloc = OrdersBloc(orders: orders);
    addTearDown(bloc.close);

    bloc.add(const OrdersCategoryChanged('Individuals'));
    await bloc.stream.first;
    expect(bloc.state.visibleOrders.single.partyName, 'Amit Reddy');

    bloc.add(const OrdersSideChanged(OrderSide.purchased));
    await bloc.stream.first;
    bloc.add(const OrdersCategoryChanged('Fashion'));
    await bloc.stream.first;

    expect(bloc.state.visibleOrders.single.category, 'Fashion');
  });
}
