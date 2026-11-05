import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/home/data/catalog_categories.dart';
import 'package:w2t_mobile/features/home/data/models/explore_video.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';

void main() {
  test('parses sold and purchased orders from the orders API payload', () {
    final json = {
      'orderId': '6dd393cc-0bd2-4163-af66-fcd312864a24',
      'orderBy': 'e1d1eae0-454d-4e1f-9920-ff25522c966f',
      'orderStatus': 'PAYMENT_FAILED',
      'createdAt': '2026-10-28T06:01:06.001137Z',
      'amount': 300,
      'currency': 'INR',
      'orderPic': null,
      'purchasedBy': null,
    };

    final sold = OrderItem.fromJson(json, OrderSide.sold)!;
    expect(sold.id, '6dd393cc-0bd2-4163-af66-fcd312864a24');
    expect(sold.partyName, isEmpty);
    expect(sold.amountLabel, '₹300');
    expect(sold.status, OrderStatus.paymentFailed);
    expect(sold.displayStatus, 'Payment Failed');
    expect(sold.category, isEmpty);

    final purchased = OrderItem.fromJson(json, OrderSide.purchased)!;
    expect(purchased.side, OrderSide.purchased);
    expect(purchased.partyName, isEmpty);

    final named = OrderItem.fromJson(
      {
        ...json,
        'fullName': 'Ravi Kumar',
      },
      OrderSide.sold,
    )!;
    expect(named.partyName, 'Ravi Kumar');

    final nestedName = OrderItem.fromJson(
      {
        ...json,
        'orderBy': {
          'userId': 'e1d1eae0-454d-4e1f-9920-ff25522c966f',
          'fullName': 'Priya Sharma',
        },
      },
      OrderSide.purchased,
    )!;
    expect(nestedName.partyName, 'Priya Sharma');
  });

  test('parses explore items and maps category path values', () {
    expect(CatalogCategories.apiValue('Individuals'), 'INDIVIDUALS');
    expect(CatalogCategories.apiValue('Food'), 'FOOD');
    expect(CatalogCategories.apiValue('Grocery'), 'GROCERIES');

    final video = ExploreVideo.fromJson(
      {
        'itemId': '6a27cea8-4606-44b1-bad5-ad389800204a',
        'name': 'Street noodles',
        'quantity': 2,
        'tags': ['Trending'],
        'likes': 23,
        'itemUrl': null,
        'videoUrl': null,
        'amount': 500,
      },
      category: 'Food',
    )!;

    expect(video.title, 'Street noodles');
    expect(video.likesLabel, '23');
    expect(video.costLabel, '₹500');
    expect(video.trending, isTrue);
    expect(video.hasTopic('Trending'), isTrue);
    expect(video.imageUrl, isNull);
    expect(video.imageAsset, isNotEmpty);
  });
}
