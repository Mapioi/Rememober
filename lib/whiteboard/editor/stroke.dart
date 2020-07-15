import 'package:flutter/material.dart';

class Stroke {
  final Path path;
  final Paint paint;

  Stroke({@required this.path, @required this.paint});
}

final yellowHighlighterPaint = Paint()
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.square
  ..strokeJoin = StrokeJoin.round
  ..strokeWidth = 100.0
  ..color = Color.fromRGBO(255, 193, 7, 0.5);

Paint buildPenPaint(Color color, double thickness) {
  return Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color
    ..strokeWidth = thickness;
}
