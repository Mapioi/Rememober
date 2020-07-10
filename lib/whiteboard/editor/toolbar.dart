import 'package:flutter/material.dart';

const colors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.black,
];

const thicknesses = [
  1.0,
  2.0,
  3.0,
  5.0,
  10.0,
  15.0,
  20.0,
  40.0,
];

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

class ThicknessDropdown extends StatelessWidget {
  final double thickness;
  final onChanged;

  ThicknessDropdown({@required this.thickness, @required this.onChanged});

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
  final onChanged;

  const ColorDropdown({@required this.color, @required this.onChanged});

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
