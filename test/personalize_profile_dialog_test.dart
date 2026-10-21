import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/home/widgets/personalize_profile_dialog.dart';

Finder _saveButton() {
  return find.ancestor(
    of: find.text('Save & Continue'),
    matching: find.byType(ElevatedButton),
  );
}

Future<void> _pumpDialog(
  WidgetTester tester, {
  DateTime? initialDateOfBirth,
  required ValueChanged<({DateTime dateOfBirth, String color})> onSave,
}) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PersonalizeProfileDialog(
          initialDateOfBirth: initialDateOfBirth,
          onSave: onSave,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('Save stays disabled until a date of birth is chosen',
      (tester) async {
    await _pumpDialog(tester, onSave: (_) {});

    expect(find.text("Let's personalize your\nW2T experience"), findsOneWidget);
    expect(find.text('Blue'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(_saveButton()).onPressed, isNull);
  });

  testWidgets('Save submits selected date and colour', (tester) async {
    ({DateTime dateOfBirth, String color})? saved;

    await _pumpDialog(
      tester,
      initialDateOfBirth: DateTime(1994, 1, 25),
      onSave: (value) => saved = value,
    );

    expect(find.text('25 Jan 1994'), findsOneWidget);
    await tester.ensureVisible(_saveButton());
    await tester.tap(_saveButton());
    await tester.pump();

    expect(saved?.color, 'Blue');
    expect(saved?.dateOfBirth, DateTime(1994, 1, 25));
  });
}
