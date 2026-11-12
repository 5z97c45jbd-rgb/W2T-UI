import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_category.dart';

enum KycStoreType { offline, online }

enum KycWizardStep { category, business, location, review }

class KycRegistrationState extends Equatable {
  const KycRegistrationState({
    this.categoryId,
    this.businessName = '',
    this.businessType = '',
    this.storeType = KycStoreType.offline,
    this.phone = '',
    this.email = '',
    this.description = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.pincode = '',
    this.state = '',
    this.latitude = KycValidators.defaultLatitude,
    this.longitude = KycValidators.defaultLongitude,
    this.usedCurrentLocation = false,
    this.pan = '',
    this.gstin = '',
    this.shopEstablishment = '',
    this.fssai = '',
    this.storeImagePath,
    this.aadhaarImagePath,
    this.termsAccepted = false,
    this.submitted = false,
    this.isSubmitting = false,
    this.submitError,
    this.merchantId,
    this.kycCaseId,
  });

  final String? categoryId;
  final String businessName;
  final String businessType;
  final KycStoreType storeType;
  final String phone;
  final String email;
  final String description;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String pincode;
  final String state;
  final double latitude;
  final double longitude;
  final bool usedCurrentLocation;
  final String pan;
  final String gstin;
  final String shopEstablishment;
  final String fssai;
  final String? storeImagePath;
  final String? aadhaarImagePath;
  final bool termsAccepted;
  final bool submitted;
  final bool isSubmitting;
  final String? submitError;
  final String? merchantId;
  final String? kycCaseId;

  KycCategory? get category => KycCategory.byId(categoryId);

  String get storeTypeLabel =>
      storeType == KycStoreType.offline ? 'Offline Store' : 'Online Only';

  String get formattedPhone {
    if (phone.isEmpty) return '';
    if (phone.length == 10) {
      return '+91 ${phone.substring(0, 5)} ${phone.substring(5)}';
    }
    return '+91 $phone';
  }

  String get reviewLocationLine {
    final locality =
        [city.trim(), state.trim()].where((part) => part.isNotEmpty).join(', ');
    if (pincode.trim().isEmpty) return locality;
    if (locality.isEmpty) return pincode.trim();
    return '$locality - ${pincode.trim()}';
  }

  int get enteredDocumentCount => KycValidators.enteredDocumentCount(
        categoryId: categoryId,
        pan: pan,
        gstin: gstin,
        shopEstablishment: shopEstablishment,
        fssai: fssai,
      );

  String get documentsSummary {
    final count = enteredDocumentCount;
    return '$count ${count == 1 ? 'document' : 'documents'} added';
  }

  String get formattedAddress {
    final parts = [
      addressLine1.trim(),
      if (addressLine2.trim().isNotEmpty) addressLine2.trim(),
      [city.trim(), state.trim()].where((part) => part.isNotEmpty).join(', '),
      pincode.trim(),
    ].where((part) => part.isNotEmpty);
    return parts.join('\n');
  }

  bool get canContinueCategory => KycValidators.canContinueCategory(categoryId);

  bool get canContinueBusinessDetails =>
      KycValidators.canContinueBusinessDetails(
        businessName: businessName,
        businessType: businessType,
        phone: phone,
        email: email,
        description: description,
      );

  bool get canContinueLocation => KycValidators.canContinueLocation(
        addressLine1: addressLine1,
        city: city,
        pincode: pincode,
        state: state,
      );

  bool get isSelfTalent => KycValidators.isSelfTalent(categoryId);

  int get categoryRegistrationFee =>
      KycValidators.categoryRegistrationFee(categoryId);

  int get billedDocumentCount =>
      KycValidators.billedDocumentCount(enteredDocumentCount);

  int get documentFee => KycValidators.documentFee(enteredDocumentCount);

  int get registrationFee => KycValidators.registrationFee(
        categoryId,
        submittedDocumentCount: enteredDocumentCount,
      );

  String get categoryRegistrationFeeLabel =>
      KycValidators.rupees(categoryRegistrationFee);

  String get documentFeeLabel => KycValidators.rupees(documentFee);

  String get registrationFeeLabel => KycValidators.rupees(registrationFee);

  bool get requiresBusinessNumbers =>
      KycValidators.requiresBusinessNumbers(categoryId);

  bool get requiresFssai => KycValidators.requiresFssai(categoryId);

  bool get canContinueDocuments => KycValidators.canContinueDocuments(
        categoryId: categoryId,
        pan: pan,
        gstin: gstin,
        shopEstablishment: shopEstablishment,
        fssai: fssai,
      );

  bool get canContinueStoreImage =>
      KycValidators.canContinueStoreImage(storeImagePath);

  bool get canSubmit =>
      canContinueCategory &&
      canContinueBusinessDetails &&
      canContinueLocation &&
      canContinueDocuments &&
      canContinueStoreImage &&
      termsAccepted;

  KycRegistrationState copyWith({
    String? categoryId,
    String? businessName,
    String? businessType,
    KycStoreType? storeType,
    String? phone,
    String? email,
    String? description,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? pincode,
    String? state,
    double? latitude,
    double? longitude,
    bool? usedCurrentLocation,
    String? pan,
    String? gstin,
    String? shopEstablishment,
    String? fssai,
    String? storeImagePath,
    bool clearStoreImagePath = false,
    String? aadhaarImagePath,
    bool clearAadhaarImagePath = false,
    bool? termsAccepted,
    bool? submitted,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    String? merchantId,
    String? kycCaseId,
  }) {
    return KycRegistrationState(
      categoryId: categoryId ?? this.categoryId,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      storeType: storeType ?? this.storeType,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      description: description ?? this.description,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      state: state ?? this.state,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      usedCurrentLocation: usedCurrentLocation ?? this.usedCurrentLocation,
      pan: pan ?? this.pan,
      gstin: gstin ?? this.gstin,
      shopEstablishment: shopEstablishment ?? this.shopEstablishment,
      fssai: fssai ?? this.fssai,
      storeImagePath:
          clearStoreImagePath ? null : storeImagePath ?? this.storeImagePath,
      aadhaarImagePath: clearAadhaarImagePath
          ? null
          : aadhaarImagePath ?? this.aadhaarImagePath,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      submitted: submitted ?? this.submitted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : submitError ?? this.submitError,
      merchantId: merchantId ?? this.merchantId,
      kycCaseId: kycCaseId ?? this.kycCaseId,
    );
  }

  @override
  List<Object?> get props => [
        categoryId,
        businessName,
        businessType,
        storeType,
        phone,
        email,
        description,
        addressLine1,
        addressLine2,
        city,
        pincode,
        state,
        latitude,
        longitude,
        usedCurrentLocation,
        pan,
        gstin,
        shopEstablishment,
        fssai,
        storeImagePath,
        aadhaarImagePath,
        termsAccepted,
        submitted,
        isSubmitting,
        submitError,
        merchantId,
        kycCaseId,
      ];
}
