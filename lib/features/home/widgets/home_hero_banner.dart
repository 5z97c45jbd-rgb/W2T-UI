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
                      left: 14,
                      top: 6,
                      width: bannerWidth * 0.64,
                      child: _HeroHeadline(bannerWidth: bannerWidth),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 14,
                      right: 132,
                      child: _HeroCaption(bannerWidth: bannerWidth),
                    ),
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

class _HeroHeadline extends StatelessWidget {
  const _HeroHeadline({required this.bannerWidth});

  final double bannerWidth;

  @override
  Widget build(BuildContext context) {
    final localSize = (bannerWidth * 0.086).clamp(26.0, 38.0);
    final deliveredSize = (bannerWidth * 0.08).clamp(24.0, 36.0);
    return IgnorePointer(
      child: Transform.rotate(
        angle: -0.07,
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text('Local', style: _scriptStyle(localSize)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text('Favorites', style: _scriptStyle(localSize)),
            ),
            Text('Delivered to You', style: _scriptStyle(deliveredSize)),
            Transform.translate(
              offset: const Offset(4, -6),
              child: SizedBox(
                height: 16,
                width: (bannerWidth * 0.48).clamp(132.0, 196.0),
                child: const CustomPaint(painter: _SwooshPainter()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static TextStyle _scriptStyle(double fontSize) {
    return GoogleFonts.greatVibes(
      fontSize: fontSize,
      height: 0.88,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: AppColors.white,
      shadows: const [
        Shadow(
          color: Color(0x8A000000),
          blurRadius: 8,
          offset: Offset(0, 1.5),
        ),
      ],
    );
  }
}

class _HeroCaption extends StatelessWidget {
  const _HeroCaption({required this.bannerWidth});

  final double bannerWidth;

  @override
  Widget build(BuildContext context) {
    final size = (bannerWidth * 0.028).clamp(10.0, 12.5);
    final style = GoogleFonts.inter(
      fontSize: size,
      height: 1.25,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
      shadows: const [
        Shadow(
          color: Color(0x73000000),
          blurRadius: 6,
          offset: Offset(0, 1),
        ),
      ],
    );
    return IgnorePointer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Food • Grocery • Wellness • Essentials', style: style),
          Text('Everything You Need, Near You.', style: style),
        ],
      ),
    );
  }
}

class _SwooshPainter extends CustomPainter {
  const _SwooshPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5CE8F7)
      ..strokeWidth = 4.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(0, size.height * 0.72)
      ..cubicTo(
        size.width * 0.28,
        size.height * 1.25,
        size.width * 0.62,
        size.height * -0.15,
        size.width,
        size.height * 0.38,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FallbackHeroImage extends StatelessWidget {
  const _FallbackHeroImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.homeHero,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      filterQuality: FilterQuality.high,
    );
  }
}
