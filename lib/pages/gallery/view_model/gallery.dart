import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:upday_task/dal/redux/actions/gallery.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';
import 'package:upday_task/pages/gallery/view_model/base_bloc.dart';
import 'package:redux/redux.dart';

/// This class contains helper methods, listeners and variables that are
/// responsible for business logic of gallery page
/// It is made because of separating UI from technical logic
class GalleryBlock implements BaseBloc {
  int galleryLength, _visitedIndex = 0, _pageNumber = 1;
  @visibleForTesting
  int currentIndex = 0;
  Store<AppState> store;

  // Bottom bar visibility
  final _bbController = StreamController<bool>();

  // region bottom bar controller & sink and stream
  StreamSink<bool> get _inBottomBarVisibility => _bbController.sink;
  final _bottomBarScrollController = StreamController<ScrollDirection>();

  Stream<bool> get outBottomBarVisibility => _bbController.stream;
  final _bottomBarVisibilityController = StreamController<bool>();

  Sink<bool> get bbVisibilitySink => _bottomBarVisibilityController.sink;

  Sink<ScrollDirection> get bbScrollControllerSink =>
      _bottomBarScrollController.sink;

  // endregion

  // region item builder controller & sink & stream
  final _itemBuildController = StreamController<bool>();
  final _itemEventController = StreamController<ItemEvent>();

  StreamSink<bool> get _inItem => _itemBuildController.sink;

  Stream<bool> get outItem => _itemBuildController.stream;

  Sink<ItemEvent> get itemEventSink => _itemEventController.sink;

  // endregion

  // region error handler controller & sink & stream
  final _errorController = StreamController<String>();

  StreamSink<String> get _inErrorHandler => _errorController.sink;

  Stream<String> get outErrorHandler => _errorController.stream;

  // endregion

  // Is there need to show list witch represents loader of images
  bool get showLoaderList =>
      store?.state?.images?.length == null || store.state.images.isEmpty;

  GalleryBlock({@required this.store}) {
    galleryLength = store?.state?.images?.length ?? 0;
    _itemEventController.stream.listen(_itemEventToState);
    _bottomBarVisibilityController.stream.listen(_bbVisibilityEventToState);
    _bottomBarScrollController.stream.listen(_bbScrollEventToState);
  }

  @override
  void dispose() {
    _itemEventController.close();
    _itemBuildController.close();
    bbScrollControllerSink.close();
    _bbController.close();
    _bottomBarScrollController.close();
  }

  /// This event will control visibility of bottom bar based on
  /// [scrollDirection] or index of list
  void _bbScrollEventToState(ScrollDirection scrollDirection) {
    if (scrollDirection == ScrollDirection.reverse && currentIndex != 0) {
      bbVisibilitySink.add(true);
    } else {
      bbVisibilitySink.add(false);
    }
  }

  // If user has clicked on "Go to top" button, scroll needs to go on top
  void _bbVisibilityEventToState(bool visibility) {
    _inBottomBarVisibility.add(visibility);
  }

  /// Based on current [event.index] this method will call external API to get
  /// more data from API service
  /// Also, on the end of method, there is condition statement which represents
  /// should we display two additional item for loading or to show real item
  /// with image in it
  void _itemEventToState(ItemEvent event) {
    bool isLoading = false;
    galleryLength = store?.state?.images?.length ?? 0;
    currentIndex = event.index;

    // On every 15 element (index) of grid, call API and fill up with additional
    // data in redux, after that build method in UI will be again rebuild
    // because state of redux has been changed
    if (shouldLoadNewData(event.index, isInitialLoad: event.isInitial)) {
      isLoading = true;
      try {
        getData(store: store, page: _pageNumber).then((value) {
          isLoading = false;
        });

        // If user start scrolling reverse, do not increment page number
        if (_visitedIndex < event.index) {
          _pageNumber++;
        }
      } catch (e) {
        print('Limit has been reached on API side, need more filters');
      }

      // Save visited index into global variable
      _visitedIndex = event.index;
    }

    _inItem.add(isLoading && (galleryLength - event.index <= 2));
  }

  /// On every 14th (read from [currentIndex]) element data needs to be load
  /// Except if [isInitialLoad] is set to true - case for first items in list
  /// Except if [galleryLength] is not large enough - less than 29 elements
  @visibleForTesting
  bool shouldLoadNewData(int currentIndex, {bool isInitialLoad = false}) =>
      galleryLength - 1 - currentIndex == 15 && galleryLength > 29 ||
      isInitialLoad;

  /// Method will call API point from Redux middleware for downloading data with
  /// images, where [page] represents from what point of data from DB should
  /// this API catch, while [page] parameter is responsible for defining number
  /// of images per one API call
  /// [store] is parameter which is instance of Redux store
  @visibleForTesting
  Future<void> getData(
      {@required Store<AppState> store,
      @required int page,
      int perPage = 30}) async {
    final galleryAction = RequestGetGallery(page, perPage);
    store.dispatch(galleryAction);

    await galleryAction.completer.future.catchError((e) {
      _inErrorHandler.add('error_code_went_wrong');
    });
  }
}

/// Helper class for business logic layer
class ItemEvent {
  bool isInitial;
  int index;

  ItemEvent({@required this.index, this.isInitial = false});
}
