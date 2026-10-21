import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/core/network/api_response.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/auth/data/models/auth_session.dart';

class AuthApi {
  AuthApi(this._client);

  final DioClient _client;

  Dio get _dio => _client.dio;

  Future<void> requestRegisterOtp({
    String? email,
    String? phoneNumber,
    required String password,
    required String deviceToken,
  }) {
    return _send(() {
      return _dio.post<dynamic>(
        '/api/auth/register',
        queryParameters: {'deviceToken': deviceToken},
        data: {
          if (email != null) 'email': email,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          'password': password,
        },
      );
    });
  }

  Future<void> verifyRegisterOtp({
    String? email,
    String? phoneNumber,
    required String password,
    required String otpCode,
  }) {
    return _send(() {
      return _dio.post<dynamic>(
        '/api/auth/register/otp',
        data: {
          if (email != null) 'email': email,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          'password': password,
          'otpCode': otpCode,
        },
      );
    });
  }

  Future<AuthSession> login({
    String? email,
    String? phoneNumber,
    required String password,
  }) {
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        '/api/auth/login',
        data: {
          'password': password,
          if (email != null) 'email': email,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        },
      );
      final session = _sessionFrom(ApiResponse.parse(response.data).data);
      if (session == null) {
        throw ApiException('Login succeeded but no session was returned.');
      }
      return session;
    });
  }

  Future<void> requestResetOtp({
    required String userUq,
    required String deviceToken,
  }) {
    return _send(() {
      return _dio.get<dynamic>(
        '/api/auth/users/${Uri.encodeComponent(userUq)}/reset-password',
        queryParameters: {'deviceToken': deviceToken},
      );
    });
  }

  Future<void> resetPassword({
    required String userUq,
    required String newPassword,
    required String confirmPassword,
    required String otp,
  }) {
    return _send(() {
      return _dio.post<dynamic>(
        '/api/auth/users/${Uri.encodeComponent(userUq)}/reset-password/otp',
        data: {
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
          'otp': otp,
        },
      );
    });
  }

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String phoneNumber,
  }) {
    return _send(() {
      return _dio.post<dynamic>(
        '/api/auth/user/$userId/profile/me',
        data: {
          'fullName': fullName,
          'phoneNumber': phoneNumber,
        },
      );
    });
  }

  Future<void> logout() {
    return _send(() => _dio.post<dynamic>('/api/auth/logout'));
  }

  AuthSession? _sessionFrom(dynamic data) {
    final payload = _payloadMap(data);
    if (payload == null) return null;
    final userId = payload['userId']?.toString();
    final token = payload['accessToken']?.toString();
    if (userId == null || userId.isEmpty || token == null || token.isEmpty) {
      return null;
    }
    final tokenType = payload['tokenType']?.toString();
    return AuthSession(
      userId: userId,
      accessToken: token,
      tokenType: tokenType == null || tokenType.isEmpty ? 'Bearer' : tokenType,
    );
  }

  Map<String, dynamic>? _payloadMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    if (data is! String || data.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } on FormatException {
      return null;
    }
    return null;
  }

  Future<void> _send(Future<Response<dynamic>> Function() request) {
    return _guard(() async {
      final response = await request();
      ApiResponse.parse(response.data);
    });
  }

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw ApiException(apiErrorMessage(error));
    }
  }
}
