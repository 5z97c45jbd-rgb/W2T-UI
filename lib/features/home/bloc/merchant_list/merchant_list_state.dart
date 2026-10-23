import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/home/data/models/merchant.dart';

enum MerchantListStatus { loading, success, failure }

class MerchantListState extends Equatable {
  const MerchantListState({
    this.status = MerchantListStatus.loading,
    this.merchants = const [],
    this.errorMessage,
  });

  final MerchantListStatus status;
  final List<Merchant> merchants;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, merchants, errorMessage];
}
