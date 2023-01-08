import 'package:flutter/material.dart';
import '../utils/constants.dart';

class Painter extends CustomPainter {
  final List<Offset?> points;

  Painter(this.points);

  final Paint _paint = Paint()
    ..strokeCap = StrokeCap.round
    ..color = Colors.red
    ..strokeWidth = Constants.strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
