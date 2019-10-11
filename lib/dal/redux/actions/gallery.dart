import 'dart:async';

import 'package:upday_task/dal/model/response/gallery_wrapper.dart';

class GetAndUpdateGallery {
  final GalleryWrapperModel images;
  final Completer completer;

  GetAndUpdateGallery({this.images, Completer completer})
      : completer = completer ?? Completer();
}