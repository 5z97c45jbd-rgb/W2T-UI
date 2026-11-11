import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_category.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_business_details_screen.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_category_screen.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_documents_screen.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_review_screen.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_store_image_screen.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_store_location_screen.dart';

Widget _wrap(Widget child, KycRegistrationCubit cubit) {
  return BlocProvider.value(
    value: cubit,
    child: MaterialApp(home: child),
  );
}

void main() {
  testWidgets('category, business details and location screens',
      (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final cubit = KycRegistrationCubit();
    addTearDown(cubit.close);

    await tester.pumpWidget(_wrap(const KycCategoryScreen(), cubit));
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Continue'), findsNothing);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Grocery'), findsOneWidget);
    expect(find.text('Electronics'), findsOneWidget);
    expect(find.text('Pet Care'), findsOneWidget);
    expect(find.text('Self Talent'), findsOneWidget);
    expect(find.text('Child Care'), findsOneWidget);
    expect(find.text('Pharmacy'), findsNothing);
    expect(find.text('Fashion'), findsNothing);

    cubit.selectCategory(KycCategory.food.id);
    await tester.pumpWidget(_wrap(const KycBusinessDetailsScreen(), cubit));
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Store Location'), findsNothing);
    expect(find.text('Food'), findsWidgets);
    expect(find.text('Grocery Store'), findsNothing);

    await tester.pumpWidget(_wrap(const KycStoreLocationScreen(), cubit));
    expect(find.text('Store Location'), findsOneWidget);
    expect(find.text('Add your store address'), findsOneWidget);
    expect(find.text('Use Current Location'), findsOneWidget);
    expect(find.textContaining('Address Line 1'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('KYC\nDocuments'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);

    cubit.selectCategory(KycCategory.food.id);
    await tester.pumpWidget(_wrap(const KycDocumentsScreen(), cubit));
    expect(find.text('KYC Documents'), findsOneWidget);
    expect(find.textContaining('PAN Card'), findsOneWidget);
    expect(find.textContaining('GSTIN Number'), findsOneWidget);
    expect(find.textContaining('Shop Establishment Number'), findsOneWidget);
    expect(find.textContaining('FSSAI Number'), findsOneWidget);
    expect(find.text('Upload'), findsNothing);
    expect(find.textContaining('Aadhaar Card'), findsOneWidget);
    expect(find.text('Add Aadhaar photo'), findsOneWidget);

    cubit.selectCategory(KycCategory.selfTalent.id);
    await tester.pumpWidget(_wrap(const KycDocumentsScreen(), cubit));
    expect(find.textContaining('PAN Card'), findsOneWidget);
    expect(find.textContaining('GSTIN Number'), findsNothing);
    expect(find.textContaining('Shop Establishment Number'), findsNothing);
    expect(find.textContaining('FSSAI Number'), findsNothing);

    cubit.selectCategory(KycCategory.idFor('Grocery'));
    await tester.pumpWidget(_wrap(const KycDocumentsScreen(), cubit));
    expect(find.textContaining('GSTIN Number'), findsOneWidget);
    expect(find.textContaining('Shop Establishment Number'), findsOneWidget);
    expect(find.textContaining('FSSAI Number'), findsNothing);

    cubit.updateBusinessType('Child Care');
    await tester.pumpWidget(_wrap(const KycDocumentsScreen(), cubit));
    expect(find.textContaining('PAN Card'), findsOneWidget);
    expect(find.textContaining('GSTIN Number'), findsOneWidget);
    expect(find.textContaining('Shop Establishment Number'), findsOneWidget);
    expect(find.textContaining('FSSAI Number'), findsNothing);
    expect(find.textContaining('Aadhaar Card'), findsOneWidget);

    cubit.updateBusinessType('Self Talent');
    await tester.pumpWidget(_wrap(const KycDocumentsScreen(), cubit));
    expect(find.textContaining('PAN Card'), findsOneWidget);
    expect(find.textContaining('GSTIN Number'), findsNothing);
    expect(find.textContaining('FSSAI Number'), findsNothing);
    expect(find.textContaining('Aadhaar Card'), findsOneWidget);

    cubit.selectCategory(KycCategory.idFor('Grocery'));
    await tester.pumpWidget(_wrap(const KycStoreImageScreen(), cubit));
    expect(find.text('Shop/Store Image'), findsOneWidget);
    expect(find.text('Upload a clear photo of your store'), findsOneWidget);
    expect(find.text('Upload Store Image'), findsOneWidget);
    expect(find.text('PNG, JPG or PDF (Max 5 MB)'), findsOneWidget);
    expect(find.text('Front view of your store'), findsOneWidget);
    expect(find.text('Visible shop name / signboard'), findsOneWidget);
    expect(find.text('Clear and well lit'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    cubit.updateBusinessName('FreshMart Groceries');
    cubit.updateBusinessType('Grocery Store');
    cubit.updatePhone('9876543210');
    cubit.updateEmail('freshmart@example.com');
    cubit.updateAddressLine1('H.No 2-5-123, Main Road');
    cubit.updateCity('Hanamkonda');
    cubit.updatePincode('506001');
    cubit.updateState('Telangana');
    cubit.updatePan('ABCDE1234F');
    cubit.updateGstin('36ABCDE1234F1Z5');
    cubit.updateShopEstablishment('TL/HNK/123');
    await tester.pumpWidget(_wrap(const KycReviewScreen(), cubit));
    expect(find.text('Review & Submit'), findsOneWidget);
    expect(find.text('Please verify your details before submitting'), findsOneWidget);
    expect(find.text('Business Details'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('FreshMart Groceries'), findsOneWidget);
    expect(find.text('Store Location'), findsOneWidget);
    expect(find.text('Owner Details'), findsNothing);
    expect(find.text('KYC Documents'), findsOneWidget);
    expect(find.text('3 documents added'), findsOneWidget);
    expect(find.text('Food, groceries'), findsNothing);
    expect(find.text('KYC documents (3 + 1) × ₹50'), findsNothing);
    expect(find.text('Pay and Submit'), findsOneWidget);
    expect(find.text('₹1199'), findsOneWidget);
    expect(
      find.textContaining('I hereby confirm that the information provided'),
      findsOneWidget,
    );
  });

  test('business types match KYC categories', () {
    expect(
      KycValidators.businessTypes,
      [
        'Food',
        'Grocery',
        'Electronics',
        'Pet Care',
        'Self Talent',
        'Child Care',
      ],
    );
  });
}
