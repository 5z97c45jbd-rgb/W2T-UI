import 'package:equatable/equatable.dart';

sealed class HomeMerchantsEvent extends Equatable {
  const HomeMerchantsEvent();

  @override
  List<Object?> get props => [];
}

class HomeMerchantsRequested extends HomeMerchantsEvent {
  const HomeMerchantsRequested();
}
