import 'package:flutter/material.dart';
import 'package:Rememober/whiteboard/editor/stroke.dart';

class WhiteboardPainter extends CustomPainter {
  final List<Stroke> strokes;

  WhiteboardPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      canvas.drawPath(stroke.path, stroke.paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
