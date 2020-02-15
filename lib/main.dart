import 'package:flutter/material.dart';
import 'package:machine_learning_app/face_recognition.dart';
import 'package:machine_learning_app/image_labeling.dart';
import 'package:machine_learning_app/qr_code.dart';
import 'package:machine_learning_app/speech_to_text.dart';
import 'package:machine_learning_app/text_recognition.dart';
import 'object_detection.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Face Recognition App',
        theme: ThemeData(
          primarySwatch: Colors.pink,
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
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.pink, Colors.deepPurple])),
        padding: EdgeInsets.all(40),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Select Scanner : ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 1,
            ),
            RaisedButton(
              color: Colors.lime,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => FaceRecognitionScreen()));
              },
              child: Text('Face Recognition'),
            ),
            RaisedButton(
              color: Colors.lime,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TextRecognitionScreen(
                          isTR: true,
                        )));
              },
              child: Text(
                'Text Recognition',
              ),
            ),
            RaisedButton(
              color: Colors.lime,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TextRecognitionScreen(
                          isTR: false,
                        )));
              },
              child: Text('Barcode Scanner'),
            ),
            RaisedButton(
              color: Colors.lime,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => QRCodeScreen()));
              },
              child: Text('QR Scanner'),
            ),
            RaisedButton(
              color: Colors.lime,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ImageLabelScreen()));
              },
              child: Text('Label Image'),
            ),
            RaisedButton(
              color: Colors.lime,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SpeechToTextScreen()));
              },
              child: Text('Speech to Text'),
            ),
            RaisedButton(
              color: Colors.lime,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ObjectDetection()));
              },
              child: Text('Object Detection'),
            ),
          ],
        ),
      ),
    );
  }
}
