import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final Color? color;
  final double? borderRadius;
  const MainButton({
    super.key,
    this.onPressed,
    required this.child,
    this.color,
    this.height,
    this.borderRadius,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: height ?? size.height / 8,
      width: width ?? size.width / 3,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(color),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ))),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
