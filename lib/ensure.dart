import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class EnsurePage extends StatefulWidget {
  EnsurePage({Key key}) : super(key: key);

  @override
  _EnsurePageState createState() => _EnsurePageState();
}

class _EnsurePageState extends State<EnsurePage> {
  File _image;
  bool loading = false;
  bool mask = false;
  final picker = ImagePicker();

  Future getImage() async {
    setState(() {
      _image = null;
      mask = false;
    });
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    await classifyImage();
  }

  Future classifyImage() async {
    setState(() {
      loading = true;
    });
    await loadModel();
    var recog = await Tflite.runModelOnImage(
      path: _image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (recog != null && recog.length > 0) {
      var data = recog[0]["label"];
      setState(() {
        mask = data == "mask" ? true : false;
      });
    }

    setState(() {
      loading = false;
    });
  }

  Future loadModel() async {
    await Tflite.loadModel(
      numThreads: 1,
      model: "assets/models/model.tflite",
      labels: "assets/models/dict.txt",
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });

    loadModel().then(
      (value) => (setState(() {
        loading = false;
      })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ensure Mask"),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Card(
                  child: _image != null
                      ? Image.file(_image)
                      : Container(color: Colors.grey, height: 250),
                ),
                SizedBox(height: 20),
                _image != null ? resultWidget() : Container()
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget resultWidget() {
    if (loading) return CircularProgressIndicator();
    return Chip(
      labelPadding: EdgeInsets.all(10),
      backgroundColor: mask ? Colors.greenAccent[700] : Colors.redAccent,
      label: Text(
        mask ? "Mask" : "No Mask",
        style: TextStyle(fontSize: 25, color: Colors.white),
      ),
    );
  }
}
