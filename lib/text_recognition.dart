import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognitionScreen extends StatefulWidget {
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

    readText().then((String myText) {
      setState(() {
        imageText = myText;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: pickedImage != null ? uiImage.width.toDouble() : 1.0,
                    height: 350,
                    child: FittedBox(
                      child: pickedImage != null
                          ? Image.file(pickedImage)
                          : Container(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(
                          'Your text',
                          style: Theme.of(context).textTheme.title,
                        ),
                        Text(
                          imageText,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    )),
                  )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        child: Icon(Icons.camera_enhance),
      ),
    );
  }
}
