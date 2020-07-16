import 'dart:math';
import 'package:flutter/material.dart';
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
  Map<Tool, double> _thicknesses = {
    Tool.Pen: defaultThicknesses[Tool.Pen],
    Tool.Highlighter: defaultThicknesses[Tool.Highlighter],
    Tool.ZoneEraser: defaultThicknesses[Tool.ZoneEraser],
    Tool.StrokeEraser: defaultThicknesses[Tool.StrokeEraser],
  };
  Map<Tool, Color> _colors = {
    Tool.Pen: defaultColors[Tool.Pen],
    Tool.Highlighter: defaultColors[Tool.Highlighter],
  };
  Tool _tool = Tool.Pen;
  final _ids = StrokeIdGenerator();
  final _strokes = Map<int, Stroke>();
  int _id;
  Offset _pos0;
  final _stonkStrokes = <Path>[];

  Color get _color => _colors[_tool];

  set _color(Color c) => _colors[_tool] = c;

  double get _thickness => _thicknesses[_tool];

  set _thickness(double t) => _thicknesses[_tool] = t;

  Paint get _currentPaint {
    if (_tool == Tool.Pen) {
      return buildPenPaint(_color, _thickness);
    }
    if (_tool == Tool.Highlighter) {
      return buildHighlighterPaint(_color, _thickness);
    }
    throw ArgumentError("Selected tool is not writable but requests a paint");
  }

  bool isIntersecting(Path path1, Path path2) {
    final inter = Path.combine(PathOperation.intersect, path1, path2);
    final contours = inter.computeMetrics(forceClosed: false);
    return contours.any((contour) => contour.length != 0);
  }

  Path interpolate(Offset o1, Offset o2, double strokeWidth) {
    final dv = o2 - o1;
    final perp = Offset.fromDirection(
      dv.direction + pi / 2,
      strokeWidth / 2,
    );
    final joint = Path()
      ..addPolygon([o1 - perp, o2 - perp, o2 + perp, o1 + perp], false);

    final point = Path()
      ..addOval(Rect.fromCircle(
        center: o2,
        radius: strokeWidth / 2,
      ));
    return Path.combine(PathOperation.union, joint, point);
  }

  erase(Path eraserStroke) {
    setState(() {
      _stonkStrokes.add(eraserStroke);
    });
    final toRemove = <int>[];
    final toAdd = <Stroke>[];
    for (final pair in _strokes.entries) {
      final id = pair.key;
      final stroke = pair.value;
      final paint = stroke.paint;
      final offsets = stroke.offsets;
      var strokeStart = 0;

      for (var i = 1; i < offsets.length; i++) {
        final segment = interpolate(
          offsets[i - 1],
          offsets[i],
          paint.strokeWidth,
        );
        if (isIntersecting(segment, eraserStroke)) {
          if (_tool == Tool.StrokeEraser) {
            toRemove.add(id);
            break;
          }
          if (_tool == Tool.ZoneEraser) {
            toRemove.add(id);
            if (i - strokeStart > 1) {
              toAdd.add(Stroke(
                offsets: offsets.getRange(strokeStart, i).toList(),
                paint: paint,
              ));
            }
            strokeStart = i;
          }
        }
      }
      if (strokeStart != 0 && offsets.length - strokeStart > 1) {
        toAdd.add(Stroke(
          offsets: offsets.getRange(strokeStart, offsets.length).toList(),
          paint: paint,
        ));
      }
    }
    setState(() {
      for (final id in toRemove) {
        _strokes.remove(id);
      }
      for (final stroke in toAdd) {
        _strokes[_ids.generateId()] = stroke;
      }
    });
  }

  _onPanStart(DragStartDetails details) {
    final localPos = details.localPosition;
    if (isWritable(_tool)) {
      _id = _ids.generateId();
      setState(() {
        _strokes[_id] = Stroke(
          offsets: [localPos],
          paint: _currentPaint,
        );
      });
    }
    if (isErasable(_tool)) {
      final eraserStroke = interpolate(localPos, localPos, _thickness);
      erase(eraserStroke);
      _pos0 = localPos;
    }
  }

  _onPanUpdate(DragUpdateDetails details) {
    final localPos = details.localPosition;
    if (isWritable(_tool)) {
      setState(() {
        _strokes[_id].offsets.add(localPos);
      });
    }
    if (isErasable(_tool)) {
      final eraserStroke = interpolate(_pos0, localPos, _thickness);
      erase(eraserStroke);
      _pos0 = localPos;
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
            thickness: _thickness,
            // TODO use provider to clean up this mess
            thicknesses: thicknesses[_tool] ?? [],
            onChanged: thicknesses.containsKey(_tool)
                ? (double newValue) {
                    setState(() {
                      _thickness = newValue;
                    });
                  }
                : null,
          ),
          Container(width: 10),
          ColorDropdown(
            color: _color,
            colors: colors[_tool] ?? [],
            onChanged: colors.containsKey(_tool)
                ? (Color newColor) {
                    setState(() {
                      _color = newColor;
                    });
                  }
                : null,
          ),
          Container(width: 10),
          ToolBar(
            currentTool: _tool,
            onToolChange: (tool) {
              setState(() {
                _tool = tool;
              });
            },
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
        stonkStrokes: _stonkStrokes,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
      ),
    );
  }
}
