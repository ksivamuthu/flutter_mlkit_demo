import 'package:flutter/material.dart';
import 'package:flutter_mlkit_demo/barcode.dart';
import 'package:flutter_mlkit_demo/ensure.dart';
import 'package:flutter_mlkit_demo/text.dart';

import 'face.dart';
import 'home.dart';
import 'label.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ensure Mask',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/ensure': (context) => EnsurePage(),
        '/label': (context) => LabelDetectorPage(),
        '/face': (context) => FaceDetectorPage(),
        '/barcode': (context) => BarcodeDetectorPage(),
        '/text': (context) => TextRecognizerPage()
      },
    );
  }
}
