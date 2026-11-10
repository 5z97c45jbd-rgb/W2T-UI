import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void goBackOr(BuildContext context, String fallback) {
  final router = GoRouter.maybeOf(context);
  if (router != null && router.canPop()) {
    try {
      router.pop();
      return;
    } catch (_) {}
  }
  if (context.mounted) context.go(fallback);
}
