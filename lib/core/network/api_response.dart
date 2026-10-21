import 'package:w2t_mobile/core/network/api_exception.dart';

/// Shared body returned by every auth endpoint:
/// `{ "data": ..., "success": true | "message", "error": "..." }`.
class ApiResponse {
  const ApiResponse({this.data, this.successMessage});

  final dynamic data;

  /// Set when `success` is a message string rather than a boolean.
  final String? successMessage;

  static ApiResponse parse(dynamic body) {
    if (body is! Map) {
      throw ApiException('Unexpected response from the server.');
    }

    final error = _nonEmptyString(body['error']);
    final success = body['success'];
    final successMessage = success is String ? _nonEmptyString(success) : null;
    if (!_isSuccess(success) || error != null) {
      throw ApiException(error ?? 'Request failed. Please try again.');
    }

    return ApiResponse(data: body['data'], successMessage: successMessage);
  }

  static bool _isSuccess(Object? success) {
    if (success is bool) return success;
    if (success is num) return success != 0;
    if (success is String) {
      final value = success.trim().toLowerCase();
      if (value.isEmpty) return true;
      return !const {
        'false',
        '0',
        'no',
        'failure',
        'failed',
        'error',
      }.contains(value);
    }
    return false;
  }

  static String? _nonEmptyString(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed;
  }
}
