import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/home/bloc/city_image/city_image_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/city_image/city_image_state.dart';
import 'package:w2t_mobile/features/home/data/cities_api.dart';
import 'package:w2t_mobile/features/home/data/models/place_location.dart';

class _FakeCitiesApi extends CitiesApi {
  _FakeCitiesApi({this.imageUrl, this.error})
      : super(DioClient(AuthTokenHolder()));

  final String? imageUrl;
  final Object? error;

  @override
  Future<String> fetchCityImage({
    PlaceLocation location = PlaceLocation.current,
    int count = 1,
  }) async {
    final thrown = error;
    if (thrown != null) throw thrown;
    return imageUrl ?? 'https://cdn.example.com/city.jpg';
  }
}

void main() {
  test('loads the city image URL', () async {
    final bloc = CityImageBloc(
      api: _FakeCitiesApi(imageUrl: 'https://cdn.example.com/city.jpg'),
    );
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<CityImageState>()
            .having((state) => state.status, 'status', CityImageStatus.success)
            .having(
              (state) => state.imageUrl,
              'imageUrl',
              'https://cdn.example.com/city.jpg',
            ),
      ),
    );
    await bloc.close();
  });

  test('falls back when the city image request fails', () async {
    final bloc = CityImageBloc(
      api: _FakeCitiesApi(error: ApiException('unavailable')),
    );
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<CityImageState>().having(
          (state) => state.status,
          'status',
          CityImageStatus.failure,
        ),
      ),
    );
    await bloc.close();
  });
}
