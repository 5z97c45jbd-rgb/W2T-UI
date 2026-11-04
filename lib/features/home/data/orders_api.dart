import 'package:dio/dio.dart';
import 'package:w2t_mobile/core/network/api_config.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/core/network/api_response.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/home/data/models/order_item.dart';

class OrdersApi {
  OrdersApi(this._client);

  final DioClient _client;

  Dio get _dio => _client.dio;

  Future<List<OrderItem>> fetchOrders() {
    return _guard(() async {
      final response = await _dio.get<dynamic>(
        '${ApiConfig.order}/api/orders/orders',
      );
      final data = ApiResponse.parse(response.data).data;
      if (data is! Map) return const [];

      final sold = OrderItem.listFrom(data['isOrdered'], OrderSide.sold);
      final purchased = OrderItem.listFrom(
        data['isPurchased'],
        OrderSide.purchased,
      );
      return [
        for (final order in [...sold, ...purchased])
          order.copyWith(imageUrl: _absoluteUrl(order.imageUrl)),
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
