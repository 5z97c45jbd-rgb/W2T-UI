import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';

class DioClient {
  DioClient(this.tokenHolder) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://auth.wsquaret.com',
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
          if (kDebugMode) {
            debugPrint(
              '[network] ${options.method} ${options.uri}\n'
              'request: ${options.data}',
            );
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            final options = response.requestOptions;
            debugPrint(
              '[network] ${options.method} ${options.uri}\n'
              'response ${response.statusCode}: ${response.data}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            final options = error.requestOptions;
            debugPrint(
              '[network] ${options.method} ${options.uri}\n'
              'request: ${options.data}\n'
              'response ${error.response?.statusCode}: ${error.response?.data}',
            );
          }
          handler.next(error);
        },
      ),
    );
  }

  final AuthTokenHolder tokenHolder;
  late final Dio dio;
}
