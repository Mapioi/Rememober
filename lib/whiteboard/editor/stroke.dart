import 'package:flutter/material.dart';

class Stroke {
  Path path;
  final Paint paint;

  Stroke({@required this.path, @required this.paint});
}

final yellowHighlighterPaint = Paint()
  ..isAntiAlias = true
  ..style = PaintingStyle.fill
  ..strokeCap = StrokeCap.square
  ..strokeJoin = StrokeJoin.round
  ..strokeWidth = 100.0
  ..color = Color.fromRGBO(255, 193, 7, 0.5);

Paint buildPenPaint(Color color, double thickness) {
  return Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color
    ..strokeWidth = thickness;
}
