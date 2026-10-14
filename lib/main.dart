import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/core/theme/app_theme.dart';

void main() {
  runApp(const W2tApp());
}

class W2tApp extends StatelessWidget {
  const W2tApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'W2T',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
