import 'package:dio/dio.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
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
  }) {
    return _guard(() async {
      await _dio.post<dynamic>(
        '/api/auth/register/otp',
        data: {
          if (email != null) 'email': email,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          'password': password,
        },
      );
    });
  }

  Future<AuthSession?> register({
    String? email,
    String? phoneNumber,
    required String password,
    required String otpCode,
    required String deviceToken,
  }) {
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        '/api/auth/register',
        queryParameters: {'deviceToken': deviceToken},
        data: {
          if (email != null) 'email': email,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          'password': password,
          'otpCode': otpCode,
        },
      );
      return _sessionFrom(response.data);
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
      final session = _sessionFrom(response.data);
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
    return _guard(() async {
      await _dio.get<dynamic>(
        '/api/auth/users/${Uri.encodeComponent(userUq)}/reset-password',
        queryParameters: {'deviceToken': deviceToken},
      );
    });
  }

  Future<void> resetPassword({
    required String userUq,
    required String newPassword,
    required String otp,
  }) {
    return _guard(() async {
      await _dio.post<dynamic>(
        '/api/auth/users/${Uri.encodeComponent(userUq)}/reset-password/otp',
        data: {
          'newPassword': newPassword,
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
    return _guard(() async {
      await _dio.post<dynamic>(
        '/api/auth/user/$userId/profile/me',
        data: {
          'fullName': fullName,
          'phoneNumber': phoneNumber,
        },
      );
    });
  }

  Future<void> logout() {
    return _guard(() async {
      await _dio.post<dynamic>('/api/auth/logout');
    });
  }

  AuthSession? _sessionFrom(dynamic data) {
    if (data is! Map) return null;
    final userId = data['userId']?.toString();
    final token = data['accessToken']?.toString();
    if (userId == null || userId.isEmpty || token == null || token.isEmpty) {
      return null;
    }
    final tokenType = data['tokenType']?.toString();
    return AuthSession(
      userId: userId,
      accessToken: token,
      tokenType: tokenType == null || tokenType.isEmpty ? 'Bearer' : tokenType,
    );
  }

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw ApiException(apiErrorMessage(error));
    }
  }
}
