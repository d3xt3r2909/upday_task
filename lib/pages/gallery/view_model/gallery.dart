import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:upday_task/dal/redux/actions/gallery.dart';
import 'package:upday_task/dal/redux/models/app_state.dart';
import 'package:upday_task/pages/gallery/view_model/base_bloc.dart';
import 'package:redux/redux.dart';

class GalleryBlock implements BaseBloc {
  int galleryLength, currentIndex, visitedIndex, pageNumber;
  Store<AppState> store;

  // Bottom bar visibility
  final _bbController = StreamController<bool>();

  StreamSink<bool> get _inBottomBarVisibility => _bbController.sink;

  Stream<bool> get outBottomBarVisibility => _bbController.stream;

  final _bottomBarVisibilityController = StreamController<bool>();

  Sink<bool> get bbVisibilitySink => _bottomBarVisibilityController.sink;

  final _bottomBarScrollController = StreamController<ScrollDirection>();

  Sink<ScrollDirection> get bbScrollControllerSink =>
      _bottomBarScrollController.sink;

  // Item controllers
  final _itemBuildController = StreamController<bool>();

  StreamSink<bool> get _inItem => _itemBuildController.sink;

  Stream<bool> get outItem => _itemBuildController.stream;

  final _itemEventController = StreamController<ItemEvent>();

  Sink<ItemEvent> get itemEventSink => _itemEventController.sink;

  bool get showLoaderList =>
      store?.state?.images?.length == null || store.state.images.isEmpty;

  GalleryBlock(
      {@required this.store,
      this.currentIndex = 0,
      this.visitedIndex = 0,
      this.pageNumber = 1}) {
    galleryLength = store.state.images?.length ?? 0;
    _itemEventController.stream.listen(_itemEventToState);
    _bottomBarVisibilityController.stream.listen(_bbVisibilityEventToState);
    _bottomBarScrollController.stream.listen(_bbScrollEventToState);
  }

  @override
  void dispose() {
    _itemEventController.close();
    _itemBuildController.close();
  }

  void _bbScrollEventToState(ScrollDirection scrollDirection) {
    if (scrollDirection == ScrollDirection.reverse) {
      bbVisibilitySink.add(true);
    }

    if (scrollDirection == ScrollDirection.forward && currentIndex == 0) {
      bbVisibilitySink.add(false);
    }
  }

  void _bbVisibilityEventToState(bool visibility) {
    _inBottomBarVisibility.add(visibility);
  }

  /// When building new event
  void _itemEventToState(ItemEvent event) {
    bool isLoading = false;
    galleryLength = store?.state?.images?.length ?? 0;
    currentIndex = event.index;
    if (galleryLength - 1 - event.index == 15 && galleryLength > 29 ||
        event.isInitial) {
      isLoading = true;
      try {
        _getData(store: store, page: pageNumber).then((value) {
          isLoading = false;
        });
        if (visitedIndex < event.index) {
          pageNumber++;
        }
      } catch (e) {
        print('Limit has been reached on API side, need more filters');
      }
      visitedIndex = event.index;
    }

    _inItem.add(isLoading && (galleryLength - event.index <= 2));
  }

  /// Get images from external API call
  Future<void> _getData(
      {@required Store<AppState> store,
      @required int page,
      int perPage = 30}) async {
    final galleryAction = RequestGetGallery(page, perPage);
    store.dispatch(galleryAction);

    await galleryAction.completer.future;
  }
}

class ItemEvent {
  bool isInitial;
  int index;

  ItemEvent({@required this.index, this.isInitial = false});
}
