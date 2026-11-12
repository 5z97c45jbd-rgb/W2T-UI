import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/current_location/current_location_state.dart';
import 'package:w2t_mobile/features/home/data/current_location_service.dart';

class CurrentLocationCubit extends Cubit<CurrentLocationState> {
  CurrentLocationCubit({required CurrentLocationService service})
      : _service = service,
        super(const CurrentLocationState()) {
    load();
  }

  final CurrentLocationService _service;

  Future<void> load() async {
    emit(const CurrentLocationState());
    final location = await _service.fetch();
    if (isClosed) return;
    if (location == null) {
      emit(const CurrentLocationState(status: CurrentLocationStatus.failure));
      return;
    }
    emit(CurrentLocationState(
      status: CurrentLocationStatus.success,
      location: location,
    ));
  }
}
