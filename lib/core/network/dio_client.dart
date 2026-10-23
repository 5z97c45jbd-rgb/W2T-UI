import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:w2t_mobile/core/network/api_config.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';

class DioClient {
  DioClient(this.tokenHolder) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = tokenHolder.accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            final options = response.requestOptions;
            debugPrint(
              '${options.method} ${options.uri}\n'
              'Body: ${options.data}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
              'response ${error.response?.statusCode}: ${error.response?.data}',
            );
          }
          if (_shouldInvalidateSession(error)) {
            tokenHolder.notifyUnauthorized();
          }
          handler.next(error);
        },
      ),
    );
  }

  final AuthTokenHolder tokenHolder;
  late final Dio dio;

  bool _shouldInvalidateSession(DioException error) {
    if (error.response?.statusCode != 401) return false;
    if (tokenHolder.accessToken == null || tokenHolder.accessToken!.isEmpty) {
      return false;
    }
    final path = error.requestOptions.path;
    return !path.contains('${ApiConfig.auth}/api/auth/login') &&
        !path.contains('${ApiConfig.auth}/api/auth/register') &&
        !path.contains('/reset-password');
  }
}
