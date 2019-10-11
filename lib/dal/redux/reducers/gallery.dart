import 'package:redux/redux.dart';
import 'package:upday_task/dal/model/response/gallery_item.dart';
import 'package:upday_task/dal/redux/actions/gallery.dart';

final galleryReducer = combineReducers<List<GalleryItemModel>>([
  TypedReducer<List<GalleryItemModel>, AddImagesAction>(_updateImagesState),
]);

List<GalleryItemModel> _updateImagesState(
        List<GalleryItemModel> images, AddImagesAction action) =>
    []..addAll(images ?? [])..addAll(action.images);
