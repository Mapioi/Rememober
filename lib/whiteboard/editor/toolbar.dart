import 'package:flutter/material.dart';

const _penColors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.black,
];
// Must contain defaultPenColor

final Color _defaultPenColor = _penColors.last;

const _penThicknesses = [
  1.0,
  2.0,
  3.0,
  5.0,
  10.0,
  15.0,
  20.0,
  40.0,
];

final double _defaultPenThickness = _penThicknesses[3];

Color _transparentize(Color c) => Color.fromRGBO(c.red, c.green, c.blue, 0.5);

final _highlighterColors = [
  _transparentize(Colors.red),
  _transparentize(Colors.orange),
  _transparentize(Colors.yellow),
  _transparentize(Colors.green),
  _transparentize(Colors.teal),
  _transparentize(Colors.blue),
  _transparentize(Colors.deepPurple),
];

final Color _defaultHighlighterColor = _highlighterColors.first;

const _highlighterThicknesses = [
  20.0,
  40.0,
  60.0,
  80.0,
  100.0,
];

final double _defaultHighlighterThickness = _highlighterThicknesses[2];

const _eraserThicknesses = [
  5.0,
  10.0,
  20.0,
  40.0,
  80.0,
];

final _defaultEraserThickness = _eraserThicknesses[2];

const Map<Tool, List<double>> thicknesses = {
  Tool.Pen: _penThicknesses,
  Tool.Highlighter: _highlighterThicknesses,
  Tool.StrokeEraser: _eraserThicknesses,
  Tool.ZoneEraser: _eraserThicknesses,
};

final Map<Tool, List<Color>> colors = {
  Tool.Pen: _penColors,
  Tool.Highlighter: _highlighterColors,
};

final Map<Tool, double> defaultThicknesses = {
  Tool.Pen: _defaultPenThickness,
  Tool.Highlighter: _defaultHighlighterThickness,
  Tool.ZoneEraser: _defaultEraserThickness,
  Tool.StrokeEraser: _defaultEraserThickness,
};

final Map<Tool, Color> defaultColors = {
  Tool.Pen: _defaultPenColor,
  Tool.Highlighter: _defaultHighlighterColor,
};


enum Tool {
  Pen,
  Highlighter,
  StrokeEraser,
  ZoneEraser,
  StrokeMove,
  ZoneMove,
}

Map<Tool, IconData> toolToIcon = {
  Tool.Pen: Icons.edit,
  Tool.Highlighter: Icons.highlight,
  Tool.StrokeEraser: Icons.bug_report,
  Tool.ZoneEraser: Icons.bug_report,
  Tool.StrokeMove: Icons.open_with,
  Tool.ZoneMove: Icons.open_with,
};

bool isWritable(tool) => tool == Tool.Pen || tool == Tool.Highlighter;

bool isErasable(tool) => tool == Tool.ZoneEraser || tool == Tool.StrokeEraser;

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
          .map((tool) =>
          IconButton(
            icon: Icon(
              toolToIcon[tool],
              color: widget.currentTool == tool
                  ? Colors.lightBlue
                  : Colors.black,
            ),
            onPressed: () =>
                setState(() {
                  widget.onToolChange(tool);
                }),
          ))
          .toList(),
    );
  }
}

class ThicknessDropdown extends StatelessWidget {
  final double thickness;
  final List<double> thicknesses;
  final onChanged;

  ThicknessDropdown({
    @required this.thickness,
    @required this.thicknesses,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<double>(
      value: thickness,
      iconEnabledColor: Colors.black,
      iconDisabledColor: Colors.grey,
      iconSize: 24,
      dropdownColor: Colors.white,
      underline: Container(height: 2, color: Colors.black54),
      onChanged: onChanged,
      items: thicknesses.map((double t) {
        return DropdownMenuItem<double>(
          value: t,
          child: Text("$t px"),
        );
      }).toList(),
    );
  }
}

class ColorDropdown extends StatelessWidget {
  final Color color;
  final List<Color> colors;
  final onChanged;

  const ColorDropdown({
    @required this.color,
    @required this.colors,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Color>(
      value: color,
      iconEnabledColor: Colors.black,
      iconDisabledColor: Colors.grey,
      iconSize: 0,
      dropdownColor: Colors.white,
      underline: Container(
        height: 2,
        color: Colors.black54,
      ),
      onChanged: onChanged,
      items: colors.map((Color e) {
        return DropdownMenuItem<Color>(
          value: e,
          child: Container(height: 3, width: 50, color: e),
        );
      }).toList(),
    );
  }
}
