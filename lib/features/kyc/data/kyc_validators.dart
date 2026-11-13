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

  static const documentFeeEach = 50;

  /// Food & Grocery ₹999, Self Talent ₹299, every other category ₹999.
  static int categoryRegistrationFee(String? categoryId) {
    if (isSelfTalent(categoryId)) return 299;
    return 999;
  }

  /// Each submitted KYC document is billed as count + 1.
  static int billedDocumentCount(int submittedDocumentCount) =>
      submittedDocumentCount + 1;

  static int documentFee(int submittedDocumentCount) =>
      documentFeeEach * billedDocumentCount(submittedDocumentCount);

  static int registrationFee(
    String? categoryId, {
    int submittedDocumentCount = 0,
  }) {
    return categoryRegistrationFee(categoryId) +
        documentFee(submittedDocumentCount);
  }

  static String rupees(int amount) => '₹$amount';

  static String registrationFeeLabel(
    String? categoryId, {
    int submittedDocumentCount = 0,
  }) =>
      rupees(
        registrationFee(
          categoryId,
          submittedDocumentCount: submittedDocumentCount,
        ),
      );

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

  static bool isPdfPath(String? path) {
    final trimmed = path?.trim() ?? '';
    if (trimmed.isEmpty) return false;
    return trimmed.toLowerCase().endsWith('.pdf');
  }

  static bool isImagePath(String? path) {
    final trimmed = path?.trim().toLowerCase() ?? '';
    if (trimmed.isEmpty || isPdfPath(path)) return false;
    return trimmed.endsWith('.jpg') ||
        trimmed.endsWith('.jpeg') ||
        trimmed.endsWith('.png') ||
        trimmed.endsWith('.webp') ||
        trimmed.endsWith('.heic') ||
        trimmed.endsWith('.heif') ||
        trimmed.endsWith('.gif');
  }

  static bool canContinueStoreImage(String? storeImagePath) => true;

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
