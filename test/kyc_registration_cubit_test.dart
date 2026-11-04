import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_category.dart';

void main() {
  test('category selection prefills business type and remains editable', () {
    final cubit = KycRegistrationCubit();
    cubit.selectCategory(KycCategory.food.id);
    expect(cubit.state.businessType, 'Food');

    cubit.updateBusinessType('Grocery');
    expect(cubit.state.businessType, 'Grocery');
    cubit.close();
  });

  test('submit is ignored until category, business and location are complete',
      () {
    final cubit = KycRegistrationCubit();
    cubit.submit();
    expect(cubit.state.submitted, isFalse);

    cubit.selectCategory(KycCategory.food.id);
    cubit.updateBusinessName('FreshMart');
    cubit.updatePhone('9876543210');
    cubit.updateEmail('freshmart@example.com');
    cubit.updateDescription('Daily groceries');
    cubit.submit();
    expect(cubit.state.submitted, isFalse);

    cubit.updateAddressLine1('H.No 2-5-123, Main Road');
    cubit.updateCity('Hanamkonda');
    cubit.updatePincode('506001');
    cubit.updateState('Telangana');
    cubit.submit();
    expect(cubit.state.submitted, isFalse);

    cubit.updatePan('ABCDE1234F');
    cubit.updateGstin('36ABCDE1234F1Z5');
    cubit.updateShopEstablishment('TL/HNK/123');
    cubit.updateFssai('11223344556677');
    cubit.submit();
    expect(cubit.state.submitted, isFalse);

    cubit.updateStoreImagePath('/tmp/store.jpg');
    cubit.submit();
    expect(cubit.state.submitted, isFalse);

    cubit.updateTermsAccepted(true);
    cubit.submit();
    expect(cubit.state.submitted, isTrue);
    cubit.close();
  });

  test('self talent can submit with PAN, store image and terms', () {
    final cubit = KycRegistrationCubit();
    cubit.selectCategory(KycCategory.selfTalent.id);
    cubit.updateBusinessName('Asha Dance');
    cubit.updatePhone('9876543210');
    cubit.updateEmail('asha@example.com');
    cubit.updateDescription('Classical dance classes');
    cubit.updateAddressLine1('H.No 2-5-123, Main Road');
    cubit.updateCity('Hanamkonda');
    cubit.updatePincode('506001');
    cubit.updateState('Telangana');
    cubit.updatePan('ABCDE1234F');
    cubit.updateStoreImagePath('/tmp/store.jpg');
    cubit.updateTermsAccepted(true);
    cubit.submit();
    expect(cubit.state.submitted, isTrue);
    cubit.close();
  });
}
