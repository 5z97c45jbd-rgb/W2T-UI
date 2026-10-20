import 'package:w2t_mobile/extensions/string_extension.dart';

abstract final class AuthValidators {
  static String? login({
    required String identifier,
    required String password,
    required bool usePhone,
  }) {
    final contactError = contact(identifier: identifier, usePhone: usePhone);
    if (contactError != null) return contactError;
    if (password.isEmpty) return 'Enter your password';
    return null;
  }

  static String? signup({
    required String identifier,
    required bool usePhone,
    required String password,
    required String confirmPassword,
    String otp = '',
    bool requireOtp = false,
  }) {
    final contactError = contact(identifier: identifier, usePhone: usePhone);
    if (contactError != null) return contactError;
    final passwordError = matchingPasswords(password, confirmPassword);
    if (passwordError != null) return passwordError;
    if (requireOtp) return otpCode(otp);
    return null;
  }

  static String? resetPassword({
    required String userUq,
    required String password,
    required String confirmPassword,
    String otp = '',
    bool requireOtp = false,
  }) {
    if (!userUq.isValidEmailOrPhone) {
      return userUq.trim().isEmpty
          ? 'Enter your email or phone number'
          : 'Enter a valid email or phone number';
    }
    final passwordError = matchingPasswords(password, confirmPassword);
    if (passwordError != null) return passwordError;
    if (requireOtp) return otpCode(otp);
    return null;
  }

  static String? contact({
    required String identifier,
    required bool usePhone,
  }) {
    final trimmed = identifier.trim();
    if (usePhone) {
      if (trimmed.isEmpty) return 'Enter your phone number';
      if (!trimmed.isValidPhone) return 'Enter a 10-digit phone number';
      return null;
    }
    if (trimmed.isEmpty) return 'Enter your email';
    if (!trimmed.isValidEmail) return 'Enter a valid email';
    return null;
  }

  static String? matchingPasswords(String password, String confirmPassword) {
    if (password.isEmpty || confirmPassword.isEmpty) {
      return 'Enter and confirm your password';
    }
    if (password != confirmPassword) return 'Passwords do not match';
    return null;
  }

  static String? otpCode(String otp) {
    if (otp.trim().isEmpty) return 'Enter the OTP';
    return null;
  }

  static bool canSubmitLogin({
    required String identifier,
    required String password,
    required bool usePhone,
  }) {
    return login(
          identifier: identifier,
          password: password,
          usePhone: usePhone,
        ) ==
        null;
  }

  static bool canRequestSignupOtp({
    required String identifier,
    required bool usePhone,
    required String password,
    required String confirmPassword,
  }) {
    return signup(
          identifier: identifier,
          usePhone: usePhone,
          password: password,
          confirmPassword: confirmPassword,
        ) ==
        null;
  }

  static bool canSubmitSignup({
    required String identifier,
    required bool usePhone,
    required String password,
    required String confirmPassword,
    required String otp,
  }) {
    return signup(
          identifier: identifier,
          usePhone: usePhone,
          password: password,
          confirmPassword: confirmPassword,
          otp: otp,
          requireOtp: true,
        ) ==
        null;
  }

  static bool canRequestResetOtp({
    required String userUq,
    required String password,
    required String confirmPassword,
  }) {
    return resetPassword(
          userUq: userUq,
          password: password,
          confirmPassword: confirmPassword,
        ) ==
        null;
  }

  static bool canSubmitReset({
    required String userUq,
    required String password,
    required String confirmPassword,
    required String otp,
  }) {
    return resetPassword(
          userUq: userUq,
          password: password,
          confirmPassword: confirmPassword,
          otp: otp,
          requireOtp: true,
        ) ==
        null;
  }
}
