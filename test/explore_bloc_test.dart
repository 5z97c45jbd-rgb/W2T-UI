import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/home/bloc/explore/explore_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/explore/explore_event.dart';
import 'package:w2t_mobile/features/home/bloc/explore/explore_state.dart';
import 'package:w2t_mobile/features/home/data/explore_api.dart';
import 'package:w2t_mobile/features/home/data/models/explore_video.dart';

class _FakeExploreApi extends ExploreApi {
  _FakeExploreApi() : super(DioClient(AuthTokenHolder()));

  String? lastCategory;

  @override
  Future<List<ExploreVideo>> fetchItems(String category) async {
    lastCategory = category;
    return [
      ExploreVideo(
        title: '$category item',
        creator: 'W2T',
        imageAsset: AppAssets.paradiseBiryani,
        duration: '',
        likesLabel: '23',
        costLabel: '',
        category: category,
        trending: true,
      ),
    ];
  }
}

void main() {
  test('loads explore items for the selected category', () async {
    final api = _FakeExploreApi();
    final bloc = ExploreBloc(api: api);
    addTearDown(bloc.close);

    await bloc.stream.firstWhere(
      (state) => state.status == ExploreStatus.success,
    );
    expect(api.lastCategory, 'Food');
    expect(bloc.state.visibleVideos.single.title, 'Food item');

    bloc.add(const ExploreCategoryChanged('Electronics'));
    await bloc.stream.firstWhere(
      (state) =>
          state.status == ExploreStatus.success &&
          state.category == 'Electronics',
    );
    expect(api.lastCategory, 'Electronics');
    expect(bloc.state.visibleVideos.single.title, 'Electronics item');
  });
}
