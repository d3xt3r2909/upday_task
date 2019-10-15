import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:upday_task/dal/model/response/gallery_item.dart';
import 'package:upday_task/dal/redux/actions/gallery.dart';
import 'package:upday_task/dal/redux/reducers/gallery.dart';

void main() {
  final List<GalleryItemModel> sourceImages = [
    GalleryItemModel(
      assets: {},
      id: '1',
    ),
    GalleryItemModel(
      assets: {},
      id: '2',
    ),
    GalleryItemModel(
      assets: {},
      id: '3',
    )
  ];
  final List<GalleryItemModel> newImages = [
    GalleryItemModel(
      assets: {},
      id: '4',
    ),
    GalleryItemModel(
      assets: {},
      id: '5',
    ),
    GalleryItemModel(
      assets: {},
      id: '6',
    )
  ];

  group(
      'Redux reducer test for merging two list - one that is already in '
      'store and other one which cames from API point', () {
    test('Merge two list in one [if redux is not initialize yet (null)]',
        () async {
      final AddImagesAction reduxAction = AddImagesAction(newImages);

      final List<GalleryItemModel> result =
          updateImagesState(null, reduxAction);

      expect(result.length, 3);
    });

    test('Merge two list in one [if redux source list is empty]', () async {
      final AddImagesAction reduxAction = AddImagesAction(newImages);

      final List<GalleryItemModel> result = updateImagesState([], reduxAction);

      expect(result.length, 3);
    });

    test(
        'Merge two list in one [if redux source list contains elements,'
        ' but new list did not get new data]', () async {
      final AddImagesAction reduxAction = AddImagesAction([]);

      final List<GalleryItemModel> result =
          updateImagesState(sourceImages, reduxAction);

      expect(result.length, 3);
    });

    test(
        'Parsing data trough the model (JSON data), this insure that API '
        'response structure is not changed', () async {
      final AddImagesAction reduxAction = AddImagesAction(newImages);

      final List<GalleryItemModel> result =
          updateImagesState(sourceImages, reduxAction);

      expect(result.length, 6);
    });
  });
}
