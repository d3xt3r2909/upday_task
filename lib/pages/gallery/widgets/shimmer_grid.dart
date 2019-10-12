import 'package:flutter/material.dart';
import 'package:upday_task/pages/gallery/widgets/shimmer_item.dart';

class JourneyShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          // hide topButtons
          //_buildTopShimmerButtons(context),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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
            ),
          ),
        ],
      );
}
