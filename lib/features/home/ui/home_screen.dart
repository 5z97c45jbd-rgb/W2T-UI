import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/home/bloc/home_merchants/home_merchants_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/home_merchants/home_merchants_event.dart';
import 'package:w2t_mobile/features/home/bloc/home_merchants/home_merchants_state.dart';
import 'package:w2t_mobile/features/home/data/models/merchant.dart';
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
    final carouselHeight = HomeLayout.restaurantCarouselHeight(cardWidth);
    final bottomPadding = HomeLayout.scrollBottomPadding(context);

    return ColoredBox(
      color: AppColors.homeBackground,
      child: BlocBuilder<HomeMerchantsBloc, HomeMerchantsState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              const SliverSafeArea(
                minimum: EdgeInsets.only(top: 8),
                bottom: false,
                sliver: SliverToBoxAdapter(child: HomeHeader()),
              ),
              const SliverToBoxAdapter(child: HomeHeroBanner()),
              const SliverToBoxAdapter(child: HomeCategoriesGrid()),
              ..._merchantSection(
                context: context,
                category: MerchantCategory.food,
                merchants: state.merchants.restaurants,
                status: state.status,
                errorMessage: state.errorMessage,
                cardWidth: cardWidth,
                carouselHeight: carouselHeight,
              ),
              ..._merchantSection(
                context: context,
                category: MerchantCategory.groceries,
                merchants: state.merchants.groceries,
                status: state.status,
                errorMessage: state.errorMessage,
                cardWidth: cardWidth,
                carouselHeight: carouselHeight,
              ),
              ..._merchantSection(
                context: context,
                category: MerchantCategory.individuals,
                merchants: state.merchants.individuals,
                status: state.status,
                errorMessage: state.errorMessage,
                cardWidth: cardWidth,
                carouselHeight: carouselHeight,
              ),
              SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _merchantSection({
    required BuildContext context,
    required MerchantCategory category,
    required List<Merchant> merchants,
    required HomeMerchantsStatus status,
    required String? errorMessage,
    required double cardWidth,
    required double carouselHeight,
  }) {
    return [
      SliverToBoxAdapter(
        child: HomeSectionHeader(
          icon: category.icon,
          title: category.title,
          onSeeAll: () => context.push(AppRoutes.merchants(category)),
        ),
      ),
      SliverToBoxAdapter(
        child: _MerchantCarousel(
          category: category,
          merchants: merchants,
          status: status,
          errorMessage: errorMessage,
          cardWidth: cardWidth,
          height: carouselHeight,
        ),
      ),
    ];
  }
}

class _MerchantCarousel extends StatelessWidget {
  const _MerchantCarousel({
    required this.category,
    required this.merchants,
    required this.status,
    required this.errorMessage,
    required this.cardWidth,
    required this.height,
  });

  final MerchantCategory category;
  final List<Merchant> merchants;
  final HomeMerchantsStatus status;
  final String? errorMessage;
  final double cardWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (status == HomeMerchantsStatus.loading) {
      return SizedBox(
        height: height,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          ),
        ),
      );
    }

    if (status == HomeMerchantsStatus.failure) {
      return SizedBox(
        height: height,
        child: Center(
          child: TextButton(
            onPressed: () => context
                .read<HomeMerchantsBloc>()
                .add(const HomeMerchantsRequested()),
            child: Text(
              errorMessage ?? 'Tap to retry',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      );
    }

    if (merchants.isEmpty) {
      return SizedBox(
        height: 72,
        child: Center(
          child: Text(
            category.emptyLabel,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return HomeHorizontalCarousel(
      height: height,
      itemCount: merchants.length,
      itemBuilder: (context, index) {
        return FeaturedRestaurantCard(
          cardWidth: cardWidth,
          item: merchants[index].toRestaurantItem(),
        );
      },
    );
  }
}
