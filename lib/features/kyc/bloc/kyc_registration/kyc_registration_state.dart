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
    this.submitted = false,
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
  final bool submitted;

  KycCategory? get category => KycCategory.byId(categoryId);

  String get storeTypeLabel =>
      storeType == KycStoreType.offline ? 'Offline Store' : 'Online Only';

  String get formattedPhone => phone.isEmpty ? '' : '+91 $phone';

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

  bool get canSubmit =>
      canContinueCategory && canContinueBusinessDetails && canContinueLocation;

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
    bool? submitted,
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
      submitted: submitted ?? this.submitted,
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
        submitted,
      ];
}
