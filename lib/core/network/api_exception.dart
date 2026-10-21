import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}

String apiErrorMessage(Object error) {
  if (error is ApiException) return error.message;
  if (error is DioException) {
    return _dioMessage(error);
  }
  return 'Something went wrong. Please try again.';
}

ApiException apiExceptionFrom(DioException error) {
  return ApiException(
    _dioMessage(error),
    statusCode: error.response?.statusCode,
  );
}

String _dioMessage(DioException error) {
  final data = error.response?.data;
  if (data is Map) {
    final message = data['error'] ?? data['message'] ?? data['detail'];
    if (message is String && message.trim().isNotEmpty) return message.trim();
  }
  if (data is String && data.trim().isNotEmpty) return data.trim();
  if (error.response?.statusCode == 401) {
    return 'Your session expired. Please sign in again.';
  }
  return 'Request failed. Please try again.';
}
