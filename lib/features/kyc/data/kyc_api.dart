import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:w2t_mobile/core/network/api_config.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/core/network/api_response.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/core/network/upload_file.dart';
import 'package:w2t_mobile/features/kyc/data/models/kyc_case.dart';

class KycApi {
  KycApi(this._client);

  final DioClient _client;

  Dio get _dio => _client.dio;

  Future<KycCase> createCase({
    required String businessId,
    required String businessCategory,
  }) {
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        ApiConfig.payment,
        data: {
          'subjectType': 'MERCHANT_BUSINESS',
          'businessId': businessId,
          'businessCategory': businessCategory,
        },
      );
      final kycCase = KycCase.fromJson(_payload(response.data));
      if (kycCase == null) {
        throw ApiException('KYC case was not returned.');
      }
      return kycCase;
    });
  }

  Future<void> submitDocuments({
    required String caseId,
    required String businessName,
    required Map<String, String> documentMap,
    String productCategory = 'MARKET_PLACE',
    String? filePath,
  }) {
    return _guard(() async {
      final formData = FormData();
      final trimmedFilePath = filePath?.trim();
      if (trimmedFilePath != null && trimmedFilePath.isNotEmpty) {
        formData.files.add(
          MapEntry('file', await multipartFileFromPath(trimmedFilePath)),
        );
      }
      final response = await _dio.post<dynamic>(
        '${ApiConfig.payment}/$caseId/documents',
        queryParameters: {
          'businessName': businessName,
          'productCategory': productCategory,
          'documents': jsonEncode({'documentMap': documentMap}),
        },
        data: formData,
      );
      final data = response.data;
      if (data == null || (data is String && data.trim().isEmpty)) {
        return;
      }
      _payload(data);
    });
  }

  dynamic _payload(dynamic body) {
    if (body == null) return null;
    if (body is! Map) {
      throw ApiException('Unexpected response from the server.');
    }
    if (body.containsKey('success') || body.containsKey('error')) {
      return ApiResponse.parse(body).data;
    }
    return body;
  }

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw apiExceptionFrom(error);
    }
  }
}
