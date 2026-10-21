import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/ui/app_snack_bar.dart';

void main() {
  testWidgets('shows a snackbar message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: AppSnackBar.messengerKey,
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => AppSnackBar.show(context, 'Login successful'),
                child: const Text('Show'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();

    expect(find.text('Login successful'), findsOneWidget);
  });
}
