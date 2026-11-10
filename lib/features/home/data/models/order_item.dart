import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';

enum OrderSide { sold, purchased }

enum OrderSort { latestFirst, oldestFirst }

enum OrderStatus {
  delivered,
  preparing,
  cancelled,
  outForDelivery,
  returnRequested,
  paymentFailed,
}

class OrderItem extends Equatable {
  const OrderItem({
    required this.id,
    required this.side,
    required this.category,
    required this.partyName,
    required this.itemCount,
    required this.amountLabel,
    required this.placedAt,
    required this.status,
    required this.imageAsset,
    this.imageUrl,
    this.statusLabel,
  });

  final String id;
  final OrderSide side;
  final String category;
  final String partyName;
  final int itemCount;
  final String amountLabel;
  final DateTime placedAt;
  final OrderStatus status;
  final String imageAsset;
  final String? imageUrl;
  final String? statusLabel;

  String get displayStatus => statusLabel ?? status.label;

  OrderItem copyWith({
    String? id,
    OrderSide? side,
    String? category,
    String? partyName,
    int? itemCount,
    String? amountLabel,
    DateTime? placedAt,
    OrderStatus? status,
    String? imageAsset,
    String? imageUrl,
    String? statusLabel,
  }) {
    return OrderItem(
      id: id ?? this.id,
      side: side ?? this.side,
      category: category ?? this.category,
      partyName: partyName ?? this.partyName,
      itemCount: itemCount ?? this.itemCount,
      amountLabel: amountLabel ?? this.amountLabel,
      placedAt: placedAt ?? this.placedAt,
      status: status ?? this.status,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      statusLabel: statusLabel ?? this.statusLabel,
    );
  }

  String get itemCountLabel =>
      itemCount == 1 ? '1 item' : '$itemCount items';

  String get placedAtLabel {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = placedAt.hour % 12 == 0 ? 12 : placedAt.hour % 12;
    final minute = placedAt.minute.toString().padLeft(2, '0');
    final period = placedAt.hour >= 12 ? 'PM' : 'AM';
    return '${placedAt.day} ${months[placedAt.month - 1]} ${placedAt.year}, '
        '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  static OrderItem? fromJson(dynamic json, OrderSide side) {
    if (json is! Map) return null;
    final id = _nonEmpty(json['orderId']);
    if (id == null) return null;

    final statusValue = _nonEmpty(json['orderStatus']);
    return OrderItem(
      id: id,
      side: side,
      category: _nonEmpty(json['category']) ?? '',
      partyName: _partyName(json, side),
      itemCount: _int(json['quantity'] ?? json['itemCount']) ?? 1,
      amountLabel: _amountLabel(json['amount'], json['currency']),
      placedAt: _date(json['createdAt']) ?? DateTime.now(),
      status: OrderStatusX.fromApi(statusValue),
      statusLabel: statusValue == null ? null : _humanize(statusValue),
      imageAsset: _fallbackAsset(_nonEmpty(json['category'])),
      imageUrl: usableImageUrl(
        json['orderPic'] ?? json['imageUrl'] ?? json['itemPic'],
      ),
    );
  }

  static List<OrderItem> listFrom(dynamic json, OrderSide side) {
    if (json is! List) return const [];
    return json
        .map((item) => fromJson(item, side))
        .whereType<OrderItem>()
        .toList(growable: false);
  }

  static String _partyName(Map json, OrderSide side) {
    final fromFullName = _firstFullName(json);
    if (fromFullName != null) return fromFullName;

    for (final value in [
      json['name'],
      if (side == OrderSide.purchased) json['merchantName'],
      if (side == OrderSide.sold) json['customerName'],
    ]) {
      final text = _nonEmpty(value);
      if (text != null && !_looksLikeId(text)) return text;
    }
    return '';
  }

  static String? _firstFullName(Map json) {
    final own = _fullNameIn(json);
    if (own != null) return own;
    for (final value in json.values) {
      final nested = _asMap(value);
      if (nested == null) continue;
      final name = _fullNameIn(nested);
      if (name != null) return name;
    }
    return null;
  }

  static String? _fullNameIn(Map json) {
    for (final entry in json.entries) {
      final key = entry.key.toString().toLowerCase().replaceAll(RegExp(r'[_-]'), '');
      if (key != 'fullname') continue;
      final text = _nonEmpty(entry.value);
      if (text != null && !_looksLikeId(text)) return text;
    }
    return null;
  }

  static Map<Object?, Object?>? _asMap(Object? value) {
    if (value is! Map) return null;
    return Map<Object?, Object?>.from(value);
  }

  static bool _looksLikeId(String value) {
    final compact = value.replaceAll('-', '');
    return RegExp(r'^[0-9a-fA-F]{16,}$').hasMatch(compact);
  }

  static String _amountLabel(Object? amount, Object? currency) {
    final value = amount is num
        ? amount.toDouble()
        : double.tryParse(amount?.toString() ?? '') ?? 0;
    final code = (currency?.toString() ?? 'INR').trim().toUpperCase();
    final symbol = switch (code) {
      'INR' || 'RS' || 'RUPEE' || 'RUPEES' => '₹',
      'USD' => '\$',
      'EUR' => '€',
      'AED' => 'AED ',
      _ => code.isEmpty ? '₹' : '$code ',
    };
    if (value == value.roundToDouble()) {
      return '$symbol${value.toInt()}';
    }
    return '$symbol${value.toStringAsFixed(2)}';
  }

  static DateTime? _date(Object? value) {
    if (value is DateTime) return value.toLocal();
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim())?.toLocal();
    }
    return null;
  }

  static int? _int(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  static String? _nonEmpty(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? usableImageUrl(Object? value) {
    final text = _nonEmpty(value);
    if (text == null) return null;
    final lower = text.toLowerCase();
    if (lower == 'null' ||
        lower == 'undefined' ||
        lower == 'string' ||
        lower == 'none' ||
        lower == 'n/a' ||
        lower == '-' ||
        lower == 'null.png' ||
        lower.endsWith('/null') ||
        lower.endsWith('/undefined')) {
      return null;
    }
    return text;
  }

  static String _humanize(String raw) {
    return raw
        .split(RegExp(r'[_\s-]+'))
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  static String _fallbackAsset(String? category) {
    switch (category?.trim().toLowerCase()) {
      case 'grocery':
      case 'groceries':
        return AppAssets.freshVegetables;
      case 'individuals':
      case 'individual':
        return AppAssets.skincarePersonalCare;
      case 'electronics':
        return AppAssets.urbanBites;
      case 'fashion':
        return AppAssets.skincarePersonalCare;
      default:
        return AppAssets.noodleHub;
    }
  }

  @override
  List<Object?> get props => [
        id,
        side,
        category,
        partyName,
        itemCount,
        amountLabel,
        placedAt,
        status,
        imageAsset,
        imageUrl,
        statusLabel,
      ];
}

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
        OrderStatus.delivered => 'Delivered',
        OrderStatus.preparing => 'Preparing',
        OrderStatus.cancelled => 'Cancelled',
        OrderStatus.outForDelivery => 'Out for Delivery',
        OrderStatus.returnRequested => 'Return Requested',
        OrderStatus.paymentFailed => 'Payment Failed',
      };

  Color get foreground => switch (this) {
        OrderStatus.delivered => const Color(0xFF2F9E57),
        OrderStatus.preparing => const Color(0xFF4C8DFF),
        OrderStatus.cancelled => const Color(0xFFE25C5C),
        OrderStatus.outForDelivery => const Color(0xFF3D4A5C),
        OrderStatus.returnRequested => AppColors.offerOrange,
        OrderStatus.paymentFailed => const Color(0xFFE25C5C),
      };

  Color get background => switch (this) {
        OrderStatus.delivered => const Color(0xFFE6F7ED),
        OrderStatus.preparing => const Color(0xFFE8F1FF),
        OrderStatus.cancelled => const Color(0xFFFDECEC),
        OrderStatus.outForDelivery => const Color(0xFFEEF1F4),
        OrderStatus.returnRequested => const Color(0xFFFFF1E6),
        OrderStatus.paymentFailed => const Color(0xFFFDECEC),
      };

  static OrderStatus fromApi(String? value) {
    switch (value?.trim().toUpperCase()) {
      case 'DELIVERED':
      case 'COMPLETED':
      case 'SUCCESS':
        return OrderStatus.delivered;
      case 'OUT_FOR_DELIVERY':
      case 'SHIPPED':
      case 'DISPATCHED':
        return OrderStatus.outForDelivery;
      case 'CANCELLED':
      case 'CANCELED':
        return OrderStatus.cancelled;
      case 'PAYMENT_FAILED':
      case 'FAILED':
        return OrderStatus.paymentFailed;
      case 'RETURN_REQUESTED':
      case 'RETURN':
      case 'RETURNED':
        return OrderStatus.returnRequested;
      default:
        return OrderStatus.preparing;
    }
  }
}

extension OrderSortLabel on OrderSort {
  String get label => switch (this) {
        OrderSort.latestFirst => 'Latest First',
        OrderSort.oldestFirst => 'Oldest First',
      };
}
