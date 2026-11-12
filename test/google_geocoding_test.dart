import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/features/home/data/google_geocoding.dart';

void main() {
  test('parses city, district and state from Google geocode results', () {
    final location = GoogleGeocoding.fromGeocodeResults(
      latitude: 18.0072,
      longitude: 79.55896,
      results: const [
        {
          'address_components': [
            {
              'long_name': 'Hanamkonda',
              'types': ['locality', 'political'],
            },
            {
              'long_name': 'Hanumakonda',
              'types': ['administrative_area_level_2', 'political'],
            },
            {
              'long_name': 'Telangana',
              'types': ['administrative_area_level_1', 'political'],
            },
            {
              'long_name': 'India',
              'types': ['country', 'political'],
            },
          ],
        },
      ],
    );

    expect(location?.city, 'Hanamkonda');
    expect(location?.district, 'Hanumakonda');
    expect(location?.state, 'Telangana');
    expect(location?.displayLabel, 'Hanamkonda, Telangana');
  });
}
