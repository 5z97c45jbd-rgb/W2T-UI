import 'package:equatable/equatable.dart';

sealed class MerchantListEvent extends Equatable {
  const MerchantListEvent();

  @override
  List<Object?> get props => [];
}

class MerchantListRequested extends MerchantListEvent {
  const MerchantListRequested();
}
