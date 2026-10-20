import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/auth/data/auth_validators.dart';

void main() {
  group('AuthValidators.login', () {
    test('keeps the login button disabled until email and password are valid', () {
      expect(
        AuthValidators.canSubmitLogin(
          identifier: '',
          password: '',
          usePhone: false,
        ),
        isFalse,
      );
      expect(
        AuthValidators.canSubmitLogin(
          identifier: 'not-an-email',
          password: 'secret',
          usePhone: false,
        ),
        isFalse,
      );
      expect(
        AuthValidators.canSubmitLogin(
          identifier: 'user@example.com',
          password: 'secret',
          usePhone: false,
        ),
        isTrue,
      );
    });

    test('requires a 10-digit phone number for phone login', () {
      expect(
        AuthValidators.canSubmitLogin(
          identifier: '98765',
          password: 'secret',
          usePhone: true,
        ),
        isFalse,
      );
      expect(
        AuthValidators.canSubmitLogin(
          identifier: '9876543210',
          password: 'secret',
          usePhone: true,
        ),
        isTrue,
      );
    });
  });

  group('AuthValidators.signup', () {
    test('requires matching passwords before Get OTP', () {
      expect(
        AuthValidators.canRequestSignupOtp(
          identifier: 'user@example.com',
          usePhone: false,
          password: 'secret',
          confirmPassword: 'other',
        ),
        isFalse,
      );
      expect(
        AuthValidators.canRequestSignupOtp(
          identifier: 'user@example.com',
          usePhone: false,
          password: 'secret',
          confirmPassword: 'secret',
        ),
        isTrue,
      );
    });

    test('requires an OTP before Sign Up', () {
      expect(
        AuthValidators.canSubmitSignup(
          identifier: 'user@example.com',
          usePhone: false,
          password: 'secret',
          confirmPassword: 'secret',
          otp: '',
        ),
        isFalse,
      );
      expect(
        AuthValidators.canSubmitSignup(
          identifier: 'user@example.com',
          usePhone: false,
          password: 'secret',
          confirmPassword: 'secret',
          otp: '123456',
        ),
        isTrue,
      );
    });
  });
}
