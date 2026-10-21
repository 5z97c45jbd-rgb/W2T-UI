import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/home/widgets/home_bottom_nav_bar.dart';

void main() {
  testWidgets('AI tab is a circular FAB with sparkle icon', (tester) async {
    HomeTab current = HomeTab.home;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const SizedBox.expand(),
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return HomeBottomNavBar(
                currentTab: current,
                onTabSelected: (tab) => setState(() => current = tab),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(current, HomeTab.locate);
  });
}
