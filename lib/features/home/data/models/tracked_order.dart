import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';

enum DeliveryStepState { done, current, pending }

class TrackedLineItem extends Equatable {
  const TrackedLineItem({
    required this.name,
    required this.quantity,
    required this.amountLabel,
    required this.imageAsset,
    this.imageUrl,
  });

  final String name;
  final int quantity;
  final String amountLabel;
  final String imageAsset;
  final String? imageUrl;

  @override
  List<Object?> get props => [name, quantity, amountLabel, imageAsset, imageUrl];
}

class DeliveryPartner extends Equatable {
  const DeliveryPartner({
    required this.name,
    required this.rating,
    required this.deliveries,
  });

  final String name;
  final double rating;
  final int deliveries;

  String get deliveriesLabel {
    final raw = deliveries.toString();
    if (raw.length <= 3) return '$raw deliveries';
    final head = raw.substring(0, raw.length - 3);
    final tail = raw.substring(raw.length - 3);
    return '$head,$tail deliveries';
  }

  @override
  List<Object?> get props => [name, rating, deliveries];
}

class DeliveryStep extends Equatable {
  const DeliveryStep({
    required this.title,
    required this.subtitle,
    required this.state,
  });

  final String title;
  final String subtitle;
  final DeliveryStepState state;

  @override
  List<Object?> get props => [title, subtitle, state];
}

class TrackedOrder extends Equatable {
  const TrackedOrder({
    required this.id,
    required this.displayId,
    required this.merchantName,
    required this.merchantMeta,
    required this.imageAsset,
    required this.status,
    required this.statusLabel,
    required this.placedAt,
    required this.etaMinutes,
    required this.distanceKm,
    required this.destinationLabel,
    required this.paymentLabel,
    required this.totalLabel,
    required this.items,
    required this.steps,
    required this.partner,
    required this.restaurantPoint,
    required this.riderPoint,
    required this.destinationPoint,
    required this.route,
    this.imageUrl,
    this.category = 'Restaurant',
  });

  final String id;
  final String displayId;
  final String merchantName;
  final String merchantMeta;
  final String imageAsset;
  final String? imageUrl;
  final String category;
  final OrderStatus status;
  final String statusLabel;
  final DateTime placedAt;
  final int etaMinutes;
  final double distanceKm;
  final String destinationLabel;
  final String paymentLabel;
  final String totalLabel;
  final List<TrackedLineItem> items;
  final List<DeliveryStep> steps;
  final DeliveryPartner partner;
  final LatLng restaurantPoint;
  final LatLng riderPoint;
  final LatLng destinationPoint;
  final List<LatLng> route;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get itemCountLabel =>
      itemCount == 1 ? '1 item' : '$itemCount items';

  String get etaLabel => '$etaMinutes min';

  String get remainingLabel => '${distanceKm.toStringAsFixed(1)} km';

  bool get isLive =>
      status == OrderStatus.preparing || status == OrderStatus.outForDelivery;

  String get placedAtShort {
    final hour = placedAt.hour % 12 == 0 ? 12 : placedAt.hour % 12;
    final minute = placedAt.minute.toString().padLeft(2, '0');
    final period = placedAt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  static TrackedOrder fromOrderItem(OrderItem order) {
    final sample = _bangaloreSample(order.id, order.placedAt, order.status);
    final items = [
      TrackedLineItem(
        name: order.partyName.isEmpty ? 'Order item' : order.partyName,
        quantity: order.itemCount,
        amountLabel: order.amountLabel,
        imageAsset: order.imageAsset,
        imageUrl: order.imageUrl,
      ),
    ];
    return sample.copyWith(
      displayId: order.id.replaceFirst('#', ''),
      merchantName:
          order.partyName.isEmpty ? 'W2T Merchant' : order.partyName,
      merchantMeta: order.category.isEmpty
          ? 'Order'
          : '${order.category} • ${order.itemCountLabel}',
      imageAsset: order.imageAsset,
      imageUrl: order.imageUrl,
      category: order.category.isEmpty ? 'Order' : order.category,
      status: order.status,
      statusLabel: _badgeLabel(order.status),
      totalLabel: order.amountLabel,
      items: items,
      steps: _stepsFor(order.status, order.placedAt),
    );
  }

  TrackedOrder copyWith({
    String? displayId,
    String? merchantName,
    String? merchantMeta,
    String? imageAsset,
    String? imageUrl,
    String? category,
    OrderStatus? status,
    String? statusLabel,
    String? totalLabel,
    List<TrackedLineItem>? items,
    List<DeliveryStep>? steps,
  }) {
    return TrackedOrder(
      id: id,
      displayId: displayId ?? this.displayId,
      merchantName: merchantName ?? this.merchantName,
      merchantMeta: merchantMeta ?? this.merchantMeta,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      placedAt: placedAt,
      etaMinutes: etaMinutes,
      distanceKm: distanceKm,
      destinationLabel: destinationLabel,
      paymentLabel: paymentLabel,
      totalLabel: totalLabel ?? this.totalLabel,
      items: items ?? this.items,
      steps: steps ?? this.steps,
      partner: partner,
      restaurantPoint: restaurantPoint,
      riderPoint: riderPoint,
      destinationPoint: destinationPoint,
      route: route,
    );
  }

  static String _badgeLabel(OrderStatus status) => switch (status) {
        OrderStatus.outForDelivery => 'On the Way',
        OrderStatus.preparing => 'Preparing',
        OrderStatus.delivered => 'Delivered',
        OrderStatus.cancelled => 'Cancelled',
        OrderStatus.returnRequested => 'Return',
        OrderStatus.paymentFailed => 'Payment Failed',
      };

  static String _clock(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return 'Today, $hour:$minute $period';
  }

  static List<DeliveryStep> _stepsFor(OrderStatus status, DateTime placedAt) {
    final confirmed = placedAt.add(const Duration(minutes: 3));
    final preparing = placedAt.add(const Duration(minutes: 7));
    final picked = placedAt.add(const Duration(minutes: 24));
    final rank = switch (status) {
      OrderStatus.preparing => 2,
      OrderStatus.outForDelivery => 4,
      OrderStatus.delivered => 5,
      OrderStatus.cancelled => 1,
      OrderStatus.returnRequested => 5,
      OrderStatus.paymentFailed => 0,
    };

    DeliveryStepState stateFor(int index) {
      if (index < rank) return DeliveryStepState.done;
      if (index == rank) return DeliveryStepState.current;
      return DeliveryStepState.pending;
    }

    return [
      DeliveryStep(
        title: 'Order Placed',
        subtitle: _clock(placedAt),
        state: stateFor(0),
      ),
      DeliveryStep(
        title: 'Confirmed by Restaurant',
        subtitle: rank >= 1 ? _clock(confirmed) : 'Waiting for confirmation',
        state: stateFor(1),
      ),
      DeliveryStep(
        title: 'Preparing Your Order',
        subtitle: rank >= 2 ? _clock(preparing) : 'Kitchen will start shortly',
        state: stateFor(2),
      ),
      DeliveryStep(
        title: 'Picked Up by Delivery Partner',
        subtitle: rank >= 3 ? _clock(picked) : 'Partner will pick up soon',
        state: stateFor(3),
      ),
      DeliveryStep(
        title: 'On the Way',
        subtitle: rank >= 4
            ? 'Your order is on the way to your location'
            : 'Not yet started',
        state: stateFor(4),
      ),
      DeliveryStep(
        title: 'Delivered',
        subtitle: status == OrderStatus.delivered
            ? 'Order delivered'
            : 'Not yet delivered',
        state: stateFor(5),
      ),
    ];
  }

  static TrackedOrder _bangaloreSample(
    String id,
    DateTime placedAt,
    OrderStatus status,
  ) {
    // Real Bengaluru points: MG Road → Indiranagar along Old Madras Rd / 100 Feet Rd.
    const restaurant = LatLng(12.9756, 77.6067); // MG Road Metro
    const rider = LatLng(12.9778, 77.6302); // Ulsoor / towards Indiranagar
    const home = LatLng(12.9783, 77.6408); // Indiranagar 100 Feet Road
    const route = <LatLng>[
      restaurant,
      LatLng(12.9764, 77.6148), // Trinity
      LatLng(12.9772, 77.6225), // Ulsoor
      rider,
      LatLng(12.9781, 77.6358),
      home,
    ];
    return TrackedOrder(
      id: id,
      displayId: id.replaceFirst('#', ''),
      merchantName: 'Merchant',
      merchantMeta: 'Order',
      imageAsset: AppAssets.foodCourt,
      status: status,
      statusLabel: _badgeLabel(status),
      placedAt: placedAt,
      etaMinutes: status == OrderStatus.outForDelivery ? 12 : 22,
      distanceKm: 3.8,
      destinationLabel: 'Indiranagar, Bengaluru',
      paymentLabel: 'Razorpay',
      totalLabel: '₹0',
      items: const [],
      steps: _stepsFor(status, placedAt),
      partner: const DeliveryPartner(
        name: 'Ramesh Kumar',
        rating: 4.8,
        deliveries: 1254,
      ),
      restaurantPoint: restaurant,
      riderPoint: rider,
      destinationPoint: home,
      route: route,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayId,
        merchantName,
        status,
        placedAt,
        etaMinutes,
        totalLabel,
      ];
}
