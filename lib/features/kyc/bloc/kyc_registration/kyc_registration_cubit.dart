import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/features/home/data/catalog_categories.dart';
import 'package:w2t_mobile/features/home/data/merchants_api.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_state.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_api.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_device_location.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_category.dart';

class KycRegistrationCubit extends Cubit<KycRegistrationState> {
  KycRegistrationCubit({
    KycRegistrationState? initialState,
    MerchantsApi? merchantsApi,
    KycApi? kycApi,
  })  : _merchantsApi = merchantsApi,
        _kycApi = kycApi,
        super(initialState ?? const KycRegistrationState());

  final MerchantsApi? _merchantsApi;
  final KycApi? _kycApi;

  void selectCategory(String categoryId) {
    final category = KycCategory.byId(categoryId);
    emit(
      state.copyWith(
        categoryId: categoryId,
        businessType: category?.label ?? state.businessType,
      ),
    );
  }

  void updateBusinessName(String value) =>
      emit(state.copyWith(businessName: value));

  void updateBusinessType(String value) {
    final category = KycCategory.byLabel(value);
    emit(
      state.copyWith(
        businessType: value,
        categoryId: category?.id ?? state.categoryId,
      ),
    );
  }

  void updateStoreType(KycStoreType value) =>
      emit(state.copyWith(storeType: value));

  void updatePhone(String value) => emit(state.copyWith(phone: value));

  void updateEmail(String value) => emit(state.copyWith(email: value));

  void updateDescription(String value) =>
      emit(state.copyWith(description: value));

  void updateAddressLine1(String value) =>
      emit(state.copyWith(addressLine1: value));

  void updateAddressLine2(String value) =>
      emit(state.copyWith(addressLine2: value));

  void updateCity(String value) => emit(state.copyWith(city: value));

  void updatePincode(String value) => emit(state.copyWith(pincode: value));

  void updateState(String value) => emit(state.copyWith(state: value));

  void updateCoordinates(double latitude, double longitude) => emit(
        state.copyWith(latitude: latitude, longitude: longitude),
      );

  void applyDeviceLocation(KycGeoResult result) {
    emit(
      state.copyWith(
        usedCurrentLocation: true,
        latitude: result.latitude,
        longitude: result.longitude,
        addressLine1: result.addressLine1 ?? state.addressLine1,
        addressLine2: result.addressLine2 ?? state.addressLine2,
        city: result.city ?? state.city,
        pincode: result.pincode ?? state.pincode,
        state: result.state ?? state.state,
      ),
    );
  }

  void updatePan(String value) => emit(state.copyWith(pan: value));

  void updateGstin(String value) => emit(state.copyWith(gstin: value));

  void updateShopEstablishment(String value) =>
      emit(state.copyWith(shopEstablishment: value));

  void updateFssai(String value) => emit(state.copyWith(fssai: value));

  void updateStoreImagePath(String? path) => emit(
        path == null
            ? state.copyWith(clearStoreImagePath: true)
            : state.copyWith(storeImagePath: path),
      );

  void updateAadhaarImagePath(String? path) => emit(
        path == null
            ? state.copyWith(clearAadhaarImagePath: true)
            : state.copyWith(aadhaarImagePath: path),
      );

  void updateTermsAccepted(bool value) =>
      emit(state.copyWith(termsAccepted: value));

  void useCurrentLocation() {
    emit(
      state.copyWith(
        usedCurrentLocation: true,
        city: KycValidators.defaultCity,
        pincode: KycValidators.defaultPincode,
        state: KycValidators.defaultState,
        latitude: KycValidators.defaultLatitude,
        longitude: KycValidators.defaultLongitude,
      ),
    );
  }

  Future<void> submit({String? userId}) async {
    if (!state.canSubmit || state.isSubmitting) return;

    final merchantsApi = _merchantsApi;
    final kycApi = _kycApi;
    if (merchantsApi == null || kycApi == null) {
      emit(state.copyWith(submitted: true));
      return;
    }

    final trimmedUserId = userId?.trim() ?? '';
    if (trimmedUserId.isEmpty) {
      emit(
        state.copyWith(
          submitError: 'Please sign in again to submit KYC.',
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));
    try {
      final merchant = await merchantsApi.createMerchant(
        _merchantBody(trimmedUserId),
        imagePath: state.storeImagePath,
      );
      final kycCase = await kycApi.createCase(
        businessId: merchant.id,
        businessCategory: _businessCategory,
      );
      await kycApi.submitDocuments(
        caseId: kycCase.id,
        businessName: state.businessName.trim(),
        documentMap: _documentMap,
        filePath: KycValidators.isImagePath(state.aadhaarImagePath)
            ? state.aadhaarImagePath
            : null,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          submitted: true,
          merchantId: merchant.id,
          kycCaseId: kycCase.id,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submitError: apiErrorMessage(error),
        ),
      );
    }
  }

  Map<String, dynamic> _merchantBody(String userId) {
    return {
      'name': state.businessName.trim(),
      'kycApproved': false,
      'registrationFee': state.registrationFee,
      'addressesDTOS': [
        {
          'pincode': int.tryParse(state.pincode.trim()) ?? 0,
          'street': state.addressLine1.trim(),
          'address_type': 'STORE',
          'flat_no': state.addressLine2.trim(),
          'city': state.city.trim(),
          'user_id': userId,
          'state': state.state.trim(),
          'location': {
            'longitude': state.longitude,
            'latitude': state.latitude,
          },
        },
      ],
      'ratings': 1,
      'phoneNumber': _phoneNumber,
      'isEnabled': true,
      'storeType': state.storeType == KycStoreType.offline ? 'OFFLINE' : 'ONLINE',
      'email': state.email.trim(),
      'description': state.description.trim(),
      'category': _businessCategory,
    };
  }

  String get _businessCategory {
    final label = state.category?.label ?? state.businessType;
    return CatalogCategories.apiValue(label);
  }

  String get _phoneNumber {
    final phone = state.phone.trim();
    if (phone.length == 10) return '+91$phone';
    return phone;
  }

  Map<String, String> get _documentMap {
    return {
      if (state.pan.trim().isNotEmpty) 'PAN': state.pan.trim(),
      if (state.gstin.trim().isNotEmpty) 'GSTIN': state.gstin.trim(),
      if (state.shopEstablishment.trim().isNotEmpty)
        'SHOP_ESTABLISHMENT': state.shopEstablishment.trim(),
      if (state.fssai.trim().isNotEmpty) 'FSSAI': state.fssai.trim(),
    };
  }
}
