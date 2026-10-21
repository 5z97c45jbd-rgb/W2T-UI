import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

String apiErrorMessage(Object error) {
  if (error is ApiException) return error.message;
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map) {
      final message = data['error'] ?? data['message'] ?? data['detail'];
      if (message is String && message.trim().isNotEmpty) return message.trim();
    }
    if (data is String && data.trim().isNotEmpty) return data.trim();
    return 'Request failed. Please try again.';
  }
  return 'Something went wrong. Please try again.';
}
