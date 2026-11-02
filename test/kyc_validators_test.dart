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
}
