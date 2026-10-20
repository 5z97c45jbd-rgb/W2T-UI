import 'package:w2t_mobile/utils/regex_utils.dart';

extension AuthString on String {
  bool get isValidEmail => RegexUtils.isEmail(this);

  bool get isValidPhone => RegexUtils.isPhone(this);

  bool get isValidEmailOrPhone => RegexUtils.isEmailOrPhone(this);
}
