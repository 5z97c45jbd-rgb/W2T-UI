import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_state.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_device_location.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_category.dart';

class KycRegistrationCubit extends Cubit<KycRegistrationState> {
  KycRegistrationCubit({KycRegistrationState? initialState})
      : super(initialState ?? const KycRegistrationState());

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

  void updateBusinessType(String value) =>
      emit(state.copyWith(businessType: value));

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

  void submit() {
    if (!state.canSubmit) return;
    emit(state.copyWith(submitted: true));
  }
}
