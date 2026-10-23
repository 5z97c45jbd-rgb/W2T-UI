import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/home/data/models/merchant.dart';

void main() {
  test('parses grouped home merchants by category', () {
    final merchants = HomeMerchants.fromJson({
      'restaurants': [
        {
          'id': '1',
          'name': 'Sample Restaurant',
          'category': 'FOOD',
          'ratings': 5,
          'url': 'https://example.com/restaurant.jpg',
        },
      ],
      'groceries': [
        {
          'id': '2',
          'name': 'Daily Mart',
          'category': 'GROCERIES',
          'ratings': 4,
        },
      ],
      'pharmacy': [],
    });

    expect(merchants.restaurants.single.name, 'Sample Restaurant');
    expect(merchants.restaurants.single.category, MerchantCategory.food);
    expect(merchants.groceries.single.category, MerchantCategory.groceries);
    expect(merchants.pharmacy, isEmpty);
  });

  test('parses a category list of merchants', () {
    final merchants = Merchant.listFrom([
      {
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'userId': '550e8400-e29b-41d4-a716-446655440001',
        'name': 'Sample Restaurant',
        'category': 'FOOD',
        'ratings': 5,
        'url': 'https://example.com/restaurant.jpg',
      },
    ]);

    expect(merchants, hasLength(1));
    expect(merchants.single.id, '550e8400-e29b-41d4-a716-446655440000');
    expect(merchants.single.ratings, 5);
    expect(merchants.single.imageUrl, 'https://example.com/restaurant.jpg');
  });

  test('maps API category values for see-all routes', () {
    expect(MerchantCategory.food.apiValue, 'FOOD');
    expect(MerchantCategory.groceries.apiValue, 'GROCERIES');
    expect(MerchantCategory.pharmacy.apiValue, 'PHARMACY');
    expect(MerchantCategory.tryParse('FOOD'), MerchantCategory.food);
  });
}
