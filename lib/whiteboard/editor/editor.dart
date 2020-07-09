import 'package:flutter/material.dart';
import 'package:Rememober/whiteboard/editor/canvas.dart';
import 'package:Rememober/whiteboard/editor/stroke.dart';

class ToolBar extends StatefulWidget {
  final currentTool;
  final onToolChange;

  ToolBar({@required this.currentTool, @required this.onToolChange});

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: toolToIcon.keys
          .map((tool) => IconButton(
                icon: Icon(
                  toolToIcon[tool],
                  color: widget.currentTool == tool
                      ? Colors.lightBlue
                      : Colors.black,
                ),
                onPressed: () => setState(() {
                  widget.onToolChange(tool);
                }),
              ))
          .toList(),
    );
  }
}

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
  Paint _currentPaint = genPenPaint(Colors.black, 5.0);
  final _strokes = <Stroke>[];

  _onPanStart(DragStartDetails details) {
    final localPos = details.localPosition;
    final currentPath = Path();
    currentPath.moveTo(localPos.dx, localPos.dy);
    setState(() {
      if (writable(_currentTool)) {
        _strokes.add(Stroke(
          path: currentPath,
          paint:
              _currentTool == Tool.Pen ? _currentPaint : yellowHighlighterPaint,
        ));
      }
    });
  }

  _onPanUpdate(DragUpdateDetails details) {
    final localPos = details.localPosition;
    final currentPath = _strokes.last.path;
    if (writable(_currentTool)) {
      setState(() {
        currentPath.lineTo(localPos.dx, localPos.dy);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: [
          DropdownButton<double>(
            value: _currentThickness,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.grey,
            iconSize: 24,
            dropdownColor: Colors.white,
            underline: Container(height: 2, color: Colors.black54),
            onChanged: (double newValue) {
              setState(() {
                _currentThickness = newValue;
                _currentPaint = genPenPaint(_currentColor, _currentThickness);
              });
            },
            items: thicknesses.map((double e) {
              return DropdownMenuItem<double>(
                value: e,
                child: Text(e.toInt().toString() + "px"),
              );
            }).toList(),
          ),
          Container(width: 10),
          DropdownButton<Color>(
            value: _currentColor,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.grey,
            iconSize: 0,
            dropdownColor: Colors.white,
            underline: Container(
              height: 2,
              color: Colors.black54,
            ),
            onChanged: (Color e) {
              setState(() {
                _currentColor = e;
                _currentPaint = genPenPaint(_currentColor, _currentThickness);
              });
            },
            items: colors.map((Color e) {
              return DropdownMenuItem<Color>(
                value: e,
                child: Container(height: 3, width: 50, color: e),
              );
            }).toList(),
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
      ),
    );
  }
}
