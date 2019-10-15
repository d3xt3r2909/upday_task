import 'package:flutter/material.dart';

/// Based on parameter [isVisible] we will show this widget or we will not
class VisibilityWidget extends StatelessWidget {
  final Widget child;
  final bool isVisible;

  VisibilityWidget({@required this.isVisible, this.child});

  @override
  Widget build(BuildContext context) => isVisible
      ? child
      : Container(
          width: 0,
          height: 0,
        );
}
