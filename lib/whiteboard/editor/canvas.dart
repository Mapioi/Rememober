import 'package:flutter/material.dart';
import 'package:Rememober/whiteboard/editor/painter.dart';

class WhiteboardCanvas extends StatelessWidget {
  final strokes;
  final onPanStart;
  final onPanUpdate;
  final onPanEnd;
  final stonkStrokes;

  WhiteboardCanvas({
    @required this.strokes,
    @required this.onPanStart,
    @required this.onPanUpdate,
    @required this.onPanEnd,
    this.stonkStrokes,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: WhiteboardPainter(strokes, stonkStrokes),
      ),
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
    );
  }
}
