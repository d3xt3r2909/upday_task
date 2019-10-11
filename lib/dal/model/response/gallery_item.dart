import 'dart:convert';

/// Model class for gallery response
class GalleryItemModel {
  int id;
  Map<String, GalleryAssetPropertyModel> assets;

  GalleryItemModel(
      {this.id, this.assets});

  /// Get list of json object and convert it to objects
  factory GalleryItemModel.fromJsonApi(Map<String, dynamic> json) {

    final Map<String, GalleryAssetPropertyModel> assetSetter = {};
    assetSetter['preview'] = json['assets.preview'];
    assetSetter['small_thumb'] = json['assets.small_thumb'];
    assetSetter['large_thumb'] = json['assets.large_thumb'];
    assetSetter['huge_thumb'] = json['assets.huge_thumb'];
    assetSetter['preview_1000'] = json['assets.preview_1000'];
    assetSetter['preview_1500'] = json['assets.preview_1500'];

    return GalleryItemModel(
      id: json['id'],
      assets: assetSetter,
    );
  }
  static List<GalleryItemModel> parseGalleryItem(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<GalleryItemModel>(
            (json) => GalleryItemModel.fromJsonApi(json))
        .toList();
  }
}

/// Model class for gallery response
class GalleryAssetPropertyModel {
  int height, width;
  String url;

  GalleryAssetPropertyModel(
      {this.height, this.width, this.url});

  /// Get list of json object and convert it to objects
  factory GalleryAssetPropertyModel.fromJsonApi(Map<String, dynamic> json) =>
      GalleryAssetPropertyModel(
        height: json['height'],
        width: json['width'],
        url: json['url'],
      );

  static List<GalleryAssetPropertyModel> parseGalleryItem(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<GalleryAssetPropertyModel>(
            (json) => GalleryAssetPropertyModel.fromJsonApi(json))
        .toList();
  }
}

