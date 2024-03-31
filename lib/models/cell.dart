import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  final Color color;
  final double sideLong;
  const Cell({required this.sideLong, required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sideLong,
      width: sideLong,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color),
      ),
    );
  }
}
