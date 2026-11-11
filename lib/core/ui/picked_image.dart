import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'picked_file_image_stub.dart'
    if (dart.library.io) 'picked_file_image_io.dart' as file_img;

bool pickedImageExists(String? path) {
  if (path == null || path.isEmpty) return false;
  if (kIsWeb) return true;
  return file_img.existsSync(path);
}

ImageProvider? pickedImageProvider(String? path) {
  if (!pickedImageExists(path)) return null;
  if (kIsWeb) return NetworkImage(path!);
  return file_img.fileImage(path!);
}
