import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upday_task/dal/redux/middleware/middleware.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';
import 'package:upday_task/dal/redux/reducers/reducer.dart';
import 'package:upday_task/pages/gallery/view_model/gallery.dart';
import 'package:redux/redux.dart';

/// This file contains unit test for class [GalleryBlock] - business logic
/// for this application
void main() {
  group('GalleryBlock - show/hide bottom bar', () {
    test(
        'Scrolling controll - hide bottom bar [Scrolling direction reverse,'
        ' current index 0]', () {
      final GalleryBlock galleryBlock = GalleryBlock(store: null);

      galleryBlock.currentIndex = 0;
      galleryBlock.bbScrollControllerSink.add(ScrollDirection.reverse);

      expect(galleryBlock.outBottomBarVisibility, emits(false));
    });

    test(
        'Scrolling controll - hide bottom bar [Scrolling direction forward,'
        ' current index >1 ]', () {
      final GalleryBlock galleryBlock = GalleryBlock(store: null);

      galleryBlock.currentIndex = 1;
      galleryBlock.bbScrollControllerSink.add(ScrollDirection.forward);

      expect(galleryBlock.outBottomBarVisibility, emits(false));
    });

    test(
        'Scrolling controll - show bottom bar [Scrolling direction reverse,'
        ' current index >1 ]', () {
      final GalleryBlock galleryBlock = GalleryBlock(store: null);

      galleryBlock.currentIndex = 1;
      galleryBlock.bbScrollControllerSink.add(ScrollDirection.reverse);

      expect(galleryBlock.outBottomBarVisibility, emits(true));
    });
  });

  group(
      'GalleryBlock - loading new data on index changed - on every 14th'
      'element load new data except the last element of newly loaded data', () {
    test('Load data [Initial loading of data - do not look on index]::TRUE',
        () {
      final GalleryBlock galleryBlock = GalleryBlock(store: null);

      expect(galleryBlock.shouldLoadNewData(0, isInitialLoad: true), true);
    });

    test('Load data [User scroll to index=5 with 30 elements in list]::FALSE',
        () {
      final GalleryBlock galleryBlock = GalleryBlock(store: null);

      // Fake data like has 30 elements in list
      galleryBlock.galleryLength = 30;

      expect(galleryBlock.shouldLoadNewData(5), false);
    });

    test(
        'Load data [Do not call new getting of data if list '
        'has less than 30 elements]::FALSE', () {
      final GalleryBlock galleryBlock = GalleryBlock(store: null);

      // Fake data like has 18 elements in list
      galleryBlock.galleryLength = 18;

      expect(galleryBlock.shouldLoadNewData(14), false);
    });

    test('Load data [User scroll to index=15 with 30 elements in list]::FALSE',
        () {
      final GalleryBlock galleryBlock = GalleryBlock(store: null);

      // Fake data like has 30 elements in list
      galleryBlock.galleryLength = 30;

      expect(galleryBlock.shouldLoadNewData(14), true);
    });
  });

  group('Handle exception on getting data in stream', () {
    test('Get exception because of invalid parameters', (){
      final GalleryBlock galleryBlock = GalleryBlock(
        store: Store<AppState>(
          appReducer,
          initialState: AppState.init(),
          middleware: appMiddleware(),
        ),
      );

      galleryBlock.getData(
          store: Store<AppState>(
            appReducer,
            initialState: AppState.init(),
            middleware: appMiddleware(),
          ),
          page: null);

      expect(galleryBlock.outErrorHandler, emits('error_code_went_wrong'));
    });
  });
}
