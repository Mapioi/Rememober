import 'package:flutter/material.dart';

const colors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.black
];

const thicknesses = [
  1.0, 2.0, 3.0, 5.0, 10.0, 15.0, 20.0, 40.0
];

class Stroke {
  final Path path;
  final Paint paint;

  Stroke({@required this.path, @required this.paint});
}

enum Tool { Pen, Highlighter, StrokeEraser, ZoneEraser, StrokeMove, ZoneMove }

Map<Tool,IconData> toolToIcon = {
  Tool.Pen: Icons.edit,
  Tool.Highlighter: Icons.highlight,
  Tool.StrokeEraser: Icons.bug_report,
  Tool.ZoneEraser: Icons.bug_report,
  Tool.StrokeMove: Icons.open_with,
  Tool.ZoneMove: Icons.open_with,
};

final writable = (tool) => tool == Tool.Pen || tool == Tool.Highlighter;

final yellowHighlighterPaint = Paint()
  ..isAntiAlias = true
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.square
  ..strokeJoin = StrokeJoin.round
  ..strokeWidth = 100.0
  ..color = Color.fromRGBO(255, 193, 7, 0.5);

Paint genPenPaint(Color color, double thickness) {
  return Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color
    ..strokeWidth = thickness;
}