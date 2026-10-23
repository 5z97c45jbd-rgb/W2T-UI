import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/network/api_exception.dart';
import 'package:w2t_mobile/core/network/auth_token_holder.dart';
import 'package:w2t_mobile/core/network/dio_client.dart';
import 'package:w2t_mobile/features/home/bloc/home_merchants/home_merchants_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/home_merchants/home_merchants_state.dart';
import 'package:w2t_mobile/features/home/bloc/merchant_list/merchant_list_bloc.dart';
import 'package:w2t_mobile/features/home/bloc/merchant_list/merchant_list_state.dart';
import 'package:w2t_mobile/features/home/data/merchants_api.dart';
import 'package:w2t_mobile/features/home/data/models/merchant.dart';

class _FakeMerchantsApi extends MerchantsApi {
  _FakeMerchantsApi({this.home, this.byCategory, this.error})
      : super(DioClient(AuthTokenHolder()));

  final HomeMerchants? home;
  final List<Merchant>? byCategory;
  final Object? error;

  @override
  Future<HomeMerchants> fetchHomeMerchants() async {
    final thrown = error;
    if (thrown != null) throw thrown;
    return home ?? const HomeMerchants();
  }

  @override
  Future<List<Merchant>> fetchMerchantsByCategory(
    MerchantCategory category,
  ) async {
    final thrown = error;
    if (thrown != null) throw thrown;
    return byCategory ?? const [];
  }
}

void main() {
  test('loads grouped merchants for the home page', () async {
    const merchants = HomeMerchants(
      restaurants: [
        Merchant(
          id: '1',
          name: 'Sample Restaurant',
          category: MerchantCategory.food,
          ratings: 5,
        ),
      ],
    );
    final bloc = HomeMerchantsBloc(api: _FakeMerchantsApi(home: merchants));
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<HomeMerchantsState>()
            .having((state) => state.status, 'status', HomeMerchantsStatus.success)
            .having(
              (state) => state.merchants.restaurants.single.name,
              'restaurant',
              'Sample Restaurant',
            ),
      ),
    );
    await bloc.close();
  });

  test('loads merchants for a see-all category', () async {
    final bloc = MerchantListBloc(
      api: _FakeMerchantsApi(
        byCategory: const [
          Merchant(
            id: '1',
            name: 'Sample Restaurant',
            category: MerchantCategory.food,
            ratings: 5,
          ),
        ],
      ),
      category: MerchantCategory.food,
    );
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<MerchantListState>()
            .having((state) => state.status, 'status', MerchantListStatus.success)
            .having((state) => state.merchants.single.name, 'name', 'Sample Restaurant'),
      ),
    );
    await bloc.close();
  });

  test('surfaces a merchant list failure', () async {
    final bloc = MerchantListBloc(
      api: _FakeMerchantsApi(error: ApiException('unavailable')),
      category: MerchantCategory.groceries,
    );
    await expectLater(
      bloc.stream,
      emitsThrough(
        isA<MerchantListState>().having(
          (state) => state.status,
          'status',
          MerchantListStatus.failure,
        ),
      ),
    );
    await bloc.close();
  });
}
