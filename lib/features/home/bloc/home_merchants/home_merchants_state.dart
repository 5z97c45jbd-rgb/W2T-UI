import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/home/data/models/merchant.dart';

enum HomeMerchantsStatus { loading, success, failure }

class HomeMerchantsState extends Equatable {
  const HomeMerchantsState({
    this.status = HomeMerchantsStatus.loading,
    this.merchants = const HomeMerchants(),
    this.errorMessage,
  });

  final HomeMerchantsStatus status;
  final HomeMerchants merchants;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, merchants, errorMessage];
}
