import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shutterstock_flutter/settings/colors.dart';

class GalleryShimmerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 126.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Theme.of(context).primaryColorLight),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).primaryColor,
              highlightColor: AppColors.galleryShimmer,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      );
}
