import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/features/home/data/models/catalog_item.dart';
import 'package:w2t_mobile/features/home/data/models/restaurant_item.dart';

abstract final class HomeContent {
  static const featuredRestaurants = <RestaurantItem>[
    RestaurantItem(
      name: 'Paradise Biryani',
      imageAsset: AppAssets.paradiseBiryani,
      rating: 4.5,
      reviewCount: 120,
      deliveryTime: '25–35 mins',
    ),
    RestaurantItem(
      name: 'The Food Court',
      imageAsset: AppAssets.foodCourt,
      rating: 4.0,
      reviewCount: 98,
      deliveryTime: '30–40 mins',
    ),
    RestaurantItem(
      name: 'Urban Bites',
      imageAsset: AppAssets.urbanBites,
      rating: 4.2,
      reviewCount: 76,
      deliveryTime: '20–30 mins',
    ),
    RestaurantItem(
      name: 'Green Bowl',
      imageAsset: AppAssets.greenBowl,
      rating: 4.6,
      reviewCount: 143,
      deliveryTime: '15–25 mins',
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
