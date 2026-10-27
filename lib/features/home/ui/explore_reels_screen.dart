import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/bloc/home_tab/home_tab_cubit.dart';
import 'package:w2t_mobile/features/home/data/explore_content.dart';
import 'package:w2t_mobile/features/home/data/models/explore_reels_extra.dart';
import 'package:w2t_mobile/features/home/data/models/explore_video.dart';
import 'package:w2t_mobile/features/home/widgets/home_bottom_nav_bar.dart';
import 'package:w2t_mobile/features/home/widgets/home_catalog_image.dart';

class ExploreReelsScreen extends StatefulWidget {
  const ExploreReelsScreen({
    super.key,
    this.extra,
  });

  final ExploreReelsExtra? extra;

  @override
  State<ExploreReelsScreen> createState() => _ExploreReelsScreenState();
}

class _ExploreReelsScreenState extends State<ExploreReelsScreen> {
  late final List<ExploreVideo> _videos;
  late final PageController _pageController;
  late int _index;

  @override
  void initState() {
    super.initState();
    final extra = widget.extra;
    _videos = extra?.videos.isNotEmpty == true
        ? extra!.videos
        : ExploreContent.videos;
    final maxIndex = _videos.isEmpty ? 0 : _videos.length - 1;
    _index = (extra?.initialIndex ?? 0).clamp(0, maxIndex);
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openOrders() {
    HomeTabCubit.maybeOf(context)?.select(HomeTab.order);
    if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _videos.isEmpty
            ? const Center(
                child: Text(
                  'No videos',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) => setState(() => _index = index),
                itemCount: _videos.length,
                itemBuilder: (context, index) {
                  return _ReelPage(
                    video: _videos[index],
                    onClose: () => context.pop(),
                    onOpenOrder: _openOrders,
                  );
                },
              ),
      ),
    );
  }
}

class _ReelPage extends StatefulWidget {
  const _ReelPage({
    required this.video,
    required this.onClose,
    required this.onOpenOrder,
  });

  final ExploreVideo video;
  final VoidCallback onClose;
  final VoidCallback onOpenOrder;

  @override
  State<_ReelPage> createState() => _ReelPageState();
}

class _ReelPageState extends State<_ReelPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;
  bool _playing = true;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: _parseDuration(widget.video.duration),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          _progress.forward(from: 0);
        }
      });
    _progress.forward();
  }

  @override
  void didUpdateWidget(covariant _ReelPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video != widget.video) {
      _progress
        ..duration = _parseDuration(widget.video.duration)
        ..forward(from: 0);
      _playing = true;
      _liked = false;
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  Duration _parseDuration(String label) {
    final parts = label.split(':');
    if (parts.length != 2) return const Duration(seconds: 8);
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 8;
    final total = minutes * 60 + seconds;
    return Duration(seconds: total.clamp(4, 30));
  }

  void _togglePlay() {
    setState(() {
      _playing = !_playing;
      if (_playing) {
        _progress.forward();
      } else {
        _progress.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final padding = MediaQuery.paddingOf(context);

    return GestureDetector(
      onTap: _togglePlay,
      child: Stack(
        fit: StackFit.expand,
        children: [
          HomeFillImage(fallbackAsset: video.imageAsset),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0x00000000),
                  Color(0xCC000000),
                ],
                stops: [0, 0.35, 1],
              ),
            ),
          ),
          if (!_playing)
            const Center(
              child: Icon(
                Icons.play_arrow_rounded,
                size: 84,
                color: Colors.white,
              ),
            ),
          Positioned(
            top: padding.top + 8,
            left: 12,
            right: 12,
            child: AnimatedBuilder(
              animation: _progress,
              builder: (context, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: _progress.value,
                    minHeight: 3,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: padding.top + 18,
            left: 8,
            child: IconButton(
              onPressed: widget.onClose,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              color: AppColors.white,
            ),
          ),
          Positioned(
            right: 12,
            bottom: padding.bottom + 28,
            child: Column(
              children: [
                _ActionButton(
                  icon: _liked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  label: video.likesLabel,
                  color: _liked ? const Color(0xFFFF4D6D) : AppColors.white,
                  onTap: () => setState(() => _liked = !_liked),
                ),
                const SizedBox(height: 18),
                const _ActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Reply',
                ),
                const SizedBox(height: 18),
                const _ActionButton(
                  icon: Icons.send_rounded,
                  label: 'Share',
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 72,
            bottom: padding.bottom + 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.orderNow,
                      child: Text(
                        video.creator.isEmpty
                            ? '?'
                            : video.creator.substring(0, 1),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        video.creator,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    if (video.verified) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: Color(0xFF4DA3FF),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  video.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
                if (video.hashtags.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    video.hashtags.join('  '),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFBFD4FF),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    _CostChip(costLabel: video.costLabel),
                    const SizedBox(width: 8),
                    _OrderArrowButton(onTap: widget.onOpenOrder),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CostChip extends StatelessWidget {
  const _CostChip({required this.costLabel});

  final String costLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.payments_outlined,
            size: 14,
            color: Color(0xFFFFD56A),
          ),
          const SizedBox(width: 4),
          Text(
            costLabel,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderArrowButton extends StatelessWidget {
  const _OrderArrowButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'View order',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            size: 18,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.color = AppColors.white,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
