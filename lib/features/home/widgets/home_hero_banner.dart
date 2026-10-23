import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/bloc/city_image/city_image_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/city_image/city_image_state.dart';
import 'package:w2t_mobile/features/home/widgets/home_layout.dart';

class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HomeLayout.horizontalPadding,
        12,
        HomeLayout.horizontalPadding,
        0,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bannerWidth = constraints.maxWidth;
          final bannerHeight = (bannerWidth * 0.5).clamp(162.0, 200.0);

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: bannerWidth,
              height: bannerHeight,
              child: ColoredBox(
                color: const Color(0xFFE6F3F7),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const _HeroImage(),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Material(
                        color: AppColors.orderNow,
                        borderRadius: BorderRadius.circular(24),
                        elevation: 2,
                        shadowColor: Colors.black26,
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Order Now',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityImageBloc, CityImageState>(
      builder: (context, state) {
        if (state.status == CityImageStatus.loading) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
          );
        }

        if (state.hasImage) {
          return Image.network(
            state.imageUrl!,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => const _FallbackHeroImage(),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
              );
            },
          );
        }

        return const _FallbackHeroImage();
      },
    );
  }
}

class _FallbackHeroImage extends StatelessWidget {
  const _FallbackHeroImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.homeHero,
      fit: BoxFit.contain,
      alignment: Alignment.topCenter,
      filterQuality: FilterQuality.high,
    );
  }
}
