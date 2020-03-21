import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:image_picker/image_picker.dart';

class FaceRecognitionScreen extends StatefulWidget {
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  ui.Image image;
  List<Rect> rect = new List<Rect>();

  bool _isloading = false;

  Future<ui.Image> loadImage(File image) async {
    var img = await image.readAsBytesSync();
    return await decodeImageFromList(img);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _isloading = true;
      rect = List<Rect>();
    });
    var visionImage = FirebaseVisionImage.fromFile(image);
    var faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(visionImage);

    for (Face face in faces) {
      rect.add(face.boundingBox);
    }

    loadImage(image).then((img) {
      setState(() {
        _isloading = false;
        this.image = img;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + AppBar().preferredSize.height);
    return Scaffold(
        appBar: AppBar(
          title: Text("Face Recognition"),
          centerTitle: true,
          backgroundColor: Color(0xff006FA0),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          child: Icon(Icons.camera_enhance),
        ),
        body: Container(
          height: screenHeight,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff006FA0), Color(0xff4E006A)])),
          child: Column(
            children: <Widget>[
              Container(
                height: screenHeight * 0.5,
                width: double.infinity,
                color: Color(0xffDEEDFF).withOpacity(0.64),
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                child: !_isloading
                    ? image == null
                        ? Center(
                            child: Icon(
                              Icons.image,
                              size: 70,
                            ),
                          )
                        : FittedBox(
                            child: SizedBox(
                            width: image != null ? image.width.toDouble() : 1.0,
                            height:
                                image != null ? image.height.toDouble() : 1.0,
                            child: CustomPaint(
                              painter: Painter(rect: rect, image: image),
                            ),
                          ))
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class Painter extends CustomPainter {
  List<Rect> rect;
  ui.Image image;

  Painter({this.rect, this.image});

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    if (image != null) canvas.drawImage(image, Offset.zero, Paint());
    //rect = [rect[0]];
    for (Rect rect in this.rect) {
      canvas.drawRect(
          rect,
          Paint()
            ..color = Colors.amberAccent
            ..strokeWidth = 5.0
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
