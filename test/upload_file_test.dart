import 'package:flutter_test/flutter_test.dart';
import 'package:w2t_mobile/core/network/upload_file.dart';

void main() {
  test('pdf filenames use application/pdf even when mime is generic', () {
    expect(
      contentTypeForUpload('aadhaar.pdf').mimeType,
      'application/pdf',
    );
    expect(
      contentTypeForUpload(
        'aadhaar.pdf',
        mimeType: 'application/octet-stream',
      ).mimeType,
      'application/pdf',
    );
  });
}
