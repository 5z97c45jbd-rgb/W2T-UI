import 'package:flutter/material.dart';
import 'package:w2t_mobile/features/home/data/home_content.dart';
import 'package:w2t_mobile/features/home/data/models/category_item.dart';

class KycCategory {
  const KycCategory({
    required this.id,
    required this.item,
  });

  final String id;
  final CategoryItem item;

  String get label => item.label;
  Color get background => item.background;
  String? get emoji => item.emoji;
  String? get imageAsset => item.imageAsset;

  static const foodId = 'food';
  static const groceryId = 'grocery';
  static const selfTalentId = 'self_talent';

  static final all = [
    for (final item in HomeContent.categories)
      KycCategory(
        id: idFor(item.label),
        item: item,
      ),
  ];

  static KycCategory get food =>
      all.firstWhere((category) => category.id == foodId);

  static KycCategory get grocery =>
      all.firstWhere((category) => category.id == groceryId);

  static KycCategory get selfTalent =>
      all.firstWhere((category) => category.id == selfTalentId);

  static String idFor(String label) {
    return label.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  }

  static KycCategory? byId(String? id) {
    if (id == null) return null;
    for (final category in all) {
      if (category.id == id) return category;
    }
    return null;
  }
}
