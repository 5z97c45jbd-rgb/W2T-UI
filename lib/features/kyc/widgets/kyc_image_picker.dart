import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:w2t_mobile/core/ui/app_snack_bar.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';

Future<String?> pickKycImage(BuildContext context, {ImagePicker? picker}) async {
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
  if (source == null || !context.mounted) return null;

  final image = await (picker ?? ImagePicker()).pickImage(
    source: source,
    imageQuality: 85,
  );
  if (image == null || !context.mounted) return null;

  final bytes = await image.length();
  if (!context.mounted) return null;
  if (bytes > KycValidators.maxStoreImageBytes) {
    AppSnackBar.show(context, 'Image must be 5 MB or less');
    return null;
  }
  return image.path;
}
