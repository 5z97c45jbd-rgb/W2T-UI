import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/home/bloc/home_tab/home_tab_cubit.dart';
import 'package:w2t_mobile/features/home/data/explore_content.dart';
import 'package:w2t_mobile/features/home/data/home_content.dart';
import 'package:w2t_mobile/features/home/data/models/category_item.dart';
import 'package:w2t_mobile/features/home/data/models/explore_reels_extra.dart';
import 'package:w2t_mobile/features/home/data/models/explore_video.dart';
import 'package:w2t_mobile/features/home/widgets/explore_header.dart';
import 'package:w2t_mobile/features/home/widgets/explore_video_cards.dart';
import 'package:w2t_mobile/features/home/widgets/home_bottom_nav_bar.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late String _selectedCategory;
  String _selectedTopic = ExploreContent.topics.first;

  @override
  void initState() {
    super.initState();
    _selectedCategory = ExploreContent.defaultCategory();
  }

  @override
  Widget build(BuildContext context) {
    final videos = ExploreContent.videosFor(_selectedCategory);
    final featured = videos.isNotEmpty ? videos.first : null;
    final sideVideos = videos.skip(1).take(3).toList();
    final popular = videos.length > 1 ? videos.skip(1).toList() : videos;
    final bottomPadding = HomeLayout.scrollBottomPadding(context);

    void openReels(ExploreVideo video) {
      final router = GoRouter.maybeOf(context);
      if (router == null) return;
      final index = videos.indexOf(video);
      router.push(
        AppRoutes.exploreReels,
        extra: ExploreReelsExtra(
          videos: videos,
          initialIndex: index < 0 ? 0 : index,
        ),
      );
    }

    void openOrders() {
      HomeTabCubit.maybeOf(context)?.select(HomeTab.order);
    }

    return ColoredBox(
      color: AppColors.homeBackground,
      child: CustomScrollView(
        slivers: [
          const SliverSafeArea(
            minimum: EdgeInsets.only(top: 8),
            bottom: false,
            sliver: SliverToBoxAdapter(child: ExploreHeader()),
          ),
          SliverToBoxAdapter(
            child: _CategoryStrip(
              selectedCategory: _selectedCategory,
              onSelected: (label) => setState(() => _selectedCategory = label),
            ),
          ),
          SliverToBoxAdapter(
            child: _TopicTabs(
              selectedTopic: _selectedTopic,
              onSelected: (topic) => setState(() => _selectedTopic = topic),
            ),
          ),
          if (featured != null)
            SliverToBoxAdapter(
              child: _FeaturedRow(
                featured: featured,
                sideVideos: sideVideos,
                onPlay: openReels,
                onOpenOrder: openOrders,
              ),
            ),
          SliverToBoxAdapter(
            child: _PopularHeader(onSeeAll: () {}),
          ),
          SliverToBoxAdapter(
            child: _PopularRow(
              videos: popular,
              onPlay: openReels,
              onOpenOrder: openOrders,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
        ],
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({
    required this.selectedCategory,
    required this.onSelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const categories = HomeContent.categories;
    return SizedBox(
      height: 96,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          HomeLayout.horizontalPadding,
          16,
          HomeLayout.horizontalPadding,
          0,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = categories[index];
          return _CategoryChip(
            item: item,
            selected: item.label == selectedCategory,
            onTap: () => onSelected(item.label),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final CategoryItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : item.background,
                shape: BoxShape.circle,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ClipOval(
                child: item.imageAsset != null
                    ? ColorFiltered(
                        colorFilter: selected
                            ? const ColorFilter.mode(
                                Colors.white70,
                                BlendMode.srcATop,
                              )
                            : const ColorFilter.mode(
                                Colors.transparent,
                                BlendMode.dst,
                              ),
                        child: Image.asset(
                          item.imageAsset!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Text(
                          item.emoji ?? '',
                          style: TextStyle(
                            fontSize: 22,
                            height: 1,
                            color: selected ? AppColors.white : null,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.primary : AppColors.textSecondary,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicTabs extends StatelessWidget {
  const _TopicTabs({
    required this.selectedTopic,
    required this.onSelected,
  });

  final String selectedTopic;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          HomeLayout.horizontalPadding,
          8,
          HomeLayout.horizontalPadding,
          0,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: ExploreContent.topics.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final topic = ExploreContent.topics[index];
          final selected = topic == selectedTopic;
          return GestureDetector(
            onTap: () => onSelected(topic),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                topic,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedRow extends StatelessWidget {
  const _FeaturedRow({
    required this.featured,
    required this.sideVideos,
    required this.onPlay,
    required this.onOpenOrder,
  });

  final ExploreVideo featured;
  final List<ExploreVideo> sideVideos;
  final ValueChanged<ExploreVideo> onPlay;
  final VoidCallback onOpenOrder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HomeLayout.horizontalPadding,
        14,
        HomeLayout.horizontalPadding,
        4,
      ),
      child: SizedBox(
        height: 268,
        child: Row(
          children: [
            Expanded(
              flex: 58,
              child: ExploreFeaturedVideoCard(
                video: featured,
                onPlay: () => onPlay(featured),
                onOpenOrder: onOpenOrder,
              ),
            ),
            if (sideVideos.isNotEmpty) ...[
              const SizedBox(width: 10),
              Expanded(
                flex: 42,
                child: Column(
                  children: [
                    for (var i = 0; i < sideVideos.length; i++) ...[
                      if (i > 0) const SizedBox(height: 8),
                      Expanded(
                        child: ExploreSideVideoCard(
                          video: sideVideos[i],
                          onPlay: () => onPlay(sideVideos[i]),
                          onOpenOrder: onOpenOrder,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PopularHeader extends StatelessWidget {
  const _PopularHeader({required this.onSeeAll});

  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HomeLayout.horizontalPadding,
        18,
        HomeLayout.horizontalPadding,
        10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Popular Videos Near You',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'See All',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularRow extends StatelessWidget {
  const _PopularRow({
    required this.videos,
    required this.onPlay,
    required this.onOpenOrder,
  });

  final List<ExploreVideo> videos;
  final ValueChanged<ExploreVideo> onPlay;
  final VoidCallback onOpenOrder;

  @override
  Widget build(BuildContext context) {
    final width = HomeLayout.cardWidth(context) + 8;
    return SizedBox(
      height: width * 0.72 + 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: HomeLayout.horizontalPadding,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return ExplorePopularVideoCard(
            video: videos[index],
            width: width,
            onPlay: () => onPlay(videos[index]),
            onOpenOrder: onOpenOrder,
          );
        },
      ),
    );
  }
}
