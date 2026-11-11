import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';

Future<MultipartFile> multipartFileFromPath(String path) async {
  final file = XFile(path);
  final bytes = await file.readAsBytes();
  final name = file.name.trim().isNotEmpty ? file.name : fileNameOf(path);
  final filename = name.isEmpty ? 'upload.jpg' : name;
  return MultipartFile.fromBytes(
    bytes,
    filename: filename,
    contentType: contentTypeForUpload(filename, mimeType: file.mimeType),
  );
}

DioMediaType contentTypeForUpload(String filename, {String? mimeType}) {
  final declared = mimeType?.trim().toLowerCase();
  if (declared != null && declared.contains('/')) {
    final parts = declared.split('/');
    if (parts.length == 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return DioMediaType(parts[0], parts[1]);
    }
  }
  final lower = filename.toLowerCase();
  if (lower.endsWith('.png')) return DioMediaType('image', 'png');
  if (lower.endsWith('.webp')) return DioMediaType('image', 'webp');
  if (lower.endsWith('.gif')) return DioMediaType('image', 'gif');
  if (lower.endsWith('.pdf')) return DioMediaType('application', 'pdf');
  return DioMediaType('image', 'jpeg');
}

String fileNameOf(String path) {
  final normalized = path.replaceAll('\\', '/');
  final index = normalized.lastIndexOf('/');
  return index == -1 ? normalized : normalized.substring(index + 1);
}
