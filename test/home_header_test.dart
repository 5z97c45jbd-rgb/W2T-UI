import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:w2t_mobile/features/home/bloc/current_location/current_location_cubit.dart';
import 'package:w2t_mobile/features/home/data/current_location_service.dart';
import 'package:w2t_mobile/features/home/data/models/place_location.dart';
import 'package:w2t_mobile/features/home/widgets/home_header.dart';

void main() {
  testWidgets('shows city and state in the location chip', (tester) async {
    const place = PlaceLocation(
      district: 'Hanumakonda',
      city: 'Hanamkonda',
      state: 'Telangana',
      latitude: 18.01,
      longitude: 79.55,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => CurrentLocationCubit(
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
          ),
          child: const Scaffold(body: HomeHeader()),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Hanamkonda, Telangana'), findsOneWidget);
  });

  testWidgets('shows -- when location lookup fails', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => CurrentLocationCubit(
            service: CurrentLocationService(
              readPosition: () async => null,
            ),
          ),
          child: const Scaffold(body: HomeHeader()),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('--'), findsOneWidget);
  });
}
