import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/models/explore_video.dart';
import 'package:w2t_mobile/features/home/widgets/home_catalog_image.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class ExploreFeaturedVideoCard extends StatelessWidget {
  const ExploreFeaturedVideoCard({super.key, required this.video});

  final ExploreVideo video;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
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
                  Color(0x33000000),
                  Color(0x00000000),
                  Color(0xCC000000),
                ],
                stops: [0, 0.42, 1],
              ),
            ),
          ),
          if (video.trending)
            const Positioned(
              top: 12,
              left: 12,
              child: _TrendingBadge(),
            ),
          Positioned(
            top: 12,
            right: 12,
            child: _DurationChip(duration: video.duration),
          ),
          const Center(child: _PlayButton(size: 54)),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _CreatorAvatar(label: video.creator),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              video.creator,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          if (video.verified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: Color(0xFF4DA3FF),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    height: 1.25,
                  ),
                ),
                if (video.hashtags.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    video.hashtags.join('  '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFBFD4FF),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      size: 14,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      video.likesLabel,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _VideoCostChip(costLabel: video.costLabel),
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

class ExploreSideVideoCard extends StatelessWidget {
  const ExploreSideVideoCard({super.key, required this.video});

  final ExploreVideo video;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          HomeFillImage(fallbackAsset: video.imageAsset),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0xAA000000)],
              ),
            ),
          ),
          const Positioned(
            top: 8,
            right: 8,
            child: _HeartButton(),
          ),
          const Center(child: _PlayButton(size: 32)),
          Positioned(
            right: 8,
            bottom: 36,
            child: _DurationChip(duration: video.duration),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        video.creator,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    Text(
                      video.costLabel,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFD56A),
                      ),
                    ),
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

class ExplorePopularVideoCard extends StatelessWidget {
  const ExplorePopularVideoCard({
    super.key,
    required this.video,
    required this.width,
  });

  final ExploreVideo video;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: width * 0.72,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(HomeLayout.imageRadius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  HomeFillImage(fallbackAsset: video.imageAsset),
                  const Center(child: _PlayButton(size: 34)),
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: _HeartButton(),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: _DurationChip(duration: video.duration),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: _VideoCostChip(costLabel: video.costLabel),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            video.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _MiniBrand(label: video.creator),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  video.creator,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VideoCostChip extends StatelessWidget {
  const _VideoCostChip({required this.costLabel});

  final String costLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.payments_outlined,
            size: 12,
            color: Color(0xFFFFD56A),
          ),
          const SizedBox(width: 4),
          Text(
            costLabel,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        size: size * 0.62,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        duration,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _TrendingBadge extends StatelessWidget {
  const _TrendingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 11, height: 1)),
          const SizedBox(width: 4),
          Text(
            'Trending',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  const _HeartButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.favorite_border_rounded,
        size: 14,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _CreatorAvatar extends StatelessWidget {
  const _CreatorAvatar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: AppColors.orderNow,
      child: Text(
        label.isEmpty ? '?' : label.substring(0, 1),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _MiniBrand extends StatelessWidget {
  const _MiniBrand({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 8,
      backgroundColor: AppColors.homeChip,
      child: Text(
        label.isEmpty ? '?' : label.substring(0, 1),
        style: GoogleFonts.inter(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
