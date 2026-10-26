import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/features/home/data/models/catalog_item.dart';
import 'package:w2t_mobile/features/home/data/models/category_item.dart';
import 'package:w2t_mobile/features/home/data/models/restaurant_item.dart';

abstract final class HomeContent {
  static const categories = <CategoryItem>[
    CategoryItem(
      label: 'Food',
      emoji: '🍔',
      background: Color(0xFFFFE8D6),
    ),
    CategoryItem(
      label: 'Grocery',
      emoji: '🧺',
      background: Color(0xFFE4F6EA),
    ),
    CategoryItem(
      label: 'Individuals',
      emoji: '🧑‍💼',
      background: Color(0xFFE8EEF6),
    ),
    CategoryItem(
      label: 'Electronics',
      emoji: '💻',
      background: Color(0xFFE8EEF6),
    ),
    CategoryItem(
      label: 'Pet Care',
      emoji: '🐾',
      background: Color(0xFFFCE4EA),
    ),
    CategoryItem(
      label: 'Self Talent',
      imageAsset: AppAssets.categorySelfTalent,
      background: Color(0xFFEDE8F8),
    ),
    CategoryItem(
      label: 'Child Care',
      imageAsset: AppAssets.categoryChildCare,
      background: Color(0xFFFFF6EA),
    ),
  ];

  static const cuisineFilters = <String>[
    'All',
    'Biryani',
    'South Indian',
    'North Indian',
    'Chinese',
    'Fast Food',
    'Desserts',
  ];

  static const featuredRestaurants = <RestaurantItem>[
    RestaurantItem(
      name: 'Paradise Biryani',
      imageAsset: AppAssets.paradiseBiryani,
      rating: 4.5,
      reviewCount: 2100,
      deliveryTime: '25–35 mins',
      brand: RestaurantBrand(
        background: Color(0xFF1C1C1C),
        icon: Icons.spa_rounded,
        iconColor: Color(0xFFFF8A3D),
      ),
      priceForTwo: 200,
      distanceKm: 2.4,
      cuisines: ['Biryani', 'North Indian', 'Mughlai'],
      offerLabel: '20% OFF',
    ),
    RestaurantItem(
      name: 'The Food Court',
      imageAsset: AppAssets.foodCourt,
      rating: 4.4,
      reviewCount: 1300,
      deliveryTime: '20–30 mins',
      brand: RestaurantBrand(
        background: Color(0xFF2A2A2A),
        icon: Icons.restaurant_rounded,
      ),
      priceForTwo: 180,
      distanceKm: 1.8,
      cuisines: ['North Indian', 'Chinese', 'Continental'],
      offerLabel: 'Flat 30% OFF',
      offerHighlight: true,
    ),
    RestaurantItem(
      name: 'Urban Bites',
      imageAsset: AppAssets.urbanBites,
      rating: 4.3,
      reviewCount: 980,
      deliveryTime: '25–35 mins',
      brand: RestaurantBrand(
        background: Color(0xFF1A1A1A),
        icon: Icons.lunch_dining_rounded,
        iconColor: Color(0xFFFF8A3D),
      ),
      priceForTwo: 250,
      distanceKm: 3.1,
      cuisines: ['Pizza', 'Fast Food', 'Burgers'],
      offerLabel: '15% OFF',
    ),
    RestaurantItem(
      name: 'Green Bowl',
      imageAsset: AppAssets.greenBowl,
      rating: 4.6,
      reviewCount: 762,
      deliveryTime: '20–30 mins',
      brand: RestaurantBrand(
        background: Color(0xFF1B2A1C),
        icon: Icons.eco_rounded,
        iconColor: Color(0xFF7CDB6A),
      ),
      priceForTwo: 150,
      distanceKm: 2.0,
      cuisines: ['South Indian', 'Healthy', 'Breakfast'],
      offerLabel: 'Free Delivery',
      offerHighlight: true,
    ),
    RestaurantItem(
      name: 'Spice Villa',
      imageAsset: AppAssets.spiceVilla,
      rating: 4.4,
      reviewCount: 1100,
      deliveryTime: '30–40 mins',
      brand: RestaurantBrand(
        background: Color(0xFF1C1C1C),
        icon: Icons.local_fire_department_rounded,
        iconColor: Color(0xFFFF8A3D),
      ),
      priceForTwo: 220,
      distanceKm: 2.6,
      cuisines: ['North Indian', 'Tandoor', 'Chinese'],
      offerLabel: '25% OFF',
    ),
    RestaurantItem(
      name: 'Noodle Hub',
      imageAsset: AppAssets.noodleHub,
      rating: 4.2,
      reviewCount: 640,
      deliveryTime: '25–35 mins',
      brand: RestaurantBrand(
        background: Color(0xFF1C1C1C),
        icon: Icons.ramen_dining_rounded,
        iconColor: Color(0xFFFFC14D),
      ),
      priceForTwo: 180,
      distanceKm: 2.9,
      cuisines: ['Chinese', 'Thai', 'Asian'],
      offerLabel: 'Flat 40% OFF',
      offerHighlight: true,
    ),
  ];

  static const groceryEssentials = <CatalogItem>[
    CatalogItem(
      name: 'Fresh Fruits',
      imageAsset: AppAssets.freshFruits,
      price: '₹49',
      unit: '/kg',
    ),
    CatalogItem(
      name: 'Fresh Milk',
      imageAsset: AppAssets.freshMilk,
      price: '₹52',
      unit: '/1L',
    ),
    CatalogItem(
      name: 'Bread',
      imageAsset: AppAssets.bread,
      price: '₹35',
      unit: '/400g',
    ),
    CatalogItem(
      name: 'Fresh Vegetables',
      imageAsset: AppAssets.freshVegetables,
      price: '₹29',
      unit: '/kg',
    ),
  ];

  static const pharmacyCare = <CatalogItem>[
    CatalogItem(
      name: 'First Aid Kit',
      imageAsset: AppAssets.firstAidKit,
      price: '₹129',
      unit: '/pc',
    ),
    CatalogItem(
      name: 'Vitamins & Supplements',
      imageAsset: AppAssets.vitaminSupplements,
      price: '₹399',
      unit: '/pc',
    ),
    CatalogItem(
      name: 'Thermometer',
      imageAsset: AppAssets.thermometer,
      price: '₹249',
      unit: '/pc',
    ),
    CatalogItem(
      name: 'Skincare & Personal Care',
      imageAsset: AppAssets.skincarePersonalCare,
      price: '₹299',
      unit: '/pc',
    ),
  ];
}
