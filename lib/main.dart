import 'package:flutter/cupertino.dart';
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
        title: 'Machine Learning App',
        theme: ThemeData(accentColor: Colors.deepPurpleAccent),
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + AppBar().preferredSize.height);
    return Scaffold(
      appBar: AppBar(
        title: Text('Machine Learning App'),
        centerTitle: true,
        backgroundColor: Color(0xff5A009F),
        //elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff5A009F), Color(0xff03004E)])),
          padding: EdgeInsets.all(30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Select Scanner : ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/tools.png',
                    height: 30,
                    fit: BoxFit.fitHeight,
                  )
                ],
              ),
              SizedBox(
                height: 1,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => FaceRecognitionScreen()));
                },
                child: Image.asset(
                  'assets/Group 14.png',
                  width: 240,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => TextRecognitionScreen(
                            isTR: true,
                          )));
                },
                child: Image.asset(
                  'assets/Group 10.png',
                  width: 240,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ImageLabelScreen()));
                },
                child: Image.asset(
                  'assets/Group 15.png',
                  width: 240,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => QRCodeScreen()));
                },
                child: Image.asset(
                  'assets/Group 16.png',
                  width: 240,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SpeechToTextScreen()));
                },
                child: Image.asset(
                  'assets/Group 17.png',
                  width: 240,
                ),
              ),
              InkWell(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ObjectDetection()));
                  },
                  child: Image.asset(
                    'assets/Group 18.png',
                    width: 240,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
