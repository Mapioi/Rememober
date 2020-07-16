import 'dart:math';
import 'package:flutter/material.dart';
import 'package:Rememober/whiteboard/editor/stroke.dart';

class WhiteboardPainter extends CustomPainter {
  final Map<int, Stroke> strokes;

  WhiteboardPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes.values) {
      final offsets = stroke.offsets;
      if (isHighlighterPaint(stroke.paint)) {
        var path = Path();
        if (offsets.length > 1) {
          final dv = offsets[1] - offsets[0];
          final perp = Offset.fromDirection(
            dv.direction + pi / 2,
            stroke.paint.strokeWidth / 2,
          );
          var leftPos = offsets[0] - perp;
          var rightPos = offsets[0] + perp;
          for (var i = 1; i < offsets.length; i++) {
            final dv = offsets[i] - offsets[i - 1];
            final leftPos2 = leftPos + dv;
            final rightPos2 = rightPos + dv;
            final joint = Path()
              ..addPolygon(
                [
                  leftPos,
                  leftPos2,
                  rightPos2,
                  rightPos,
                ],
                false,
              );
            path = Path.combine(
              PathOperation.union,
              path,
              joint,
            );
            leftPos = leftPos2;
            rightPos = rightPos2;
          }
          canvas.drawPath(path, stroke.paint);
        }
      } else {
        if (offsets.length == 1) {
          canvas.drawCircle(
            offsets[0],
            0,
            stroke.paint,
          );
        } else {
          for (var i = 1; i < offsets.length; i++) {
            canvas.drawLine(
              offsets[i - 1],
              offsets[i],
              stroke.paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
