import 'package:dio/dio.dart';
import 'package:w2t_mobile/core/network/api_config.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/core/network/api_response.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/home/data/catalog_categories.dart';
import 'package:w2t_mobile/features/home/data/models/explore_video.dart';

class ExploreApi {
  ExploreApi(this._client);

  final DioClient _client;

  Dio get _dio => _client.dio;

  Future<List<ExploreVideo>> fetchItems(String category) {
    return _guard(() async {
      final apiCategory = CatalogCategories.apiValue(category);
      final response = await _dio.get<dynamic>(
        '${ApiConfig.order}/api/items/category/$apiCategory',
      );
      return [
        for (final video in ExploreVideo.listFrom(
          ApiResponse.parse(response.data).data,
          category: category,
        ))
          video.copyWith(
            imageUrl: _absoluteUrl(video.imageUrl),
            videoUrl: _absoluteUrl(video.videoUrl),
          ),
      ];
    });
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
