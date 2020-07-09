import 'package:flutter/material.dart';

class Stroke {
  final Path path;
  final Paint paint;

  Stroke({@required this.path, @required this.paint});
}

final blackPenPaint = Paint()
  ..isAntiAlias = true
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..strokeWidth = 10.0
  ..color = Colors.black;

final redPenPaint = Paint()
  ..isAntiAlias = true
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..strokeWidth = 10.0
  ..color = Colors.red;

final yellowHighlighterPaint = Paint()
  ..isAntiAlias = true
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.square
  ..strokeJoin = StrokeJoin.round
  ..strokeWidth = 100.0
  ..color = Color.fromRGBO(255, 193, 7, 0.5);
