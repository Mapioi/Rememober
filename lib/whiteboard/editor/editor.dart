import 'package:flutter/material.dart';
import 'dart:math';
import 'package:Rememober/whiteboard/editor/canvas.dart';
import 'package:Rememober/whiteboard/editor/stroke.dart';
import 'package:Rememober/whiteboard/editor/toolbar.dart';

class WhiteboardEditor extends StatefulWidget {
  final onExit;

  WhiteboardEditor({@required this.onExit});

  @override
  _WhiteboardEditorState createState() => _WhiteboardEditorState();
}

class _WhiteboardEditorState extends State<WhiteboardEditor> {
  double _currentThickness = 5.0;
  Color _currentColor = Colors.black;
  Tool _currentTool = Tool.Pen;
  Paint _currentPaint;
  Offset _previousPos;
  Offset _previousPerp;

  final _strokes = <Stroke>[];

  _WhiteboardEditorState() {
    _currentPaint = buildPenPaint(_currentColor, _currentThickness);
  }

  _onPanStart(DragStartDetails details) {
    final localPos = details.localPosition;
    if (isWritable(_currentTool)) {
      setState(() {
        _strokes.add(
          Stroke(
            path: Path(),
            paint: _currentPaint,
          ),
        );
        _previousPos = localPos;
      });
    }
  }

  _onPanUpdate(DragUpdateDetails details) {
    final localPos = details.localPosition;
    if (isWritable(_currentTool)) {
      final dv = localPos - _previousPos;
      Offset perp = Offset.fromDirection(dv.direction + pi / 2, 2.5);

      _previousPerp ??= perp;
      final poly = [
        _previousPos + _previousPerp,
        localPos + perp,
        localPos - perp,
        _previousPos - _previousPerp
      ];

      setState(() {
        _strokes.last.path.addPolygon(poly, true);
        _previousPos = localPos;
        _previousPerp = perp;
      });
    } else if (_currentTool == Tool.StrokeEraser) {
      double diag = 1.0; // TODO put somewhere else
      Offset topLeft = Offset(-diag, -diag);
      Offset topRight = Offset(diag, -diag);
      _strokes.forEach((stroke) {
        List<bool> square = [
          localPos + topLeft,
          localPos + topRight,
          localPos - topLeft,
          localPos - topRight
        ].map((offset) => stroke.path.contains(offset)).toList();
        if (square.contains(true) && square.contains(false)) {
          // tf
          setState(() {
            stroke.path.reset();
          });
        }
      });
    } else if (_currentTool == Tool.ZoneEraser) {
      Path eraseZone = Path()
        ..addOval(
          Rect.fromCenter(center: localPos, height: 10, width: 10),
        );
      _strokes.forEach((stroke) {
        setState(() {
          stroke.path = Path.combine(
            PathOperation.difference,
            stroke.path,
            eraseZone,
          );
        });
      });
    }
  }

  _onPanEnd(DragEndDetails details) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: [
          ThicknessDropdown(
            thickness: _currentThickness,
            onChanged: (double newValue) {
              setState(() {
                _currentThickness = newValue;
                _currentPaint = buildPenPaint(_currentColor, _currentThickness);
              });
            },
          ),
          Container(width: 10),
          ColorDropdown(
            color: _currentColor,
            onChanged: (Color e) {
              setState(() {
                _currentColor = e;
                _currentPaint = buildPenPaint(_currentColor, _currentThickness);
              });
            },
          ),
          Container(width: 10),
          ToolBar(
            currentTool: _currentTool,
            onToolChange: (tool) => {setState(() => _currentTool = tool)},
          ),
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: () => setState(() {
              _strokes.clear();
            }),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: widget.onExit,
          ),
        ],
      ),
      body: WhiteboardCanvas(
        strokes: _strokes,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
      ),
    );
  }
}
