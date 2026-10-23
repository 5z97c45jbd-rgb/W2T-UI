import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/features/home/bloc/home_merchants/home_merchants_event.dart';
import 'package:w2t_mobile/features/home/bloc/home_merchants/home_merchants_state.dart';
import 'package:w2t_mobile/features/home/data/merchants_api.dart';

class HomeMerchantsBloc extends Bloc<HomeMerchantsEvent, HomeMerchantsState> {
  HomeMerchantsBloc({required MerchantsApi api})
      : _api = api,
        super(const HomeMerchantsState()) {
    on<HomeMerchantsRequested>(_onRequested);
    add(const HomeMerchantsRequested());
  }

  final MerchantsApi _api;

  Future<void> _onRequested(
    HomeMerchantsRequested event,
    Emitter<HomeMerchantsState> emit,
  ) async {
    emit(const HomeMerchantsState());
    try {
      final merchants = await _api.fetchHomeMerchants();
      emit(HomeMerchantsState(
        status: HomeMerchantsStatus.success,
        merchants: merchants,
      ));
    } catch (error) {
      emit(HomeMerchantsState(
        status: HomeMerchantsStatus.failure,
        errorMessage: apiErrorMessage(error),
      ));
    }
  }
}
