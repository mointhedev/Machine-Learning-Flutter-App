import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognitionScreen extends StatefulWidget {
  bool isTR;

  TextRecognitionScreen({this.isTR});

  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  File pickedImage;

  bool isLoading = false;

  String imageText = '';

  ui.Image uiImage;

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageText = '';
      isLoading = true;
      pickedImage = tempStore;
    });

    ui.Image decodedImage =
        await decodeImageFromList(pickedImage.readAsBytesSync());

    setState(() {
      uiImage = decodedImage;
      isLoading = false;
    });

    widget.isTR
        ? readText().then((String myText) {
            setState(() {
              imageText = myText;
            });
          })
        : readBarcode().then((mycode) {
            setState(() {
              setState(() {
                imageText = mycode;
              });
            });
          });
  }

  Future<String> readText() async {
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizedText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizedText.processImage(visionImage);

    String tempImageText = '';

    for (TextBlock block in readText.blocks) {
//      tempImageText = tempImageText +
//          ''
//              '';
      for (TextLine line in block.lines) {
        tempImageText = tempImageText + '\n';
        for (TextElement word in line.elements) {
          tempImageText = tempImageText + word.text;
          tempImageText = tempImageText + ' ';
        }
      }
    }

    return tempImageText;
  }

  Future<String> readBarcode() async {
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barcodes = await barcodeDetector.detectInImage(visionImage);

    String tempImageText = '';

    for (Barcode code in barcodes) {
      tempImageText = code.displayValue;
    }

    return tempImageText;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + AppBar().preferredSize.height);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isTR ? 'Text Recognition' : 'Barcode Scanner'),
        centerTitle: true,
        backgroundColor: Color(0xff006FA0),
      ),
      body: Container(
        height: screenHeight,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff006FA0), Color(0xff4E006A)])),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: screenHeight * 0.4,
                      width: double.infinity,
                      color: Color(0xffDEEDFF).withOpacity(0.64),
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      child: FittedBox(
                        child: pickedImage != null
                            ? Image.file(pickedImage)
                            : Container(
                                height: 10,
                                width: 10,
                                child: Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 3,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Center(
                          child: Column(
                        children: <Widget>[
                          Text(
                            widget.isTR ? 'Text' : 'Your Code',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          Container(
                            height: screenHeight * 0.4,
                            width: double.infinity,
                            color: Colors.white,
                            margin: EdgeInsets.all(16),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                imageText,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      )),
                    )
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        child: Icon(Icons.camera_enhance),
      ),
    );
  }
}
