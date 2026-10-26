import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/features/home/data/models/restaurant_item.dart';

enum MerchantCategory {
  food,
  groceries,
  individuals;

  String get apiValue => switch (this) {
        food => 'FOOD',
        groceries => 'GROCERIES',
        individuals => 'INDIVIDUALS',
      };

  String get title => switch (this) {
        food => 'Featured Restaurants',
        groceries => 'Grocery Essentials',
        individuals => 'Individuals',
      };

  String get subtitle => switch (this) {
        food => 'Discover top restaurants near you',
        groceries => 'Everyday grocery stores near you',
        individuals => 'Independent sellers and service providers near you',
      };

  String get searchHint => switch (this) {
        food => 'Search restaurants...',
        groceries => 'Search grocery stores...',
        individuals => 'Search individuals...',
      };

  String get emptyLabel => switch (this) {
        food => 'No restaurants yet',
        groceries => 'No grocery stores yet',
        individuals => 'No individuals yet',
      };

  String get countLabel => switch (this) {
        food => 'restaurants',
        groceries => 'stores',
        individuals => 'individuals',
      };

  IconData get icon => switch (this) {
        food => Icons.restaurant_rounded,
        groceries => Icons.shopping_cart_outlined,
        individuals => Icons.person_outline_rounded,
      };

  String get fallbackAsset => switch (this) {
        food => AppAssets.paradiseBiryani,
        groceries => AppAssets.freshFruits,
        individuals => AppAssets.personBackground,
      };

  RestaurantBrand get brand => switch (this) {
        food => const RestaurantBrand(
            background: Color(0xFF1C1C1C),
            icon: Icons.restaurant_rounded,
            iconColor: Color(0xFFFF8A3D),
          ),
        groceries => const RestaurantBrand(
            background: Color(0xFF1B2A1C),
            icon: Icons.shopping_basket_rounded,
            iconColor: Color(0xFF7CDB6A),
          ),
        individuals => const RestaurantBrand(
            background: Color(0xFF1E2A38),
            icon: Icons.person_rounded,
            iconColor: Color(0xFF6BCBFF),
          ),
      };

  static MerchantCategory fromApi(String? value) {
    switch (value?.trim().toUpperCase()) {
      case 'FOOD':
      case 'RESTAURANT':
      case 'RESTAURANTS':
        return MerchantCategory.food;
      case 'GROCERIES':
      case 'GROCERY':
        return MerchantCategory.groceries;
      case 'INDIVIDUALS':
      case 'INDIVIDUAL':
      case 'PHARMACY':
      case 'PHARMACIES':
        return MerchantCategory.individuals;
      default:
        return MerchantCategory.food;
    }
  }

  static MerchantCategory? tryParse(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value.trim().toUpperCase();
    for (final category in MerchantCategory.values) {
      if (category.apiValue == normalized ||
          category.name.toUpperCase() == normalized) {
        return category;
      }
    }
    return fromApi(normalized);
  }
}

class Merchant extends Equatable {
  const Merchant({
    required this.id,
    required this.name,
    required this.category,
    required this.ratings,
    this.userId,
    this.imageUrl,
    this.enabled = true,
    this.kycApproved = true,
  });

  final String id;
  final String name;
  final MerchantCategory category;
  final double ratings;
  final String? userId;
  final String? imageUrl;
  final bool enabled;
  final bool kycApproved;

  RestaurantItem toRestaurantItem() {
    return RestaurantItem(
      id: id,
      name: name,
      imageAsset: category.fallbackAsset,
      imageUrl: imageUrl,
      rating: ratings,
      reviewCount: 0,
      deliveryTime: '',
      brand: category.brand,
      priceForTwo: 0,
      distanceKm: 0,
      cuisines: const [],
    );
  }

  static Merchant? fromJson(dynamic json) {
    if (json is! Map) return null;
    final id = _nonEmpty(json['id']);
    final name = _nonEmpty(json['name']);
    if (id == null || name == null) return null;

    return Merchant(
      id: id,
      name: name,
      category: MerchantCategory.fromApi(_nonEmpty(json['category'])),
      ratings: _rating(json['ratings']),
      userId: _nonEmpty(json['userId']),
      imageUrl: _nonEmpty(json['url']) ?? _nonEmpty(json['imageUrl']),
      enabled: json['enabled'] != false,
      kycApproved: json['kycApproved'] != false,
    );
  }

  static List<Merchant> listFrom(dynamic json) {
    if (json is! List) return const [];
    return json
        .map(Merchant.fromJson)
        .whereType<Merchant>()
        .toList(growable: false);
  }

  static String? _nonEmpty(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static double _rating(Object? value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.trim()) ?? 0;
    return 0;
  }

  @override
  List<Object?> get props =>
      [id, name, category, ratings, userId, imageUrl, enabled, kycApproved];
}

class HomeMerchants extends Equatable {
  const HomeMerchants({
    this.restaurants = const [],
    this.groceries = const [],
    this.individuals = const [],
  });

  final List<Merchant> restaurants;
  final List<Merchant> groceries;
  final List<Merchant> individuals;

  List<Merchant> forCategory(MerchantCategory category) {
    return switch (category) {
      MerchantCategory.food => restaurants,
      MerchantCategory.groceries => groceries,
      MerchantCategory.individuals => individuals,
    };
  }

  static HomeMerchants fromJson(dynamic json) {
    if (json is! Map) return const HomeMerchants();
    return HomeMerchants(
      restaurants: Merchant.listFrom(json['restaurants']),
      groceries: Merchant.listFrom(json['groceries']),
      individuals: Merchant.listFrom(
        json['individuals'] ?? json['pharmacy'],
      ),
    );
  }

  @override
  List<Object?> get props => [restaurants, groceries, individuals];
}
