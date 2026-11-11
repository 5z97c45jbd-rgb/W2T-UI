import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/home/data/merchants_api.dart';
import 'package:w2t_mobile/features/home/data/models/merchant.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_api.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_case.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_category.dart';

class _FakeMerchantsApi extends MerchantsApi {
  _FakeMerchantsApi() : super(DioClient(AuthTokenHolder()));

  Map<String, dynamic>? lastBody;
  String? lastImagePath;

  @override
  Future<Merchant> createMerchant(
    Map<String, dynamic> body, {
    String? imagePath,
  }) async {
    lastBody = body;
    lastImagePath = imagePath;
    return const Merchant(
      id: 'merchant-1',
      name: 'FreshMart',
      category: MerchantCategory.food,
      ratings: 1,
    );
  }
}

class _FakeKycApi extends KycApi {
  _FakeKycApi() : super(DioClient(AuthTokenHolder()));

  String? lastFilePath;
  Map<String, String>? lastDocumentMap;

  @override
  Future<KycCase> createCase({
    required String businessId,
    required String businessCategory,
  }) async {
    return const KycCase(id: 'case-1');
  }

  @override
  Future<void> submitDocuments({
    required String caseId,
    required String businessName,
    required Map<String, String> documentMap,
    String productCategory = 'MARKET_PLACE',
    String? filePath,
  }) async {
    lastDocumentMap = documentMap;
    lastFilePath = filePath;
  }
}

void _fillRequiredFields(KycRegistrationCubit cubit) {
  cubit.selectCategory(KycCategory.food.id);
  cubit.updateBusinessName('FreshMart');
  cubit.updatePhone('9876543210');
  cubit.updateEmail('freshmart@example.com');
  cubit.updateDescription('Daily groceries');
  cubit.updateAddressLine1('H.No 2-5-123, Main Road');
  cubit.updateCity('Hanamkonda');
  cubit.updatePincode('506001');
  cubit.updateState('Telangana');
  cubit.updatePan('ABCDE1234F');
  cubit.updateGstin('36ABCDE1234F1Z5');
  cubit.updateShopEstablishment('TL/HNK/123');
  cubit.updateFssai('11223344556677');
  cubit.updateTermsAccepted(true);
}

void main() {
  test('category selection prefills business type and remains editable', () {
    final cubit = KycRegistrationCubit();
    cubit.selectCategory(KycCategory.food.id);
    expect(cubit.state.businessType, 'Food');

    cubit.updateBusinessType('Grocery');
    expect(cubit.state.businessType, 'Grocery');
    expect(cubit.state.categoryId, KycCategory.grocery.id);
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

    cubit.updateTermsAccepted(true);
    cubit.submit();
    expect(cubit.state.submitted, isTrue);
    cubit.close();
  });

  test('self talent can submit with PAN and terms', () {
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
    cubit.updateTermsAccepted(true);
    cubit.submit();
    expect(cubit.state.submitted, isTrue);
    cubit.close();
  });

  test('business type change updates category, documents and fee', () {
    final cubit = KycRegistrationCubit();
    cubit.selectCategory(KycCategory.idFor('Pet Care'));
    expect(cubit.state.categoryRegistrationFee, 999);
    expect(cubit.state.requiresBusinessNumbers, isTrue);
    expect(cubit.state.requiresFssai, isFalse);

    cubit.updateBusinessType('Child Care');
    expect(cubit.state.categoryId, KycCategory.idFor('Child Care'));
    expect(cubit.state.categoryRegistrationFee, 999);
    expect(cubit.state.requiresBusinessNumbers, isTrue);
    expect(cubit.state.requiresFssai, isFalse);

    cubit.updateBusinessType('Self Talent');
    expect(cubit.state.categoryId, KycCategory.selfTalentId);
    expect(cubit.state.categoryRegistrationFee, 299);
    expect(cubit.state.requiresBusinessNumbers, isFalse);
    expect(cubit.state.requiresFssai, isFalse);

    cubit.updateBusinessType('Food');
    expect(cubit.state.categoryId, KycCategory.foodId);
    expect(cubit.state.requiresFssai, isTrue);
    cubit.close();
  });

  test('submit uploads store image and Aadhaar file', () async {
    final merchantsApi = _FakeMerchantsApi();
    final kycApi = _FakeKycApi();
    final cubit = KycRegistrationCubit(
      merchantsApi: merchantsApi,
      kycApi: kycApi,
    );
    _fillRequiredFields(cubit);
    cubit.updateStoreImagePath('/tmp/store.jpg');
    cubit.updateAadhaarImagePath('/tmp/aadhaar.jpg');

    await cubit.submit(userId: 'user-1');

    expect(cubit.state.submitted, isTrue);
    expect(merchantsApi.lastImagePath, '/tmp/store.jpg');
    expect(kycApi.lastFilePath, '/tmp/aadhaar.jpg');
    expect(kycApi.lastDocumentMap, {
      'PAN': 'ABCDE1234F',
      'GSTIN': '36ABCDE1234F1Z5',
      'SHOP_ESTABLISHMENT': 'TL/HNK/123',
      'FSSAI': '11223344556677',
    });
    cubit.close();
  });
}
