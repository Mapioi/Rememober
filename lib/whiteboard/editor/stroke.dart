import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> offsets;
  final Paint paint;

  Stroke({@required this.offsets, @required this.paint});
}

class StrokeIdGenerator {
  var _count = 0;

  int generateId() => _count++;
}

Paint buildHighlighterPaint(Color color, double thickness) {
  return Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = thickness
    ..color = color;
}

Paint buildPenPaint(Color color, double thickness) {
  return Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color
    ..strokeWidth = thickness;
}

bool isHighlighterPaint(Paint paint) {
  return paint.style == PaintingStyle.fill;
}
