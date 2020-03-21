import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

const String ssd = 'SSD MobileNet';
const String yolo = 'Tiny YOLOv2';

class ObjectDetection extends StatefulWidget {
  @override
  _ObjectDetectionState createState() => _ObjectDetectionState();
}

class _ObjectDetectionState extends State<ObjectDetection> {
  String _model = yolo;

  File _image;

  double _imageWidth;
  double _imageHeight;
  bool _busy = false;

  List _recognitions;

  @override
  initState() {
    super.initState();
    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      if (_model == yolo) {
        res = await Tflite.loadModel(
            model: "assets/tflite/yolov2_tiny.tflite",
            labels: "assets/tflite/yolov2_tiny.txt");
      } else {
        res = await Tflite.loadModel(
            model: "assets/tflite/ssd_mobilenet.tflite",
            labels: "assets/tflite/ssd_mobilenet.txt");
      }
      print(res);
    } on PlatformException {
      print('Failed to load the model');
    }
  }

  selectFromImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _busy = true;
    });

    predictImage(image);
  }

  predictImage(File image) async {
    if (image == null) return;

    if (_model == yolo) {
      await yolov2Tiny(image);
    } else {
      await ssdMobileNet(image);
    }

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageWidth = info.image.width.toDouble();
        _imageHeight = info.image.height.toDouble();
      });
    }));

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  yolov2Tiny(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,
        model: "YOLO",
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 255.0,
        numResultsPerClass: 1);

    setState(() {
      _recognitions = recognitions;
    });
  }

  ssdMobileNet(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path, numResultsPerClass: 1);

    setState(() {
      _recognitions = recognitions;
    });
  }

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];

    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;

    Color blue = Colors.blue;

    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["x"] * factorX,
        height: re["rect"]["x"] * factorY,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: blue,
            width: 3,
          )),
          child: Text(
            '${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%',
            style: TextStyle(
                background: Paint()..color = blue,
                color: Colors.white,
                fontSize: 15),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + AppBar().preferredSize.height);
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Container(
      height: screenHeight * 0.5,
      width: double.infinity,
      color: Color(0xffDEEDFF).withOpacity(0.64),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: _image == null
          ? Center(
              child: Icon(
                Icons.image,
                size: 70,
              ),
            )
          : Image.file(_image),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(Container(
        height: screenHeight * 0.5,
        width: double.infinity,
        color: Color(0xffDEEDFF).withOpacity(0.64),
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detector'),
        centerTitle: true,
        backgroundColor: Color(0xff006FA0),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_photo_alternate),
        tooltip: 'Pick image from gallery',
        onPressed: selectFromImagePicker,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff006FA0), Color(0xff4E006A)])),
          child: Stack(
            children: stackChildren,
          ),
        ),
      ),
    );
  }
}
