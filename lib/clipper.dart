import 'package:flutter/widgets.dart';

class BezierClipper extends CustomClipper<Path> {
  BezierClipper();

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height * 0.85); //vertical line
    path.cubicTo(size.width / 3, size.height, 2 * size.width / 3,
        size.height * 0.7, size.width, size.height * 0.85); //cubic curve
    path.lineTo(size.width, 0); //vertical line
    return path;
  }
}
