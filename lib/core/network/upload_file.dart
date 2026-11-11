import 'package:dio/dio.dart';

Future<MultipartFile> multipartFileFromPath(String path) {
  return MultipartFile.fromFile(
    path,
    filename: fileNameOf(path),
  );
}

String fileNameOf(String path) {
  final normalized = path.replaceAll('\\', '/');
  final index = normalized.lastIndexOf('/');
  return index == -1 ? normalized : normalized.substring(index + 1);
}
