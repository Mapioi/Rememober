import 'package:flutter/material.dart';
import 'package:Rememober/whiteboard/editor/canvas.dart';
import 'package:Rememober/whiteboard/editor/stroke.dart';

class WhiteboardEditor extends StatefulWidget {
  final onExit;

  WhiteboardEditor({@required this.onExit});

  @override
  _WhiteboardEditorState createState() => _WhiteboardEditorState();
}

class _WhiteboardEditorState extends State<WhiteboardEditor> {
  Paint _currentPaint = blackPenPaint;
  final _strokes = <Stroke>[];

  _onPanStart(DragStartDetails details) {
    final localPos = details.localPosition;
    final currentPath = Path();
    currentPath.moveTo(localPos.dx, localPos.dy);
    setState(() {
      _strokes.add(Stroke(
        path: currentPath,
        paint: _currentPaint,
      ));
    });
  }

  _onPanUpdate(DragUpdateDetails details) {
    final localPos = details.localPosition;
    final currentPath = _strokes.last.path;
    setState(() {
      currentPath.lineTo(localPos.dx, localPos.dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: widget.onExit,
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
            onPressed: () => setState(() {
              _currentPaint = blackPenPaint;
            }),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.red,
            ),
            onPressed: () => setState(() {
              _currentPaint = redPenPaint;
            }),
          ),
          IconButton(
            icon: Icon(
              Icons.highlight,
              color: Colors.yellow,
            ),
            onPressed: () => setState(() {
              _currentPaint = yellowHighlighterPaint;
            }),
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
