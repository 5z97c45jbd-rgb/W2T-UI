import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/auth/data/models/user_profile.dart';

void main() {
  test('needs personalization when date of birth or color is missing', () {
    const complete = UserProfile(
      userId: 'u1',
      dateOfBirth: null,
      color: 'Blue',
    );
    expect(
      const UserProfile(userId: 'u1', color: 'Blue').needsPersonalization,
      isTrue,
    );
    expect(
      UserProfile(
        userId: 'u1',
        dateOfBirth: DateTime.utc(1994, 1, 25),
      ).needsPersonalization,
      isTrue,
    );
    expect(complete.copyWith(dateOfBirth: DateTime.utc(1994, 1, 25)).needsPersonalization, isFalse);
  });

  test('parses dateOfBirth and color from profile payload', () {
    final profile = UserProfile.fromData(
      const {
        'userId': 'u1',
        'dateOfBirth': '1994-01-25T00:00:00.000Z',
        'color': 'Blue',
      },
      fallbackUserId: 'fallback',
    );

    expect(profile.dateOfBirth, isNotNull);
    expect(profile.dateOfBirth!.year, 1994);
    expect(profile.dateOfBirth!.month, 1);
    expect(profile.dateOfBirth!.day, 25);
    expect(profile.color, 'Blue');
    expect(profile.needsPersonalization, isFalse);
  });

  test('ignores user id when it is sent as the full name', () {
    final profile = UserProfile.fromData(
      const {
        'userId': 'user-1',
        'fullName': 'user-1',
        'name': 'user-1',
        'email': 'ada@example.com',
      },
      fallbackUserId: 'user-1',
    );

    expect(profile.fullName, isNull);
    expect(profile.visibleFullName, isNull);
    expect(profile.displayName, 'ada@example.com');
  });
}
