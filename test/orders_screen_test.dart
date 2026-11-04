import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/home/bloc/home_tab/home_tab_cubit.dart';
import 'package:w2t_mobile/features/home/bloc/orders/orders_bloc.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';
import 'package:w2t_mobile/features/home/data/orders_api.dart';
import 'package:w2t_mobile/features/home/data/orders_content.dart';
import 'package:w2t_mobile/features/home/ui/orders_screen.dart';

class _FakeOrdersApi extends OrdersApi {
  _FakeOrdersApi() : super(DioClient(AuthTokenHolder()));

  @override
  Future<List<OrderItem>> fetchOrders() async => OrdersContent.orders;
}

void main() {
  testWidgets('Orders screen matches sold/purchased layout with Individuals',
      (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => HomeTabCubit()),
          BlocProvider(create: (_) => OrdersBloc(api: _FakeOrdersApi())),
        ],
        child: const MaterialApp(home: Scaffold(body: OrdersScreen())),
      ),
    );
    await tester.pump();

    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Manage all your orders in one place'), findsOneWidget);
    expect(find.text('Sold'), findsOneWidget);
    expect(find.text('Purchased'), findsOneWidget);
    expect(find.text('Food'), findsWidgets);
    expect(find.text('Grocery'), findsWidgets);
    expect(find.text('Individuals'), findsWidgets);
    expect(find.text('Electronics'), findsWidgets);
    expect(find.text('Fashion'), findsWidgets);
    expect(find.text('All'), findsNothing);
    expect(find.text('More'), findsNothing);
    expect(find.text('Pharmacy'), findsNothing);
    expect(find.text('Ravi Kumar'), findsOneWidget);
    expect(find.text('#W2T1004582'), findsOneWidget);

    await tester.tap(find.text('Purchased'));
    await tester.pump();

    expect(find.text('Track everything you buy on W2T'), findsOneWidget);
    expect(find.text('Paradise Biryani'), findsOneWidget);
  });
}
