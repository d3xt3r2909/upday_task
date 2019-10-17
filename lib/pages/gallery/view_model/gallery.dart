import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';
import 'package:upday_task/dal/model/response/gallery_item.dart';
import 'package:upday_task/dal/redux/actions/gallery.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';
import 'package:upday_task/pages/gallery/view_model/base_bloc.dart';
import 'package:redux/redux.dart';

/// This class contains helper methods, listeners and variables that are
/// responsible for business logic of gallery page
/// It is made because of separating UI from technical logic
class GalleryBlock implements BaseBloc {
  int galleryLength, visitedIndex = 0, _pageNumber = 1;
  @visibleForTesting
  int currentIndex = 0;
  Store<AppState> store;

  // Bottom bar visibility
  final _bbController = StreamController<bool>.broadcast();

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

  // gallery
  final _galleryImagesSourceController = StreamController<ItemResponse>();

  StreamSink<ItemResponse> get _inGalleryImages =>
      _galleryImagesSourceController.sink;

  Stream<ItemResponse> get outGalleryImages =>
      _galleryImagesSourceController.stream;

  // endregion

  // region error handler controller & sink & stream
  final _errorController = StreamController<String>();

  StreamSink<String> get _inErrorHandler => _errorController.sink;

  Stream<String> get outErrorHandler => _errorController.stream;

  // endregion

  // Combine streams for grid widget
  Stream<ItemResponse> get outGalleryStream => Observable.combineLatest2(
      outItem,
      outGalleryImages,
      (bool e, ItemResponse p) => ItemResponse(
            currentIndex: p.currentIndex,
            sourceList: p.sourceList,
            shouldShowLoadingItems: e,
          ));

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
    _errorController.close();
  }

  /// This event will control visibility of bottom bar based on
  /// [scrollDirection] or index of list
  void _bbScrollEventToState(ScrollDirection scrollDirection) =>
      bbVisibilitySink
          .add(scrollDirection == ScrollDirection.reverse && currentIndex != 0);

  // If user has clicked on "Go to top" button, scroll needs to go on top
  void _bbVisibilityEventToState(bool visibility) =>
      _inBottomBarVisibility.add(visibility);

  /// Based on current [event.index] this method will call external API to get
  /// more data from API service
  /// Also, on the end of method, there is condition statement which represents
  /// should we display two additional item for loading or to show real item
  /// with image in it
  Future<void> _itemEventToState(ItemEvent event) async {
    galleryLength = store?.state?.images?.length ?? 0;
    currentIndex = event.index;

    // On every 15 element (index) of received data, call API and fill up
    // with additional data in redux, after that build method in UI will be
    // again rebuild because state of redux has been changed
    if (shouldLoadNewData(event)) {
//      print(
//       'Load new data: on index ${event.index}; page number: $_pageNumber');
      _inItem.add(true);
      try {
        getData(
                store: store,
                page: _pageNumber,
                shouldRefresh: event.isTryAgain)
            .then((value) {
          _inItem.add(false);
          _inGalleryImages.add(ItemResponse(
              sourceList: store.state.images, currentIndex: event.index));
          // If user start scrolling reverse, do not increment page number
          // and please do not increase number of page if user is again trying
          // to refresh
          if (visitedIndex <= event.index && !event.isTryAgain) {
            _pageNumber++;
          } else {
            visitedIndex = event.index - 20;
          }
        }).catchError((e) {});
      } catch (e) {
        _inItem.add(false);
      }

      visitedIndex = event.index;
    }
  }

  /// On every 14th (read from [currentIndex]) element data needs to be load
  /// Except if [isInitialLoad] is set to true - case for first items in list
  /// Except if [galleryLength] is not large enough - less than 29 elements
  @visibleForTesting
  bool shouldLoadNewData(ItemEvent event) =>
      (galleryLength - 1 - event.index == 15 && galleryLength > 29) ||
      (event.isInitial || event.isTryAgain);

  /// Method will call API point from Redux middleware for downloading data with
  /// images, where [page] represents from what point of data from DB should
  /// this API catch, while [page] parameter is responsible for defining number
  /// of images per one API call
  /// [store] is parameter which is instance of Redux store
  @visibleForTesting
  Future<void> getData(
      {@required Store<AppState> store,
      @required int page,
      int perPage = 30,
      bool shouldRefresh = false}) async {
    if (shouldRefresh) {
      final RefreshImagesAction galleryAction =
          RefreshImagesAction(store.state.images);
      store.dispatch(galleryAction);

      if (!await isInternetAvailable()) {
        _inErrorHandler.add('error_code_went_wrong');
        throw Error();
      }
    } else {
      final RequestGetGallery galleryAction = RequestGetGallery(page, perPage);
      store.dispatch(galleryAction);
      await galleryAction.completer.future.catchError((e) {
        _inErrorHandler.add('error_code_went_wrong');
        throw e;
      });
    }
  }

  /// Ping google domain to see is internet available
  Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      _inErrorHandler.add('error_code_went_wrong');
      return false;
    }
    return true;
  }
}

class ItemResponse {
  List<GalleryItemModel> sourceList;
  int currentIndex;
  bool shouldShowLoadingItems;

  ItemResponse(
      {@required this.sourceList,
      @required this.currentIndex,
      this.shouldShowLoadingItems = false});
}

/// Helper class for business logic layer
class ItemEvent {
  bool isInitial, isTryAgain;
  int index;

  ItemEvent({
    @required this.index,
    this.isInitial = false,
    this.isTryAgain = false,
  });
}
