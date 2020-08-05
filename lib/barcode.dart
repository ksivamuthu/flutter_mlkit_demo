// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'detector_painters.dart';

class BarcodeDetectorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BarcodeDetectorPageState();
}

class _BarcodeDetectorPageState extends State<BarcodeDetectorPage> {
  final ImagePicker picker = ImagePicker();
  PickedFile _imageFile;
  Size _imageSize;
  dynamic _scanResults;
  final BarcodeDetector _barcodeDetector =
      FirebaseVision.instance.barcodeDetector();

  Future<void> _getAndScanImage() async {
    setState(() {
      _imageFile = null;
      _imageSize = null;
    });

    final PickedFile imageFile =
        await picker.getImage(source: ImageSource.gallery);

    if (imageFile != null) {
      _getImageSize(imageFile);
      _scanImage(imageFile);
    }

    setState(() {
      _imageFile = imageFile;
    });
  }

  Future<void> _getImageSize(PickedFile imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(File(imageFile.path));
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  Future<void> _scanImage(PickedFile imageFile) async {
    setState(() {
      _scanResults = null;
    });

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(imageFile.path));

    dynamic results = await _barcodeDetector.detectInImage(visionImage);

    setState(() {
      _scanResults = results;
    });
  }

  Widget _buildResults(dynamic results) {
    if (_scanResults == null) return Text("Scanning");
    return new Expanded(
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, i) => buildListItem(results[i]),
      ),
    );
  }

  Widget buildListItem(Barcode label) {
    return ListTile(
      title: Text(label.displayValue),
      subtitle: Text(label.valueType.toString()),
    );
  }

  Widget _buildImage() {
    return Image.file(File(_imageFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Detection'),
      ),
      body: _imageFile == null
          ? const Center(child: Text('No image selected.'))
          : new Column(children: [_buildImage(), _buildResults(_scanResults)]),
      floatingActionButton: FloatingActionButton(
        onPressed: _getAndScanImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  @override
  void dispose() {
    _barcodeDetector.close();
    super.dispose();
  }
}
