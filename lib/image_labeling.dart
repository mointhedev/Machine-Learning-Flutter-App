import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabelScreen extends StatefulWidget {
  ImageLabelScreen();

  @override
  _ImageLabelScreenState createState() => _ImageLabelScreenState();
}

class _ImageLabelScreenState extends State<ImageLabelScreen> {
  File pickedImage;

  bool isLoading = false;

  List<ImageLabel> imageLabels = [];

  ui.Image uiImage;

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      isLoading = true;
      pickedImage = tempStore;
    });

    ui.Image decodedImage =
        await decodeImageFromList(pickedImage.readAsBytesSync());

    setState(() {
      uiImage = decodedImage;
      isLoading = false;
    });

    readText().then((List<ImageLabel> myLabels) {
      setState(() {
        this.imageLabels = List.from(myLabels);
      });
    });
  }

  Future<List<ImageLabel>> readText() async {
    setState(() {
      this.imageLabels = new List<ImageLabel>();
    });

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(pickedImage);
    ImageLabeler imageLabeler = FirebaseVision.instance.imageLabeler();
    List<ImageLabel> imageLabels = await imageLabeler.processImage(visionImage);

    return imageLabels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Labeling'),
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
                          'Labels',
                          style: Theme.of(context).textTheme.title,
                        ),
                        Column(
                            children:
                                imageLabels != null && imageLabels.isNotEmpty
                                    ? imageLabels.map((imageLabel) {
                                        return Container(
                                            height: 100,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(imageLabel.text),
                                                  subtitle: Text(
                                                      '${(imageLabel.confidence * 100).round()}%'),
                                                )
                                              ],
                                            ));
                                      }).toList()
                                    : [Container()])
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
