import 'package:flutter/material.dart';
import 'package:shutterstock_flutter/pages/gallery/widgets/shimmer_item.dart';

class GalleryShimmerList extends StatelessWidget {

  final Orientation orientation;

  GalleryShimmerList(this.orientation);

  @override
  Widget build(BuildContext context) => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
    ),
    itemCount: 20,
    physics: AlwaysScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) => Card(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GalleryShimmerItem(),
        ),
      ),
    ),
  );
}
