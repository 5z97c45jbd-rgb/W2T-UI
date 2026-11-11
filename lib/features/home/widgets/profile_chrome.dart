import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/ui/picked_image.dart';
import 'package:w2t_mobile/features/auth/widgets/w2t_logo.dart';

abstract final class ProfilePalette {
  static const Color page = Color(0xFFF5F8FB);
  static const Color navy = Color(0xFF1A2744);
  static const Color iconBlue = Color(0xFF2BA4D4);
  static const Color verified = Color(0xFF22A45A);
  static const Color cardBorder = Color(0xFFE9EEF3);
  static const Color muted = Color(0xFF97A0AB);
  static const Color label = Color(0xFF6A7380);
  static const Color value = Color(0xFF3D4654);
  static const Color fieldFill = Color(0xFFF3F5F8);
  static const Color chevron = Color(0xFFC5CDD6);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF122033).withValues(alpha: 0.05),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
}

abstract final class ProfileFormat {
  static const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String date(DateTime? value) {
    if (value == null) return '—';
    return '${value.day} ${months[value.month - 1]} ${value.year}';
  }

  static String phone(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return '—';
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final local = digits.length > 10 ? digits.substring(digits.length - 10) : digits;
    if (local.length != 10) return raw.startsWith('+') ? raw : '+91 $raw';
    return '+91 ${local.substring(0, 5)} ${local.substring(5)}';
  }

  static String localPhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 10) return digits.substring(digits.length - 10);
    return digits;
  }

  static String location(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return 'Hanamkonda, Warangal';
    return text;
  }

  static String gender(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return 'Male';
    return text;
  }

  static String color(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return '—';
    return text;
  }
}

class ProfileBrandHeader extends StatelessWidget {
  const ProfileBrandHeader({
    super.key,
    this.onBack,
    this.trailing,
  });

  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: IconButton(
                tooltip: 'Back',
                onPressed: onBack ?? () => Navigator.maybePop(context),
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 30,
                  color: ProfilePalette.navy,
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
              child: trailing == null
                  ? null
                  : Align(
                      alignment: Alignment.centerRight,
                      child: trailing!,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.path,
    this.size = 92,
    this.onCameraTap,
  });

  final String? path;
  final double size;
  final VoidCallback? onCameraTap;

  @override
  Widget build(BuildContext context) {
    final image = pickedImageProvider(path);
    final hasFile = image != null;

    return SizedBox(
      width: size + 8,
      height: size + 8,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.homeChip,
                  border: Border.all(color: Colors.white, width: 3.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2B9FD4).withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  image: hasFile
                      ? DecorationImage(
                          image: image!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: hasFile
                    ? null
                    : Icon(
                        Icons.person_rounded,
                        size: size * 0.48,
                        color: AppColors.primary,
                      ),
              ),
            ),
          ),
          if (onCameraTap != null)
            Positioned(
              right: 0,
              bottom: 8,
              child: Material(
                color: const Color(0xFF2B9FD4),
                shape: const CircleBorder(),
                elevation: 2,
                shadowColor: const Color(0x662B9FD4),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onCameraTap,
                  child: Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.photo_camera_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Future<String?> pickProfileAvatar(BuildContext context, {ImagePicker? picker}) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text('Camera', style: GoogleFonts.inter(fontSize: 15)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text('Gallery', style: GoogleFonts.inter(fontSize: 15)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
  if (source == null) return null;
  final image = await (picker ?? ImagePicker()).pickImage(
    source: source,
    imageQuality: 85,
  );
  return image?.path;
}

class ProfileSaveChip extends StatelessWidget {
  const ProfileSaveChip({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: isLoading ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E90D6),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Save',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
