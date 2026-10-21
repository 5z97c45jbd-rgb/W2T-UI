import 'package:flutter/material.dart';

class FavouriteColor {
  const FavouriteColor({required this.name, required this.value});

  final String name;
  final Color value;

  static const options = [
    FavouriteColor(name: 'Blue', value: Color(0xFF3B82F6)),
    FavouriteColor(name: 'Pink', value: Color(0xFFF9A8D4)),
    FavouriteColor(name: 'Purple', value: Color(0xFFC084FC)),
    FavouriteColor(name: 'Green', value: Color(0xFF34D399)),
    FavouriteColor(name: 'Yellow', value: Color(0xFFFBBF24)),
    FavouriteColor(name: 'Orange', value: Color(0xFFFB923C)),
    FavouriteColor(name: 'White', value: Color(0xFFF3F4F6)),
  ];

  static FavouriteColor? matching(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;
    final lower = value.toLowerCase();
    for (final color in options) {
      if (color.name.toLowerCase() == lower) return color;
    }
    return null;
  }
}
