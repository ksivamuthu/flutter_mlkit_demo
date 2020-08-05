import 'dart:io';

import 'package:flutter/material.dart';
import './clipper.dart';
import 'models/demo.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [headerWidget(), new Expanded(child: getBuiltInDetections())],
      ),
    );
  }

  Widget headerWidget() {
    final double height = MediaQuery.of(context).size.height * 0.2;
    return Stack(
      children: [
        ClipPath(
          clipper: BezierClipper(),
          child: Container(
            color: Colors.deepPurple,
            height: height,
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 75),
            child: Text(
              "Flutter + MLKit Demo",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
        ),
      ],
    );
  }

  Widget getBuiltInDetections() {
    var demos = <Demo>[];
    demos.add(Demo("Label Detection", "", "/label"));
    demos.add(Demo("Face Detection", "", "/face"));
    demos.add(Demo("Barcode Scanner", "", "/barcode"));
    demos.add(Demo("Text Recognizer", "", "/text"));
    demos.add(Demo("Ensure Face Mask", "Custom Model", "/ensure"));

    return ListView.builder(
      itemCount: demos.length,
      itemBuilder: (context, i) => buildListItem(demos[i]),
    );
  }

  Widget buildListItem(Demo demo) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(demo.path);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Card(
          shadowColor: Colors.grey,
          child: ListTile(
            title: Text(demo.title, style: TextStyle(fontSize: 21)),
            subtitle: Text(demo.subtitle),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ),
    );
  }
}
