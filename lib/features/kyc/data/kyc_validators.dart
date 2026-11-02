import 'package:w2t_mobile/extensions/string_extension.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_category.dart';

abstract final class KycValidators {
  /// Same labels as [KycCategory.all] so category selection can prefill type.
  static List<String> get businessTypes => [
        for (final category in KycCategory.all) category.label,
      ];

  static const indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Jammu and Kashmir',
    'Ladakh',
    'Lakshadweep',
    'Puducherry',
  ];

  static const descriptionMaxLength = 200;

  /// Hanamkonda, Telangana — default map pin matching the KYC mock.
  static const defaultLatitude = 18.008597;
  static const defaultLongitude = 79.558525;
  static const defaultCity = 'Hanamkonda';
  static const defaultPincode = '506001';
  static const defaultState = 'Telangana';

  static bool canContinueCategory(String? categoryId) =>
      KycCategory.byId(categoryId) != null;

  static bool canContinueBusinessDetails({
    required String businessName,
    required String businessType,
    required String phone,
    required String email,
    required String description,
  }) {
    return businessName.trim().isNotEmpty &&
        businessType.trim().isNotEmpty &&
        phone.trim().isValidPhone &&
        email.trim().isValidEmail &&
        description.trim().isNotEmpty;
  }

  static bool canContinueLocation({
    required String addressLine1,
    required String city,
    required String pincode,
    required String state,
  }) {
    return addressLine1.trim().isNotEmpty &&
        city.trim().isNotEmpty &&
        _isPincode(pincode) &&
        state.trim().isNotEmpty;
  }

  static bool _isPincode(String value) =>
      RegExp(r'^\d{6}$').hasMatch(value.trim());
}
