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
    final screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + AppBar().preferredSize.height);
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Labeling'),
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                          child: Column(
                        children: <Widget>[
                          Text(
                            'Labels',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                              children: imageLabels != null &&
                                      imageLabels.isNotEmpty
                                  ? imageLabels.map((imageLabel) {
                                      return Container(
                                          height: 100,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          color: Colors.white.withOpacity(0.7),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            children: <Widget>[
                                              ListTile(
                                                title: Text(
                                                  imageLabel.text,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 17),
                                                ),
                                                subtitle: Text(
                                                    '${(imageLabel.confidence * 100).round()}%',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 15)),
                                              ),
                                              Divider(
                                                color: Colors.black87,
                                              )
                                            ],
                                          ));
                                    }).toList()
                                  : [Container()]),
                          SizedBox(
                            height: 20,
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
