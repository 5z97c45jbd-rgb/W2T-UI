abstract final class RegexUtils {
  static final RegExp email = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );
  static final RegExp phone = RegExp(r'^\d{10}$');

  static bool isEmail(String value) => email.hasMatch(value.trim());

  static bool isPhone(String value) => phone.hasMatch(value.trim());

  static bool isEmailOrPhone(String value) {
    final trimmed = value.trim();
    if (isEmail(trimmed)) return true;
    var digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('91') && digits.length == 12) {
      digits = digits.substring(2);
    }
    return isPhone(digits);
  }
}
