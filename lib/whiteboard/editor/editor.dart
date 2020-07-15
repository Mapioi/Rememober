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
    Tool.Pen: defaultPenThickness,
    Tool.Highlighter: defaultHighlighterThickness,
  };
  Map<Tool, Color> _colors = {
    Tool.Pen: defaultPenColor,
    Tool.Highlighter: defaultHighlighterColor,
  };
  Tool _tool = Tool.Pen;
  final _strokes = <Stroke>[];

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

  _onPanStart(DragStartDetails details) {
    final localPos = details.localPosition;
    if (isWritable(_tool)) {
      setState(() {
        _strokes.add(Stroke(
          offsets: [localPos],
          paint: _currentPaint,
        ));
      });
    }
  }

  _onPanUpdate(DragUpdateDetails details) {
    final localPos = details.localPosition;
    if (isWritable(_tool)) {
      setState(() {
        _strokes.last.offsets.add(localPos);
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
            thickness: _thickness,
            // TODO use provider to clean up this mess
            thicknesses:
                _tool == Tool.Pen ? penThicknesses : highlighterThicknesses,
            onChanged: (double newValue) {
              setState(() {
                _thickness = newValue;
              });
            },
          ),
          Container(width: 10),
          ColorDropdown(
            color: _color,
            colors: _tool == Tool.Pen ? penColors : highlighterColors,
            onChanged: (Color newColor) {
              setState(() {
                _color = newColor;
              });
            },
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
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
      ),
    );
  }
}
