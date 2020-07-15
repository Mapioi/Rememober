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
  double _currentThickness = 5.0;
  Color _currentColor = Colors.black;
  Tool _currentTool = Tool.Pen;
  final _strokes = <Stroke>[];

  Paint get _currentPaint {
    if (_currentTool == Tool.Pen) {
      return buildPenPaint(_currentColor, _currentThickness);
    }
    if (_currentTool == Tool.Highlighter) {
      return yellowHighlighterPaint;
    }
    throw ArgumentError("Selected tool is not writable but requests a paint");
  }

  _onPanStart(DragStartDetails details) {
    final localPos = details.localPosition;
    if (isWritable(_currentTool)) {
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
    if (isWritable(_currentTool)) {
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
            thickness: _currentThickness,
            onChanged: (double newValue) {
              setState(() {
                _currentThickness = newValue;
              });
            },
          ),
          Container(width: 10),
          ColorDropdown(
            color: _currentColor,
            onChanged: (Color newColor) {
              setState(() {
                _currentColor = newColor;
              });
            },
          ),
          Container(width: 10),
          ToolBar(
            currentTool: _currentTool,
            onToolChange: (tool) {
              setState(() {
                _currentTool = tool;
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
