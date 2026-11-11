import 'package:flutter/widgets.dart';

bool existsSync(String path) => false;

ImageProvider fileImage(String path) {
  throw UnsupportedError('File images are not supported on this platform');
}
