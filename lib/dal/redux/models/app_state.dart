import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shutterstock_flutter/dal/model/response/gallery_item.dart';

@immutable
class AppState {

  final List<GalleryItemModel> images;

  AppState({this.images});

  factory AppState.init() => AppState();
}
