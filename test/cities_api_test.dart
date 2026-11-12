import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/home/data/cities_api.dart';
import 'package:w2t_mobile/features/home/data/models/place_location.dart';

void main() {
  test('reads a plain image URL from data', () {
    expect(
      CitiesApi.imageUrlFrom('https://cdn.example.com/warangal.jpg'),
      'https://cdn.example.com/warangal.jpg',
    );
  });

  test('reads the first URL from a JSON list string', () {
    expect(
      CitiesApi.imageUrlFrom(
        '["https://cdn.example.com/one.jpg","https://cdn.example.com/two.jpg"]',
      ),
      'https://cdn.example.com/one.jpg',
    );
  });

  test('reads a nested imageUrl field', () {
    expect(
      CitiesApi.imageUrlFrom({
        'imageUrl': 'https://cdn.example.com/nested.jpg',
      }),
      'https://cdn.example.com/nested.jpg',
    );
  });

  test('reads headline text without treating image URLs as copy', () {
    expect(
      CitiesApi.headlineFrom({
        'imageUrl': 'https://cdn.example.com/nested.jpg',
        'headline': 'Local Favorites Delivered to You',
      }),
      'Local Favorites Delivered to You',
    );
    expect(
      CitiesApi.headlineFrom('https://cdn.example.com/warangal.jpg'),
      isNull,
    );
  });

  test('city images send the district as the city query param', () {
    const location = PlaceLocation(
      district: 'Hanumakonda',
      city: 'Hanamkonda',
      state: 'Telangana',
      country: 'India',
      latitude: 18.0072,
      longitude: 79.55896,
    );
    expect(
      CitiesApi.queryFor(location),
      {
        'city': 'Hanumakonda',
        'country': 'India',
        'latitude': 18.0072,
        'longitude': 79.55896,
        'count': 1,
      },
    );
  });
}
