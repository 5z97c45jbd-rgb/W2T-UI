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

  static bool isSelfTalent(String? categoryId) =>
      categoryId == KycCategory.selfTalentId;

  static bool isFood(String? categoryId) => categoryId == KycCategory.foodId;

  static bool isGrocery(String? categoryId) =>
      categoryId == KycCategory.groceryId;

  /// Food & Grocery ₹399, Self Talent ₹299, every other category ₹499.
  static int registrationFee(String? categoryId) {
    if (isSelfTalent(categoryId)) return 299;
    if (isFood(categoryId) || isGrocery(categoryId)) return 399;
    return 499;
  }

  static String registrationFeeLabel(String? categoryId) =>
      '₹${registrationFee(categoryId)}';

  static bool requiresBusinessNumbers(String? categoryId) =>
      canContinueCategory(categoryId) && !isSelfTalent(categoryId);

  static bool requiresFssai(String? categoryId) => isFood(categoryId);

  static bool isPan(String value) =>
      RegExp(r'^[A-Z0-9]{10}$').hasMatch(value.trim().toUpperCase());

  static bool isGstin(String value) =>
      RegExp(r'^[A-Z0-9]{15}$').hasMatch(value.trim().toUpperCase());

  static String? panError(String value) {
    if (value.trim().isEmpty) return null;
    if (isPan(value)) return null;
    return 'Enter a 10-character PAN';
  }

  static String? gstinError(String value) {
    if (value.trim().isEmpty) return null;
    if (isGstin(value)) return null;
    return 'Enter a 15-character GSTIN';
  }

  static String? shopEstablishmentError(String value) {
    if (value.trim().isEmpty) return null;
    if (isShopEstablishment(value)) return null;
    return 'Enter a valid shop establishment number';
  }

  static String? fssaiError(String value) {
    if (value.trim().isEmpty) return null;
    if (isFssai(value)) return null;
    return 'Enter a 14-digit FSSAI number';
  }

  static bool isFssai(String value) =>
      RegExp(r'^\d{14}$').hasMatch(value.trim());

  static bool isShopEstablishment(String value) =>
      value.trim().length >= 3;

  static bool canContinueDocuments({
    required String? categoryId,
    required String pan,
    required String gstin,
    required String shopEstablishment,
    required String fssai,
  }) {
    if (!canContinueCategory(categoryId) || !isPan(pan)) return false;
    if (isSelfTalent(categoryId)) return true;
    if (!isGstin(gstin) || !isShopEstablishment(shopEstablishment)) {
      return false;
    }
    if (requiresFssai(categoryId) && !isFssai(fssai)) return false;
    return true;
  }

  static const maxStoreImageBytes = 5 * 1024 * 1024;

  static bool canContinueStoreImage(String? storeImagePath) =>
      storeImagePath != null && storeImagePath.trim().isNotEmpty;

  static int enteredDocumentCount({
    required String? categoryId,
    required String pan,
    required String gstin,
    required String shopEstablishment,
    required String fssai,
  }) {
    var count = 0;
    if (pan.trim().isNotEmpty) count++;
    if (requiresBusinessNumbers(categoryId)) {
      if (gstin.trim().isNotEmpty) count++;
      if (shopEstablishment.trim().isNotEmpty) count++;
    }
    if (requiresFssai(categoryId) && fssai.trim().isNotEmpty) count++;
    return count;
  }

  static bool _isPincode(String value) =>
      RegExp(r'^\d{6}$').hasMatch(value.trim());
}
