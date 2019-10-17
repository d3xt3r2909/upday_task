import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shutterstock_flutter/dal/model/response/gallery_wrapper.dart';

void main() {
  test(
      'Parsing data trough the model (JSON data), this insure that API '
          'response structure is not changed', () async {
    final file = File('../test_resources/gallery_data_dummy.json');

    final GalleryWrapperModel galleryObject =
        GalleryWrapperModel.parseGalleryWrapper(await file.readAsString());

    expect(galleryObject.page, 1);
    expect(galleryObject.images.length, 1);
    expect(galleryObject.images.first.assets['preview'].url.isNotEmpty, true);
  });
  test(
      'Parsing data - No images key', () async {
    final file = File('../test_resources/gallery_data_no_images.json');

    final GalleryWrapperModel galleryObject =
    GalleryWrapperModel.parseGalleryWrapper(await file.readAsString());

    expect(galleryObject.images.length, 0);
    expect(galleryObject.images.isEmpty, true);
  });
  test(
      'Parsing data - Empty array of images', () async {
    final file = File('../test_resources/gallery_data_empty_images.json');

    final GalleryWrapperModel galleryObject =
    GalleryWrapperModel.parseGalleryWrapper(await file.readAsString());

    expect(galleryObject.images.length, 0);
    expect(galleryObject.images.isEmpty, true);
  });
}
