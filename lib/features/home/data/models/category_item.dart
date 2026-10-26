import 'package:flutter/material.dart';

class CategoryItem {
  const CategoryItem({
    required this.label,
    required this.background,
    this.emoji,
    this.imageAsset,
  });

  final String label;
  final Color background;
  final String? emoji;
  final String? imageAsset;
}
