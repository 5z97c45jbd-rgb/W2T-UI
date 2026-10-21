import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/home_content.dart';
import 'package:w2t_mobile/features/home/widgets/catalog_product_card.dart';
import 'package:w2t_mobile/features/home/widgets/featured_restaurant_card.dart';
import 'package:w2t_mobile/features/home/widgets/home_categories_grid.dart';
import 'package:w2t_mobile/features/home/widgets/home_header.dart';
import 'package:w2t_mobile/features/home/widgets/home_hero_banner.dart';
import 'package:w2t_mobile/features/home/widgets/home_horizontal_carousel.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';
import 'package:w2t_mobile/features/home/widgets/home_section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidth = HomeLayout.cardWidth(context);
    final restaurantCarouselHeight =
        HomeLayout.restaurantCarouselHeight(cardWidth);
    final catalogCarouselHeight = HomeLayout.catalogCarouselHeight(cardWidth);
    final bottomPadding = HomeLayout.scrollBottomPadding(context);

    return ColoredBox(
      color: AppColors.homeBackground,
      child: CustomScrollView(
        slivers: [
          SliverSafeArea(
            minimum: const EdgeInsets.only(top: 8),
            bottom: false,
            sliver: const SliverToBoxAdapter(child: HomeHeader()),
          ),
          const SliverToBoxAdapter(child: HomeHeroBanner()),
          const SliverToBoxAdapter(child: HomeCategoriesGrid()),
          SliverToBoxAdapter(
            child: HomeSectionHeader(
              icon: Icons.restaurant_rounded,
              title: 'Featured Restaurants',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: HomeHorizontalCarousel(
              height: restaurantCarouselHeight,
              itemCount: HomeContent.featuredRestaurants.length,
              itemBuilder: (context, index) {
                return FeaturedRestaurantCard(
                  cardWidth: cardWidth,
                  item: HomeContent.featuredRestaurants[index],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: HomeSectionHeader(
              icon: Icons.shopping_cart_outlined,
              title: 'Grocery Essentials',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: HomeHorizontalCarousel(
              height: catalogCarouselHeight,
              itemCount: HomeContent.groceryEssentials.length,
              itemBuilder: (context, index) {
                return CatalogProductCard(
                  cardWidth: cardWidth,
                  item: HomeContent.groceryEssentials[index],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: HomeSectionHeader(
              icon: Icons.medical_services_outlined,
              title: 'Pharmacy Care',
              onSeeAll: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: HomeHorizontalCarousel(
              height: catalogCarouselHeight,
              itemCount: HomeContent.pharmacyCare.length,
              itemBuilder: (context, index) {
                return CatalogProductCard(
                  cardWidth: cardWidth,
                  item: HomeContent.pharmacyCare[index],
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
        ],
      ),
    );
  }
}
