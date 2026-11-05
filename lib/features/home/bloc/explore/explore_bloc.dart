import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/features/home/bloc/explore/explore_event.dart';
import 'package:w2t_mobile/features/home/bloc/explore/explore_state.dart';
import 'package:w2t_mobile/features/home/data/explore_api.dart';
import 'package:w2t_mobile/features/home/data/explore_content.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc({required ExploreApi api})
      : _api = api,
        super(ExploreState()) {
    on<ExploreRequested>(_onRequested);
    on<ExploreCategoryChanged>(_onCategoryChanged);
    on<ExploreTopicChanged>(
      (event, emit) => emit(state.copyWith(topic: event.topic)),
    );
    add(const ExploreRequested());
  }

  final ExploreApi _api;

  Future<void> _onRequested(
    ExploreRequested event,
    Emitter<ExploreState> emit,
  ) {
    return _load(emit, state.category);
  }

  Future<void> _onCategoryChanged(
    ExploreCategoryChanged event,
    Emitter<ExploreState> emit,
  ) {
    return _load(emit, event.category);
  }

  Future<void> _load(Emitter<ExploreState> emit, String category) async {
    emit(
      state.copyWith(
        status: ExploreStatus.loading,
        category: category,
        errorMessage: null,
      ),
    );
    try {
      final videos = await _api.fetchItems(category);
      emit(
        state.copyWith(
          status: ExploreStatus.success,
          videos: videos.isEmpty ? ExploreContent.videosFor(category) : videos,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ExploreStatus.success,
          videos: ExploreContent.videosFor(category),
          errorMessage: apiErrorMessage(error),
        ),
      );
    }
  }
}
