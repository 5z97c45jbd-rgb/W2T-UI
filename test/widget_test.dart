import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/auth/ui/welcome_screen.dart';
import 'package:w2t_mobile/main.dart';

void main() {
  testWidgets('App opens on welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const W2tApp());
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
