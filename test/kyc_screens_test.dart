import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_category.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_business_details_screen.dart';
import 'package:w2t_mobile/features/kyc/ui/kyc_category_screen.dart';
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
    expect(find.text('Individuals'), findsOneWidget);
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
  });

  test('business types match KYC categories', () {
    expect(
      KycValidators.businessTypes,
      [
        'Food',
        'Grocery',
        'Individuals',
        'Electronics',
        'Pet Care',
        'Self Talent',
        'Child Care',
      ],
    );
  });
}
