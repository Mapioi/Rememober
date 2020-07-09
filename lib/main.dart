import 'package:flutter/material.dart';
import 'package:Rememober/whiteboard/editor/editor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TITLE"),
      ),
      body: WhiteboardEditor(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("Pressed"),
        tooltip: 'Test',
        child: Icon(Icons.help),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
