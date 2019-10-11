import 'dart:async';

import 'package:upday_task/dal/model/response/gallery_item.dart';

class RequestGetGallery {
  final Completer completer;

  RequestGetGallery({Completer completer})
      : completer = completer ?? Completer();
}

class AddImagesAction {
  final List<GalleryItemModel> images;

  AddImagesAction(this.images);
}