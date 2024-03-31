import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {
  double value;
  CustomClipPath({
    required this.value,
  });

  @override
  Path getClip(Size size) {
    // print(value.toString() + "-------");
    final path = Path();
    print(size);
    path.addRect(Rect.fromCircle(center: const Offset(0, 0), radius: 5000 * value));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
