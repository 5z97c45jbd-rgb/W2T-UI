import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/home/data/models/place_location.dart';

enum CurrentLocationStatus { loading, success, failure }

class CurrentLocationState extends Equatable {
  const CurrentLocationState({
    this.status = CurrentLocationStatus.loading,
    this.location,
  });

  final CurrentLocationStatus status;
  final PlaceLocation? location;

  String get displayLabel => location?.displayLabel ?? '--';

  bool get isLoading => status == CurrentLocationStatus.loading;

  @override
  List<Object?> get props => [status, location];
}
