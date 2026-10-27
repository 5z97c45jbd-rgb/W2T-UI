import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';

enum OrderSide { sold, purchased }

enum OrderSort { latestFirst, oldestFirst }

enum OrderStatus {
  delivered,
  preparing,
  cancelled,
  outForDelivery,
  returnRequested,
}

class OrderCategoryFilter extends Equatable {
  const OrderCategoryFilter({
    required this.label,
    required this.background,
    this.emoji,
    this.icon,
  });

  final String label;
  final Color background;
  final String? emoji;
  final IconData? icon;

  @override
  List<Object?> get props => [label, background, emoji, icon];
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
      ];
}

extension OrderStatusStyle on OrderStatus {
  String get label => switch (this) {
        OrderStatus.delivered => 'Delivered',
        OrderStatus.preparing => 'Preparing',
        OrderStatus.cancelled => 'Cancelled',
        OrderStatus.outForDelivery => 'Out for Delivery',
        OrderStatus.returnRequested => 'Return Requested',
      };

  Color get foreground => switch (this) {
        OrderStatus.delivered => const Color(0xFF2F9E57),
        OrderStatus.preparing => const Color(0xFF4C8DFF),
        OrderStatus.cancelled => const Color(0xFFE25C5C),
        OrderStatus.outForDelivery => const Color(0xFF3D4A5C),
        OrderStatus.returnRequested => AppColors.offerOrange,
      };

  Color get background => switch (this) {
        OrderStatus.delivered => const Color(0xFFE6F7ED),
        OrderStatus.preparing => const Color(0xFFE8F1FF),
        OrderStatus.cancelled => const Color(0xFFFDECEC),
        OrderStatus.outForDelivery => const Color(0xFFEEF1F4),
        OrderStatus.returnRequested => const Color(0xFFFFF1E6),
      };
}

extension OrderSortLabel on OrderSort {
  String get label => switch (this) {
        OrderSort.latestFirst => 'Latest First',
        OrderSort.oldestFirst => 'Oldest First',
      };
}
