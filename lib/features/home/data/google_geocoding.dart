import 'package:dio/dio.dart';
import 'package:w2t_mobile/core/network/api_config.dart';
import 'package:w2t_mobile/features/home/data/models/place_location.dart';

class GoogleGeocoding {
  GoogleGeocoding({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  final Dio _dio;

  Future<PlaceLocation?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConfig.googleGeocodeUrl,
      queryParameters: {
        'latlng': '$latitude,$longitude',
        'key': ApiConfig.googleMapsApiKey,
        'language': 'en',
      },
    );
    final data = response.data;
    if (data is! Map) return null;
    if (data['status'] != 'OK') return null;
    final results = data['results'];
    if (results is! List) return null;
    return fromGeocodeResults(
      results: results,
      latitude: latitude,
      longitude: longitude,
    );
  }

  static PlaceLocation? fromGeocodeResults({
    required List<dynamic> results,
    required double latitude,
    required double longitude,
  }) {
    String? city;
    String? district;
    String? state;
    String? country;

    for (final result in results) {
      if (result is! Map) continue;
      final components = result['address_components'];
      if (components is! List) continue;

      city ??= _component(components, const [
        'locality',
        'postal_town',
        'sublocality',
        'sublocality_level_1',
        'administrative_area_level_3',
      ]);
      district ??= _component(components, const [
        'administrative_area_level_2',
        'administrative_area_level_3',
      ]);
      state ??= _component(components, const ['administrative_area_level_1']);
      country ??= _component(components, const ['country']);
    }

    district ??= city;
    city ??= district;
    if (city == null || city.isEmpty) return null;

    return PlaceLocation(
      district: district ?? city,
      city: city,
      state: state ?? '',
      country: country,
      latitude: latitude,
      longitude: longitude,
    );
  }

  static String? _component(List<dynamic> components, List<String> types) {
    for (final type in types) {
      for (final component in components) {
        if (component is! Map) continue;
        final componentTypes = component['types'];
        if (componentTypes is! List || !componentTypes.contains(type)) {
          continue;
        }
        final name = component['long_name']?.toString().trim();
        if (name != null && name.isNotEmpty) return name;
      }
    }
    return null;
  }
}
