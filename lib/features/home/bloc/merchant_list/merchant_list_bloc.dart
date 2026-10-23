import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/features/home/bloc/merchant_list/merchant_list_event.dart';
import 'package:w2t_mobile/features/home/bloc/merchant_list/merchant_list_state.dart';
import 'package:w2t_mobile/features/home/data/merchants_api.dart';
import 'package:w2t_mobile/features/home/data/models/merchant.dart';

class MerchantListBloc extends Bloc<MerchantListEvent, MerchantListState> {
  MerchantListBloc({
    required MerchantsApi api,
    required MerchantCategory category,
  })  : _api = api,
        _category = category,
        super(const MerchantListState()) {
    on<MerchantListRequested>(_onRequested);
    add(const MerchantListRequested());
  }

  final MerchantsApi _api;
  final MerchantCategory _category;

  Future<void> _onRequested(
    MerchantListRequested event,
    Emitter<MerchantListState> emit,
  ) async {
    emit(const MerchantListState());
    try {
      final merchants = await _api.fetchMerchantsByCategory(_category);
      emit(MerchantListState(
        status: MerchantListStatus.success,
        merchants: merchants,
      ));
    } catch (error) {
      emit(MerchantListState(
        status: MerchantListStatus.failure,
        errorMessage: apiErrorMessage(error),
      ));
    }
  }
}
