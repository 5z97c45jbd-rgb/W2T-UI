import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:w2t_mobile/features/home/bloc/current_location/current_location_cubit.dart';
import 'package:w2t_mobile/features/home/bloc/current_location/current_location_state.dart';
import 'package:w2t_mobile/features/home/data/current_location_service.dart';
import 'package:w2t_mobile/features/home/data/models/place_location.dart';

void main() {
  test('loads city, district and state from the device location', () async {
    const place = PlaceLocation(
      district: 'Hanumakonda',
      city: 'Hanamkonda',
      state: 'Telangana',
      country: 'India',
      latitude: 18.01,
      longitude: 79.55,
    );
    final cubit = CurrentLocationCubit(
      service: CurrentLocationService(
        readPosition: () async => Position(
          longitude: place.longitude,
          latitude: place.latitude,
          timestamp: DateTime(2026, 1, 1),
          accuracy: 1,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        ),
        reverseGeocode: (latitude, longitude) async => place,
      ),
    );

    await expectLater(
      cubit.stream,
      emitsThrough(
        isA<CurrentLocationState>()
            .having(
              (state) => state.status,
              'status',
              CurrentLocationStatus.success,
            )
            .having((state) => state.displayLabel, 'label', 'Hanamkonda, Telangana')
            .having((state) => state.location?.district, 'district', 'Hanumakonda'),
      ),
    );
    await cubit.close();
  });

  test('shows no location when lookup fails', () async {
    final cubit = CurrentLocationCubit(
      service: CurrentLocationService(
        readPosition: () async => null,
      ),
    );

    await expectLater(
      cubit.stream,
      emitsThrough(
        isA<CurrentLocationState>()
            .having(
              (state) => state.status,
              'status',
              CurrentLocationStatus.failure,
            )
            .having((state) => state.location, 'location', isNull)
            .having((state) => state.displayLabel, 'label', '--'),
      ),
    );
    await cubit.close();
  });
}
