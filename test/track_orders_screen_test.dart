import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/home/data/track_orders_content.dart';
import 'package:w2t_mobile/features/home/ui/ai_screen.dart';
import 'package:w2t_mobile/features/home/ui/live_order_tracking_screen.dart';
import 'package:w2t_mobile/features/home/ui/order_details_screen.dart';
import 'package:w2t_mobile/features/home/ui/track_orders_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Track my order opens a carousel then details without chat',
      (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AiScreen())),
    );
    await tester.pump();

    await tester.tap(find.text('Track my order'));
    await tester.pumpAndSettle();

    expect(find.text('Track my orders'), findsOneWidget);
    expect(find.text('The Food Court'), findsWidgets);

    await tester.tap(find.text('The Food Court').first);
    await tester.pumpAndSettle();

    expect(find.byType(OrderDetailsScreen), findsOneWidget);
    expect(find.text('Order Details'), findsWidgets);
    expect(find.text('Order ID: W2T1298347'), findsOneWidget);
    expect(find.text('On the Way'), findsWidgets);
    expect(find.text('Ramesh Kumar'), findsOneWidget);
    expect(find.text('View on Map >'), findsOneWidget);
    expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
    expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsNothing);
    expect(find.byIcon(Icons.chat_bubble_outline), findsNothing);
    expect(find.byIcon(Icons.sms_outlined), findsNothing);

    await tester.tap(find.text('View on Map >'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(LiveOrderTrackingScreen), findsOneWidget);
    expect(find.text('Live Order Tracking'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName.contains('track_order_map'),
      ),
      findsOneWidget,
    );
    expect(find.text('Your order is on the way!'), findsOneWidget);
    expect(find.byIcon(Icons.phone_outlined), findsWidgets);
    expect(find.byIcon(Icons.chat_bubble_outline), findsNothing);
  });

  testWidgets('Carousel lists sample orders for tracking', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TrackOrdersScreen(orders: TrackOrdersContent.samples),
      ),
    );
    await tester.pump();

    expect(find.text('The Food Court'), findsOneWidget);
    expect(find.text('Track my orders'), findsOneWidget);
  });
}
