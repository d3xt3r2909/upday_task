import 'dart:convert';

import 'package:shutterstock_flutter/dal/model/response/gallery_item.dart';

/// Model class for gallery response
class GalleryWrapperModel {
  int page;
  int imagePerPage;
  int imageTotal;
  List<GalleryItemModel> images;

  GalleryWrapperModel(
      {this.page, this.imagePerPage, this.imageTotal, this.images});

  /// Get list of json object and convert it to objects
  factory GalleryWrapperModel.fromJsonApi(Map<String, dynamic> json) =>
      GalleryWrapperModel(
        page: json['page'],
        imagePerPage: json['per_page'],
        imageTotal: json['total_count'],
        images: (json['data'] != null && '${json['data']}' != '[]')
            // ignore: avoid_as
            ? (json['data'] as List)
                .map((i) => GalleryItemModel.fromJsonApi(i))
                .toList()
            : [],
      );

  static GalleryWrapperModel parseGalleryWrapper(String responseBody) {
    final parsed = json.decode(responseBody);
    return GalleryWrapperModel.fromJsonApi(parsed);
  }
}
