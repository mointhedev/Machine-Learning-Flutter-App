import 'package:flutter/material.dart';
import 'package:machine_learning_app/face_recognition.dart';
import 'package:machine_learning_app/image_labeling.dart';
import 'package:machine_learning_app/qr_code.dart';
import 'package:machine_learning_app/speech_to_text.dart';
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TextRecognitionScreen(
                          isTR: true,
                        )));
              },
              child: Text('Text Recognition'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => TextRecognitionScreen(
                          isTR: false,
                        )));
              },
              child: Text('Barcode Scanner'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => QRCodeScreen()));
              },
              child: Text('QR Scanner'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ImageLabelScreen()));
              },
              child: Text('Label Image'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SpeechToTextScreen()));
              },
              child: Text('Speech to Text'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SpeechToTextScreen()));
              },
              child: Text('Object Detection'),
            ),
          ],
        ),
      ),
    );
  }
}
