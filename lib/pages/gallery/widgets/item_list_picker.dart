import 'package:flutter/material.dart';
import 'package:shutterstock_flutter/pages/gallery/widgets/item_list.dart';
import 'package:shutterstock_flutter/pages/gallery/widgets/shimmer_item.dart';

/// Based on parameter [showLoading] we need to decide should we show items
/// that represents loading of images or real item
/// [imageUrl] parameter
class GalleryItemPicker extends StatefulWidget {
  final bool showLoadingItem;
  final String imageUrl;

  GalleryItemPicker({this.showLoadingItem, this.imageUrl});

  @override
  _GalleryItemPickerState createState() => _GalleryItemPickerState();
}

class _GalleryItemPickerState extends State<GalleryItemPicker> {

  @override
  Widget build(BuildContext context) => widget.showLoadingItem
      ? GalleryShimmerItem()
      : GalleryItemList(
          imageUrl: widget.imageUrl,
        );
}
