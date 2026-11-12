import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:w2t_mobile/core/network/api_config.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/core/network/api_response.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/home/data/models/city_banner.dart';
import 'package:w2t_mobile/features/home/data/models/place_location.dart';

class CitiesApi {
  CitiesApi(this._client);

  final DioClient _client;

  Dio get _dio => _client.dio;

  Future<String> fetchCityImage({
    PlaceLocation location = PlaceLocation.current,
    int count = 1,
  }) async {
    final banner = await fetchCityBanner(location: location, count: count);
    return banner.imageUrl;
  }

  Future<CityBanner> fetchCityBanner({
    PlaceLocation location = PlaceLocation.current,
    int count = 1,
  }) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(
        '${ApiConfig.order}/api/cities/images',
        queryParameters: queryFor(location, count: count),
      );
      final data = ApiResponse.parse(response.data).data;
      final url = imageUrlFrom(data);
      if (url == null) {
        throw ApiException('City image was not returned.');
      }
      return CityBanner(
        imageUrl: _absoluteUrl(url),
        headline: headlineFrom(data),
      );
    });
  }

  static Map<String, dynamic> queryFor(
    PlaceLocation location, {
    int count = 1,
  }) {
    return {
      'city': location.district,
      if (location.country != null && location.country!.isNotEmpty)
        'country': location.country,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'count': count,
    };
  }

  static String? imageUrlFrom(dynamic data) {
    if (data == null) return null;

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) return null;
      if (trimmed.startsWith('[') || trimmed.startsWith('{')) {
        try {
          return imageUrlFrom(jsonDecode(trimmed));
        } on FormatException {
          return trimmed;
        }
      }
      return trimmed;
    }

    if (data is List) {
      for (final item in data) {
        final url = imageUrlFrom(item);
        if (url != null) return url;
      }
      return null;
    }

    if (data is Map) {
      const keys = [
        'url',
        'imageUrl',
        'image',
        'src',
        'path',
        'data',
        'images',
        'urls',
      ];
      for (final key in keys) {
        final url = imageUrlFrom(data[key]);
        if (url != null) return url;
      }
    }

    return null;
  }

  static String? headlineFrom(dynamic data) {
    if (data == null) return null;

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty || _looksLikeUrl(trimmed)) return null;
      if (trimmed.startsWith('[') || trimmed.startsWith('{')) {
        try {
          return headlineFrom(jsonDecode(trimmed));
        } on FormatException {
          return trimmed;
        }
      }
      return trimmed;
    }

    if (data is List) {
      for (final item in data) {
        final headline = headlineFrom(item);
        if (headline != null) return headline;
      }
      return null;
    }

    if (data is Map) {
      const keys = [
        'headline',
        'title',
        'bannerText',
        'overlayText',
        'tagline',
        'caption',
        'heading',
        'text',
      ];
      for (final key in keys) {
        final headline = headlineFrom(data[key]);
        if (headline != null && !_looksLikeUrl(headline)) return headline;
      }
      for (final key in ['data', 'image', 'banner', 'city']) {
        final headline = headlineFrom(data[key]);
        if (headline != null) return headline;
      }
    }

    return null;
  }

  static bool _looksLikeUrl(String value) {
    final lower = value.toLowerCase();
    return lower.startsWith('http://') ||
        lower.startsWith('https://') ||
        lower.startsWith('/') ||
        lower.contains('.jpg') ||
        lower.contains('.jpeg') ||
        lower.contains('.png') ||
        lower.contains('.webp');
  }

  String _absoluteUrl(String value) {
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
