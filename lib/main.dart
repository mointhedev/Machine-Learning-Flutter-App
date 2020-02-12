import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machine_learning_app/face_recognition.dart';
import 'package:machine_learning_app/text_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Face Recognition App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Learning App'),
      ),
      body: Container(
        padding: EdgeInsets.all(46),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Select Scanner : ',
              style: Theme.of(context).textTheme.title,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => FaceRecognitionScreen()));
              },
              child: Text('Face Recognition'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => TextRecognitionScreen()));
              },
              child: Text('Text Recognition'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Barcode Scanner'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('QR Scanner'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Text to Speech'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Speech to Text'),
            ),
          ],
        ),
      ),
    );
  }
}
