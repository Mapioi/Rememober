import 'package:flutter/material.dart';

class Stroke {
  Path path;
  final Paint paint;

  Stroke({@required this.path, @required this.paint});
}

final yellowHighlighterPaint = Paint()
  ..style = PaintingStyle.fill
  ..color = Color.fromRGBO(255, 193, 7, 0.5);

Paint buildPenPaint(Color color, double thickness) {
  return Paint()
    ..style = PaintingStyle.fill
    ..color = color;
}
