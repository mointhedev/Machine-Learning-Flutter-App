import 'package:flutter/material.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

class SpeechToTextScreen extends StatefulWidget {
  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text'),
        centerTitle: true,
        backgroundColor: Color(0xff006FA0),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff006FA0), Color(0xff4E006A)])),
        child: _hasSpeech
            ? Column(children: [
                Expanded(
                  child: Center(
                    child: Text(' '),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.purpleAccent,
                        mini: true,
                        child: Text('Stop'),
                        onPressed: stopListening,
                      ),
                      FloatingActionButton(
                        child: Text('Start'),
                        onPressed: startListening,
                      ),
                      FloatingActionButton(
                        backgroundColor: Colors.deepOrange,
                        mini: true,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: FittedBox(child: Text('Cancel')),
                        ),
                        onPressed: cancelListening,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Recognized Words',
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            lastWords,
                            style: TextStyle(color: Colors.yellowAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(''),
                      ),
                      Center(
                        child: Text(
                          lastError,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: speech.isListening
                        ? Text(
                            "I'm listening...",
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(color: Colors.white),
                          )
                        : Text(
                            'Not listening',
                            style: Theme.of(context)
                                .textTheme
                                .title
                                .copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ])
            : Center(
                child: Text('Speech recognition unavailable',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
      ),
    );
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(onResult: resultListener);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {});
  }

  void cancelListening() {
    speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    setState(() {
      lastStatus = "$status";
    });
  }
}
