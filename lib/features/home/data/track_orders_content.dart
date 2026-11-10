import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';
import 'package:w2t_mobile/features/home/data/models/tracked_order.dart';

abstract final class TrackOrdersContent {
  static final samples = <TrackedOrder>[
    TrackedOrder.fromOrderItem(
      OrderItem(
        id: 'W2T1298347',
        side: OrderSide.purchased,
        category: 'Food',
        partyName: 'The Food Court',
        itemCount: 3,
        amountLabel: '₹563',
        placedAt: DateTime(2026, 11, 9, 12, 28),
        status: OrderStatus.outForDelivery,
        imageAsset: AppAssets.foodCourt,
      ),
    ).copyWith(
      merchantMeta: 'Restaurant • Indian, Biryani',
      statusLabel: 'On the Way',
      items: const [
        TrackedLineItem(
          name: 'Hyderabadi Chicken Biryani',
          quantity: 1,
          amountLabel: '₹249',
          imageAsset: AppAssets.paradiseBiryani,
        ),
        TrackedLineItem(
          name: 'Paneer Butter Masala',
          quantity: 1,
          amountLabel: '₹189',
          imageAsset: AppAssets.spiceVilla,
        ),
        TrackedLineItem(
          name: 'Butter Naan',
          quantity: 1,
          amountLabel: '₹125',
          imageAsset: AppAssets.bread,
        ),
      ],
      steps: const [
        DeliveryStep(
          title: 'Order Placed',
          subtitle: 'Today, 12:28 PM',
          state: DeliveryStepState.done,
        ),
        DeliveryStep(
          title: 'Confirmed by Restaurant',
          subtitle: 'Today, 12:31 PM',
          state: DeliveryStepState.done,
        ),
        DeliveryStep(
          title: 'Preparing Your Order',
          subtitle: 'Today, 12:35 PM',
          state: DeliveryStepState.done,
        ),
        DeliveryStep(
          title: 'Picked Up by Delivery Partner',
          subtitle: 'Today, 12:52 PM',
          state: DeliveryStepState.done,
        ),
        DeliveryStep(
          title: 'On the Way',
          subtitle: 'Your order is on the way to your location',
          state: DeliveryStepState.current,
        ),
        DeliveryStep(
          title: 'Delivered',
          subtitle: 'Not yet delivered',
          state: DeliveryStepState.pending,
        ),
      ],
    ),
    TrackedOrder.fromOrderItem(
      OrderItem(
        id: 'W2T2003908',
        side: OrderSide.purchased,
        category: 'Electronics',
        partyName: 'Amit Reddy',
        itemCount: 2,
        amountLabel: '₹420',
        placedAt: DateTime(2026, 11, 9, 11, 40),
        status: OrderStatus.preparing,
        imageAsset: AppAssets.vitaminSupplements,
      ),
    ).copyWith(
      merchantMeta: 'Electronics • 2 items',
      statusLabel: 'Preparing',
    ),
    TrackedOrder.fromOrderItem(
      OrderItem(
        id: 'W2T2003910',
        side: OrderSide.purchased,
        category: 'Food',
        partyName: 'Paradise Biryani',
        itemCount: 3,
        amountLabel: '₹640',
        placedAt: DateTime(2026, 11, 8, 20, 15),
        status: OrderStatus.delivered,
        imageAsset: AppAssets.paradiseBiryani,
      ),
    ).copyWith(
      merchantMeta: 'Restaurant • Biryani',
      statusLabel: 'Delivered',
    ),
  ];

  static List<TrackedOrder> fromOrders(List<OrderItem> orders) {
    final purchased = orders
        .where((order) => order.side == OrderSide.purchased)
        .toList()
      ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
    if (purchased.isEmpty) return samples;
    return [
      for (final order in purchased.take(8)) TrackedOrder.fromOrderItem(order),
    ];
  }
}
