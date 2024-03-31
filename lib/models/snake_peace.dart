import 'package:flutter/material.dart';

class SnakePeace extends StatelessWidget {
  AnimationController animationController;
  double lengthSquareSide;
  Offset beginPosition;
  Offset endPosition;
  int index;
  String direction;
  Color color;
  SnakePeace({
    super.key,
    required this.animationController,
    required this.lengthSquareSide,
    required this.beginPosition,
    required this.endPosition,
    required this.index,
    required this.direction,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween(begin: beginPosition, end: endPosition)
          .animate(animationController),
      child: SizedBox(
        height: lengthSquareSide,
        width: lengthSquareSide,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color),
        ),
      ),
    );
  }

  SnakePeace changeDirection({String? direction}) {
    Offset beginPosition = this.endPosition;
    Offset endPosition;
    if (direction == 'R') {
      endPosition = Offset(
        this.endPosition.dx + 1,
        this.endPosition.dy,
      );
    } else if (direction == 'L') {
      endPosition = Offset(
        this.endPosition.dx - 1,
        this.endPosition.dy,
      );
    } else if (direction == 'U') {
      endPosition = Offset(
        this.endPosition.dx,
        this.endPosition.dy - 1,
      );
    } else {
      endPosition = Offset(
        this.endPosition.dx,
        this.endPosition.dy + 1,
      );
    }
    return copyWith(
      beginPosition: beginPosition,
      endPosition: endPosition,
      direction: direction,
    );
  }

  SnakePeace copyWith({
    AnimationController? animationController,
    double? lengthSquareSide,
    Offset? beginPosition,
    Offset? endPosition,
    int? index,
    String? direction,
    Color? color,
  }) {
    return SnakePeace(
      animationController: animationController ?? this.animationController,
      lengthSquareSide: lengthSquareSide ?? this.lengthSquareSide,
      beginPosition: beginPosition ?? this.beginPosition,
      endPosition: endPosition ?? this.endPosition,
      index: index ?? this.index,
      direction: direction ?? this.direction,
      color: color ?? this.color,
    );
  }
}
