import 'package:flutter/material.dart';
import 'package:upday_task/pages/gallery/widgets/item_list.dart';
import 'package:upday_task/pages/gallery/widgets/shimmer_item.dart';

/// Based on parameter [showLoading] we need to decide should we show items
/// that represents loading of images or real item
/// [imageUrl] parameter
class GalleryItemPicker extends StatelessWidget {
  final bool showLoadingItem;
  final String imageUrl;

  GalleryItemPicker({this.showLoadingItem, this.imageUrl});

  @override
  Widget build(BuildContext context) => showLoadingItem
      ? GalleryShimmerItem()
      : GalleryItemList(
          imageUrl: imageUrl,
        );
}
