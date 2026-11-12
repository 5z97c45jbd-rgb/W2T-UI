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
      'individuals': [],
    });

    expect(merchants.restaurants.single.name, 'Sample Restaurant');
    expect(merchants.restaurants.single.category, MerchantCategory.food);
    expect(merchants.groceries.single.category, MerchantCategory.groceries);
    expect(merchants.individuals, isEmpty);
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

  test('create-with-image payload uses merchantId as the business id', () {
    final merchant = Merchant.fromCreatePayload(
      {
        'merchantId': '408a0537-002b-432c-acf3-468aa02de344',
        'id': '8f5013c8-d1f2-4efc-ae60-8c5464da6673',
        'mediaId': '5da33014-f686-4786-8b28-3256f664e430',
        'uploadUrl':
            'product_category/MARKET_PLACE/products/408a0537-002b-432c-acf3-468aa02de344/5da33014-f686-4786-8b28-3256f664e430',
        'expiresInSeconds': 600,
      },
      name: 'FreshMart',
      category: 'FOOD',
    );

    expect(merchant, isNotNull);
    expect(merchant!.id, '408a0537-002b-432c-acf3-468aa02de344');
    expect(merchant.name, 'FreshMart');
  });

  test('maps API category values for see-all routes', () {
    expect(MerchantCategory.food.apiValue, 'FOOD');
    expect(MerchantCategory.groceries.apiValue, 'GROCERIES');
    expect(MerchantCategory.individuals.apiValue, 'INDIVIDUALS');
    expect(MerchantCategory.tryParse('FOOD'), MerchantCategory.food);
  });
}
