import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/widgets/w2t_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  static const _duration = Duration(seconds: 4);

  late final AnimationController _progress;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(vsync: this, duration: _duration)..forward();
    _progress.addStatusListener((status) {
      if (status != AnimationStatus.completed) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final signedIn = context.read<SessionBloc>().state.isSignedIn;
        context.go(signedIn ? AppRoutes.home : AppRoutes.welcome);
      });
    });
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FBFE),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.splash,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00F8FCFF),
                    Color(0xFFF8FCFF),
                    Color(0xFFF8FCFF),
                    Color(0x00F8FCFF),
                  ],
                  stops: [0.18, 0.32, 0.68, 0.84],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 5),
                  const W2tLogo(width: 240),
                  const SizedBox(height: 36),
                  AnimatedBuilder(
                    animation: _progress,
                    builder: (context, _) {
                      final t = Curves.easeInOutCubic.transform(_progress.value);
                      return Column(
                        children: [
                          SizedBox(
                            height: 22,
                            width: math.min(
                              280,
                              MediaQuery.sizeOf(context).width - 96,
                            ),
                            child: CustomPaint(
                              painter: _SplashBarPainter(progress: t),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${(t * 100).round()}%',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                              color: const Color(0xFF1E4E9A),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Spacer(flex: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashBarPainter extends CustomPainter {
  const _SplashBarPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final cover = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(cover, Paint()..color = const Color(0xFFF7FBFE));

    final trackRect = Rect.fromLTWH(
      size.width * (22 / 852),
      size.height * (16 / 74),
      size.width * (808 / 852),
      size.height * (42 / 74),
    );
    final track = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackRect.height / 2),
    );

    canvas.drawRRect(
      track,
      Paint()
        ..color = const Color(0xFFD5DEEA)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.4),
    );
    canvas.drawRRect(track, Paint()..color = const Color(0xFFE6EDF5));

    final clamped = progress.clamp(0.0, 1.0);
    final fillWidth = math.max(trackRect.height, trackRect.width * clamped);
    final fillRect = Rect.fromLTWH(
      trackRect.left,
      trackRect.top,
      fillWidth.clamp(0, trackRect.width),
      trackRect.height,
    );

    canvas.save();
    canvas.clipRRect(track);

    final glow = RRect.fromRectAndRadius(
      fillRect.inflate(1.5),
      Radius.circular(trackRect.height / 2),
    );
    canvas.drawRRect(
      glow,
      Paint()
        ..color = const Color(0x662B8CFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(fillRect, Radius.circular(trackRect.height / 2)),
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFF7AF4FF),
            Color(0xFF3CB6FF),
            Color(0xFF156BFF),
          ],
          stops: [0, 0.45, 1],
        ).createShader(fillRect),
    );

    final gloss = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        fillRect.left + 2,
        fillRect.top + 1.5,
        math.max(0, fillRect.width - 4),
        fillRect.height * 0.42,
      ),
      Radius.circular(trackRect.height),
    );
    canvas.drawRRect(gloss, Paint()..color = const Color(0x55FFFFFF));

    final sweep = ((clamped * 1.65) % 1.0) * fillRect.width;
    final shineRect = Rect.fromLTWH(
      fillRect.left + sweep - 22,
      fillRect.top,
      36,
      fillRect.height,
    );
    canvas.drawRect(
      shineRect,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0x00FFFFFF),
            Color(0xB3FFFFFF),
            Color(0x00FFFFFF),
          ],
        ).createShader(shineRect),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SplashBarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
