import 'package:flutter/material.dart';

class Apple extends StatelessWidget {
  Offset applePosition;
  final lengthSquareSide;
  final topPadding;
  final bottomPadding;
  Apple({
    super.key,
    required this.lengthSquareSide,
    required this.applePosition,
    required this.topPadding,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: lengthSquareSide * applePosition.dy,
      left: lengthSquareSide * applePosition.dx,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: SizedBox(
          height: lengthSquareSide,
          width: lengthSquareSide,
          child: Image.asset("assets/images/apple.png"),
        ),
      ),
    );
  }
}
