import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/city_image/city_image_event.dart';
import 'package:w2t_mobile/features/home/bloc/city_image/city_image_state.dart';
import 'package:w2t_mobile/features/home/data/cities_api.dart';

class CityImageBloc extends Bloc<CityImageEvent, CityImageState> {
  CityImageBloc({
    required CitiesApi api,
    bool autoRequest = true,
  })  : _api = api,
        super(const CityImageState()) {
    on<CityImageRequested>(_onRequested);
    if (autoRequest) add(const CityImageRequested());
  }

  final CitiesApi _api;

  Future<void> _onRequested(
    CityImageRequested event,
    Emitter<CityImageState> emit,
  ) async {
    if (state.status != CityImageStatus.loading || state.hasImage) {
      emit(const CityImageState());
    }
    try {
      final banner = await _api.fetchCityBanner(location: event.location);
      emit(CityImageState(
        status: CityImageStatus.success,
        imageUrl: banner.imageUrl,
        headline: banner.headline,
      ));
    } catch (_) {
      emit(const CityImageState(status: CityImageStatus.failure));
    }
  }
}
