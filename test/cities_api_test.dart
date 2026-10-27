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

  test('city images use hardcoded Warangal city', () {
    expect(PlaceLocation.cityImagesCity, 'Warangal');
    expect(PlaceLocation.current.city, 'Warangal');
  });
}
