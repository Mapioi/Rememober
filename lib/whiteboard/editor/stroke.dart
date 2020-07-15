import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> offsets;
  final Paint paint;

  Stroke({@required this.offsets, @required this.paint});
}

final yellowHighlighterPaint = Paint()
  ..style = PaintingStyle.fill
  ..color = Color.fromRGBO(255, 193, 7, 0.5);

Paint buildPenPaint(Color color, double thickness) {
  return Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color
    ..strokeWidth = thickness;
}
