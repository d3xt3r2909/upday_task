import 'dart:async';

import 'package:shutterstock_flutter/dal/model/response/gallery_item.dart';

class RequestGetGallery {
  final int page, perPage;
  final Completer completer;

  RequestGetGallery(this.page, this.perPage, {Completer completer})
      : completer = completer ?? Completer();

  String get getPageInString => page.toString();
  String get getPerPageInString => perPage.toString();
}

class AddImagesAction {
  final List<GalleryItemModel> images;

  AddImagesAction(this.images);
}

class RefreshImagesAction {
  final List<GalleryItemModel> images;

  RefreshImagesAction(this.images);
}