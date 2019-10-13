import 'package:flutter/material.dart';

class GalleryItemList extends StatelessWidget {
  final String imageUrl;

  GalleryItemList({this.imageUrl});

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/upday_logo.png',
              image: imageUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
}
