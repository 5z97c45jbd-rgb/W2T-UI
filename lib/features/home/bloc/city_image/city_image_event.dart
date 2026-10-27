import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/features/home/data/models/place_location.dart';

sealed class CityImageEvent extends Equatable {
  const CityImageEvent();

  @override
  List<Object?> get props => [];
}

class CityImageRequested extends CityImageEvent {
  const CityImageRequested({this.location = PlaceLocation.current});

  final PlaceLocation location;

  @override
  List<Object?> get props => [
        location.district,
        location.country,
        location.latitude,
        location.longitude,
      ];
}
