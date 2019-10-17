import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:shutterstock_flutter/dal/model/response/gallery_item.dart';
import 'package:shutterstock_flutter/dal/redux/actions/gallery.dart';

final galleryReducer = combineReducers<List<GalleryItemModel>>([
  TypedReducer<List<GalleryItemModel>, AddImagesAction>(updateImagesState),
  TypedReducer<List<GalleryItemModel>, RefreshImagesAction>(refreshImagesState),
]);

@visibleForTesting
List<GalleryItemModel> updateImagesState(
        List<GalleryItemModel> images, AddImagesAction action) =>
    []..addAll(images ?? [])..addAll(action.images);

/// In case of poor connection or if there is no connection at all user can
/// trigger refresh button
/// In that case we need to call list from redux and a little bit to modify URL
/// so that flutter framework recognize change of URL, because if we keep the
/// same url and then refresh the state nothing will happened because this is
/// recognize as same widget without updating the state
@visibleForTesting
List<GalleryItemModel> refreshImagesState(
    List<GalleryItemModel> images, RefreshImagesAction action) {

  if (action.images != null && action.images.isNotEmpty) {
    final List<GalleryItemModel> images =
    action.images.map((image) {
      image.assets['preview'].url =
      'https://image.shutterstock.com/image-photo/image-${image
          .assets['preview'].width}w-${image.id}.jpg';
      return image;
    }).toList();

    return []..addAll(images);
  } else {
    return [];
  }
}

