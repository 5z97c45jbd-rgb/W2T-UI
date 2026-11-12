import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:w2t_mobile/core/ui/app_snack_bar.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';

Future<String?> pickKycPdf(
  BuildContext context, {
  Future<PlatformFile?> Function()? picker,
}) async {
  final file = await (picker ??
      () => FilePicker.pickFile(
            type: FileType.custom,
            allowedExtensions: const ['pdf'],
          ))();
  if (file == null || !context.mounted) return null;

  final path = file.path?.trim() ?? '';
  final isPdf = KycValidators.isPdfPath(path) ||
      (file.extension?.toLowerCase() == 'pdf');
  if (path.isEmpty || !isPdf) {
    AppSnackBar.show(context, 'Aadhaar must be a PDF file');
    return null;
  }
  final size = file.lengthSync() ?? await file.length() ?? 0;
  if (!context.mounted) return null;
  if (size > KycValidators.maxStoreImageBytes) {
    AppSnackBar.show(context, 'PDF must be 5 MB or less');
    return null;
  }
  return path;
}
