import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/auth/widgets/w2t_logo.dart';

class KycHeader extends StatelessWidget {
  const KycHeader({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
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
                      size: 30,
                      color: AppColors.titleNavy,
                    ),
                  ),
          ),
          const Expanded(
            child: Center(
              child: W2tLogo(width: 96),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}
