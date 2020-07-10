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
  Paint _currentPaint;
  final _strokes = <Stroke>[];

  _WhiteboardEditorState() {
    _currentPaint = buildPenPaint(_currentColor, _currentThickness);
  }

  _onPanStart(DragStartDetails details) {
    final localPos = details.localPosition;
    if (isWritable(_currentTool)) {
      final currentPath = Path();
      currentPath.moveTo(localPos.dx, localPos.dy);
      final paint =
          _currentTool == Tool.Pen ? _currentPaint : yellowHighlighterPaint;
      setState(() {
        _strokes.add(Stroke(
          path: currentPath,
          paint: paint,
        ));
      });
    }
  }

  _onPanUpdate(DragUpdateDetails details) {
    final localPos = details.localPosition;
    if (isWritable(_currentTool)) {
      final currentPath = _strokes.last.path;
      setState(() {
        currentPath.lineTo(localPos.dx, localPos.dy);
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
