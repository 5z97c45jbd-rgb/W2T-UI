import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/home_content.dart';
import 'package:w2t_mobile/features/home/data/models/restaurant_item.dart';
import 'package:w2t_mobile/features/home/widgets/featured_restaurant_list_card.dart';
import 'package:w2t_mobile/features/home/widgets/restaurant_logo.dart';

enum _RestaurantSort { relevance, rating, delivery, cost, distance }

class FeaturedRestaurantsScreen extends StatefulWidget {
  const FeaturedRestaurantsScreen({super.key});

  @override
  State<FeaturedRestaurantsScreen> createState() =>
      _FeaturedRestaurantsScreenState();
}

class _FeaturedRestaurantsScreenState extends State<FeaturedRestaurantsScreen> {
  final _searchController = TextEditingController();
  final _favorites = <String>{};

  String _cuisine = 'All';
  _RestaurantSort _sort = _RestaurantSort.relevance;
  bool _topRated = true;
  bool _fastestDelivery = false;
  bool _offersOnly = false;
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RestaurantItem> get _filtered {
    final query = _searchController.text.trim().toLowerCase();
    var items = HomeContent.featuredRestaurants.where((item) {
      final matchesCuisine =
          _cuisine == 'All' || item.cuisines.contains(_cuisine);
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.cuisines.any((cuisine) => cuisine.toLowerCase().contains(query));
      final matchesOffer = !_offersOnly || item.offerLabel != null;
      return matchesCuisine && matchesQuery && matchesOffer;
    }).toList();

    items.sort((a, b) {
      switch (_sort) {
        case _RestaurantSort.rating:
          final rating = b.rating.compareTo(a.rating);
          return rating != 0 ? rating : b.reviewCount.compareTo(a.reviewCount);
        case _RestaurantSort.delivery:
          return a.minDeliveryMinutes.compareTo(b.minDeliveryMinutes);
        case _RestaurantSort.cost:
          return a.priceForTwo.compareTo(b.priceForTwo);
        case _RestaurantSort.distance:
          return a.distanceKm.compareTo(b.distanceKm);
        case _RestaurantSort.relevance:
          return 0;
      }
    });
    return items;
  }

  void _selectSort(_RestaurantSort sort) {
    setState(() {
      _sort = sort;
      _topRated = sort == _RestaurantSort.rating;
      _fastestDelivery = sort == _RestaurantSort.delivery;
    });
  }

  Future<void> _openSortSheet() async {
    final selected = await showModalBottomSheet<_RestaurantSort>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sort by',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              for (final option in _RestaurantSort.values)
                ListTile(
                  title: Text(
                    _sortLabel(option),
                    style: GoogleFonts.inter(
                      fontWeight: option == _sort
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  trailing: option == _sort
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
                      : null,
                  onTap: () => Navigator.pop(context, option),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (selected != null) _selectSort(selected);
  }

  Future<void> _openFiltersSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Filters',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use cuisine, Top Rated, Fastest Delivery, and Offers above to refine results.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _sortLabel(_RestaurantSort sort) {
    switch (sort) {
      case _RestaurantSort.relevance:
        return 'Relevance';
      case _RestaurantSort.rating:
        return 'Rating: High to Low';
      case _RestaurantSort.delivery:
        return 'Fastest Delivery';
      case _RestaurantSort.cost:
        return 'Cost: Low to High';
      case _RestaurantSort.distance:
        return 'Distance';
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = _filtered;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: () => Navigator.of(context).maybePop()),
            const SizedBox(height: 12),
            _SearchField(controller: _searchController),
            const SizedBox(height: 12),
            _CuisineRow(
              selected: _cuisine,
              onSelected: (value) => setState(() => _cuisine = value),
            ),
            const SizedBox(height: 10),
            _FilterRow(
              sortLabel: _sort == _RestaurantSort.relevance
                  ? 'Sort by'
                  : _sortLabel(_sort),
              topRated: _topRated,
              fastestDelivery: _fastestDelivery,
              offersOnly: _offersOnly,
              onSort: _openSortSheet,
              onTopRated: () {
                _selectSort(
                  _topRated ? _RestaurantSort.relevance : _RestaurantSort.rating,
                );
              },
              onFastest: () {
                _selectSort(
                  _fastestDelivery
                      ? _RestaurantSort.relevance
                      : _RestaurantSort.delivery,
                );
              },
              onOffers: () => setState(() => _offersOnly = !_offersOnly),
              onFilters: _openFiltersSheet,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${restaurants.length} restaurants found',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  _ViewToggle(
                    showMap: _showMap,
                    onChanged: (value) => setState(() => _showMap = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: restaurants.isEmpty
                  ? Center(
                      child: Text(
                        'No restaurants match your filters',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : _showMap
                      ? _RestaurantMapView(items: restaurants)
                      : _RestaurantGrid(
                          items: restaurants,
                          favorites: _favorites,
                          onFavoriteTap: (name) {
                            setState(() {
                              if (!_favorites.add(name)) {
                                _favorites.remove(name);
                              }
                            });
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.titleNavy,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Restaurants',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.titleNavy,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Discover top restaurants near you',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6E8EC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                style: GoogleFonts.inter(fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Search restaurants, cuisines, or dishes...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.tune_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CuisineRow extends StatelessWidget {
  const _CuisineRow({
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: HomeContent.cuisineFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = HomeContent.cuisineFilters[index];
          final isSelected = label == selected;
          return GestureDetector(
            onTap: () => onSelected(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFFE6E8EC),
                ),
              ),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.titleNavy,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.sortLabel,
    required this.topRated,
    required this.fastestDelivery,
    required this.offersOnly,
    required this.onSort,
    required this.onTopRated,
    required this.onFastest,
    required this.onOffers,
    required this.onFilters,
  });

  final String sortLabel;
  final bool topRated;
  final bool fastestDelivery;
  final bool offersOnly;
  final VoidCallback onSort;
  final VoidCallback onTopRated;
  final VoidCallback onFastest;
  final VoidCallback onOffers;
  final VoidCallback onFilters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: sortLabel,
            icon: Icons.swap_vert_rounded,
            trailing: Icons.keyboard_arrow_down_rounded,
            selected: false,
            onTap: onSort,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Top Rated',
            icon: Icons.verified_rounded,
            selected: topRated,
            onTap: onTopRated,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Fastest Delivery',
            icon: Icons.access_time_rounded,
            selected: fastestDelivery,
            onTap: onFastest,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Offers',
            icon: Icons.local_offer_outlined,
            selected: offersOnly,
            onTap: onOffers,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Filters',
            icon: Icons.tune_rounded,
            selected: false,
            onTap: onFilters,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    this.trailing,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData? trailing;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.titleNavy;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F6F8) : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary.withValues(alpha: 0.35) : const Color(0xFFE6E8EC),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 2),
              Icon(trailing, size: 16, color: color),
            ],
          ],
        ),
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({
    required this.showMap,
    required this.onChanged,
  });

  final bool showMap;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ToggleButton(
          label: 'List',
          icon: Icons.view_list_rounded,
          selected: !showMap,
          onTap: () => onChanged(false),
        ),
        const SizedBox(width: 8),
        _ToggleButton(
          label: 'Map',
          icon: Icons.map_outlined,
          selected: showMap,
          onTap: () => onChanged(true),
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE6E8EC),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: selected ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantGrid extends StatelessWidget {
  const _RestaurantGrid({
    required this.items,
    required this.favorites,
    required this.onFavoriteTap,
  });

  final List<RestaurantItem> items;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final rowCount = (items.length / 2).ceil();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: rowCount,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, row) {
        final left = items[row * 2];
        final hasRight = row * 2 + 1 < items.length;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: FeaturedRestaurantListCard(
                  item: left,
                  isFavorite: favorites.contains(left.name),
                  onFavoriteTap: () => onFavoriteTap(left.name),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: hasRight
                    ? FeaturedRestaurantListCard(
                        item: items[row * 2 + 1],
                        isFavorite: favorites.contains(items[row * 2 + 1].name),
                        onFavoriteTap: () =>
                            onFavoriteTap(items[row * 2 + 1].name),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RestaurantMapView extends StatelessWidget {
  const _RestaurantMapView({required this.items});

  final List<RestaurantItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            const ColoredBox(
              color: Color(0xFFE8F0E9),
              child: SizedBox.expand(),
            ),
            CustomPaint(painter: _MapGridPainter(), size: Size.infinite),
            ...List.generate(items.length, (index) {
              final item = items[index];
              final left = 24.0 + (index % 3) * 108.0;
              final top = 36.0 + (index ~/ 3) * 150.0 + (index.isOdd ? 28 : 0);
              return Positioned(
                left: left,
                top: top,
                child: Column(
                  children: [
                    RestaurantLogo(brand: item.brand, size: 36),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        item.name,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD5E2D4)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
