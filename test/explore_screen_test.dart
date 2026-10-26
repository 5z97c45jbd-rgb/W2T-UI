import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/home/data/home_content.dart';
import 'package:w2t_mobile/features/home/ui/explore_screen.dart';

void main() {
  testWidgets('Explore uses home categories and video cost, not All or comments',
      (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ExploreScreen())),
    );

    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Watch • Learn • Share'), findsOneWidget);
    expect(find.byIcon(Icons.location_on_rounded), findsNothing);
    expect(find.textContaining('Hanamkonda'), findsNothing);
    expect(find.text('All'), findsNothing);
    expect(find.text('120'), findsNothing);
    expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsNothing);
    expect(find.byIcon(Icons.mode_comment_outlined), findsNothing);

    expect(find.text('Food'), findsWidgets);
    expect(find.text('Grocery'), findsWidgets);
    expect(
      HomeContent.categories.first.label,
      'Food',
    );
    expect(find.text('Food'), findsWidgets);
    expect(find.text('₹499'), findsOneWidget);
    expect(find.text('Share Your Own Video'), findsNothing);
    expect(find.text('Upload Video'), findsNothing);
  });
}
