import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:w2t_mobile/core/network/api_config.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/core/network/api_response.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/core/network/upload_file.dart';
import 'package:w2t_mobile/features/home/data/models/merchant.dart';

class MerchantsApi {
  MerchantsApi(this._client);

  final DioClient _client;

  Dio get _dio => _client.dio;

  Future<HomeMerchants> fetchHomeMerchants() {
    return _guard(() async {
      final response = await _dio.get<dynamic>(
        '${ApiConfig.order}/api/merchants',
      );
      final merchants = HomeMerchants.fromJson(
        ApiResponse.parse(response.data).data,
      );
      return HomeMerchants(
        restaurants: _withAbsoluteUrls(merchants.restaurants),
        groceries: _withAbsoluteUrls(merchants.groceries),
        individuals: _withAbsoluteUrls(merchants.individuals),
      );
    });
  }

  Future<List<Merchant>> fetchMerchantsByCategory(MerchantCategory category) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(
        '${ApiConfig.order}/api/merchants/${category.apiValue}',
      );
      return _withAbsoluteUrls(
        Merchant.listFrom(ApiResponse.parse(response.data).data),
      );
    });
  }

  Future<Merchant> createMerchant(
    Map<String, dynamic> body, {
    String? imagePath,
  }) {
    return _guard(() async {
      final formData = FormData();
      formData.files.add(
        MapEntry(
          'merchant',
          MultipartFile.fromString(
            jsonEncode(body),
            contentType: DioMediaType('application', 'json'),
          ),
        ),
      );
      final trimmedImagePath = imagePath?.trim();
      if (trimmedImagePath != null && trimmedImagePath.isNotEmpty) {
        formData.files.add(
          MapEntry('file', await multipartFileFromPath(trimmedImagePath)),
        );
      }
      final response = await _dio.post<dynamic>(
        '${ApiConfig.order}/api/merchants',
        data: formData,
      );
      final merchant = Merchant.fromCreatePayload(
        _payload(response.data),
        name: '${body['name'] ?? ''}'.trim(),
        category: body['category']?.toString(),
      );
      if (merchant == null) {
        throw ApiException('Merchant was not returned.');
      }
      return merchant;
    });
  }

  dynamic _payload(dynamic body) {
    if (body is! Map) {
      throw ApiException('Unexpected response from the server.');
    }
    if (body.containsKey('success') || body.containsKey('error')) {
      return ApiResponse.parse(body).data;
    }
    return body;
  }

  List<Merchant> _withAbsoluteUrls(List<Merchant> merchants) {
    return [
      for (final merchant in merchants)
        Merchant(
          id: merchant.id,
          name: merchant.name,
          category: merchant.category,
          ratings: merchant.ratings,
          userId: merchant.userId,
          imageUrl: _absoluteUrl(merchant.imageUrl),
          enabled: merchant.enabled,
          kycApproved: merchant.kycApproved,
        ),
    ];
  }

  String? _absoluteUrl(String? value) {
    if (value == null || value.isEmpty) return null;
    final uri = Uri.parse(value);
    if (uri.hasScheme) return value;
    if (value.startsWith('/')) {
      return '${ApiConfig.baseUrl}${ApiConfig.order}$value';
    }
    return Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.order}/',
    ).resolve(value).toString();
  }

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw apiExceptionFrom(error);
    }
  }
}
