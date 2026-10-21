import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/auth/ui/splash_screen.dart';
import 'package:w2t_mobile/features/auth/ui/welcome_screen.dart';
import 'package:w2t_mobile/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage.setMockInitialValues({});

  testWidgets('App opens on splash then welcome', (WidgetTester tester) async {
    await tester.pumpWidget(const W2tApp());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2700));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
