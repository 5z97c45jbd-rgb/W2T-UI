import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/auth/widgets/w2t_logo.dart';

class AiAppBar extends StatelessWidget {
  const AiAppBar({
    super.key,
    this.onBack,
    this.onHistory,
  });

  final VoidCallback? onBack;
  final VoidCallback? onHistory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 18, 8, 10),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: onBack == null
                ? null
                : IconButton(
                    onPressed: onBack,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      size: 28,
                      color: AppColors.textPrimary,
                    ),
                  ),
          ),
          const Expanded(
            child: Center(
              child: W2tLogo(width: 92),
            ),
          ),
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: onHistory ?? () {},
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.schedule_outlined,
                size: 22,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
