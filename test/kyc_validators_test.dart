import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_category.dart';

void main() {
  test('category continue requires a known category', () {
    expect(KycValidators.canContinueCategory(null), isFalse);
    expect(KycValidators.canContinueCategory('unknown'), isFalse);
    expect(KycValidators.canContinueCategory(KycCategory.food.id), isTrue);
  });

  test('location continue requires line 1, city, pincode and state', () {
    expect(
      KycValidators.canContinueLocation(
        addressLine1: '',
        city: 'Hanamkonda',
        pincode: '506001',
        state: 'Telangana',
      ),
      isFalse,
    );
    expect(
      KycValidators.canContinueLocation(
        addressLine1: 'H.No 2-5-123, Main Road',
        city: 'Hanamkonda',
        pincode: '506001',
        state: 'Telangana',
      ),
      isTrue,
    );
  });

  test('self talent documents require only a valid PAN', () {
    expect(
      KycValidators.canContinueDocuments(
        categoryId: KycCategory.selfTalent.id,
        pan: 'ABCID45637',
        gstin: '',
        shopEstablishment: '',
        fssai: '',
      ),
      isTrue,
    );
    expect(
      KycValidators.canContinueDocuments(
        categoryId: KycCategory.selfTalent.id,
        pan: 'invalid',
        gstin: '',
        shopEstablishment: '',
        fssai: '',
      ),
      isFalse,
    );
  });

  test('food documents require PAN, GSTIN, shop establishment and FSSAI', () {
    expect(
      KycValidators.canContinueDocuments(
        categoryId: KycCategory.food.id,
        pan: 'ABCDE1234F',
        gstin: '36ABCDE1234F1Z5',
        shopEstablishment: 'TL/HNK/123',
        fssai: '11223344556677',
      ),
      isTrue,
    );
    expect(
      KycValidators.canContinueDocuments(
        categoryId: KycCategory.food.id,
        pan: 'ABCDE1234F',
        gstin: '36ABCDE1234F1Z5',
        shopEstablishment: 'TL/HNK/123',
        fssai: '',
      ),
      isFalse,
    );
    expect(KycValidators.requiresFssai(KycCategory.food.id), isTrue);
    expect(KycValidators.requiresFssai(KycCategory.selfTalent.id), isFalse);
    expect(
      KycValidators.canContinueDocuments(
        categoryId: KycCategory.idFor('Grocery'),
        pan: 'ABCID45637',
        gstin: 'GSTIN4538463920',
        shopEstablishment: 'TL/HNK/ALE/12345/2024',
        fssai: '',
      ),
      isTrue,
    );
  });

  test('registration fee is 999 food/grocery, 299 self talent, plus docs', () {
    expect(KycValidators.categoryRegistrationFee(KycCategory.food.id), 999);
    expect(KycValidators.categoryRegistrationFee(KycCategory.grocery.id), 999);
    expect(KycValidators.categoryRegistrationFee(KycCategory.selfTalent.id), 299);
    expect(
      KycValidators.categoryRegistrationFee(KycCategory.idFor('Electronics')),
      999,
    );
    expect(KycValidators.documentFee(0), 50);
    expect(KycValidators.documentFee(3), 200);
    expect(
      KycValidators.registrationFee(
        KycCategory.food.id,
        submittedDocumentCount: 3,
      ),
      1199,
    );
    expect(
      KycValidators.registrationFee(
        KycCategory.selfTalent.id,
        submittedDocumentCount: 1,
      ),
      399,
    );
    expect(
      KycValidators.registrationFeeLabel(
        KycCategory.food.id,
        submittedDocumentCount: 0,
      ),
      '₹1049',
    );
  });

  test('aadhaar upload only accepts image paths', () {
    expect(KycValidators.isImagePath(null), isFalse);
    expect(KycValidators.isImagePath(''), isFalse);
    expect(KycValidators.isImagePath('/tmp/aadhaar.pdf'), isFalse);
    expect(KycValidators.isImagePath('/tmp/AADHAAR.PDF'), isFalse);
    expect(KycValidators.isImagePath('/tmp/aadhaar.jpg'), isTrue);
    expect(KycValidators.isImagePath('/tmp/aadhaar.png'), isTrue);
    expect(KycValidators.isImagePath('/tmp/AADHAAR.JPEG'), isTrue);
  });

  test('store image continue is optional', () {
    expect(KycValidators.canContinueStoreImage(null), isTrue);
    expect(KycValidators.canContinueStoreImage(''), isTrue);
    expect(KycValidators.canContinueStoreImage('/tmp/store.jpg'), isTrue);
  });
}
