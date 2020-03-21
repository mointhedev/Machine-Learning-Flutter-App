import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';

class QRCodeScreen extends StatefulWidget {
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String result = 'Start Scanning QR';

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } catch (e) {
      setState(() {
        result = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
        centerTitle: true,
        backgroundColor: Color(0xff006FA0),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff006FA0), Color(0xff4E006A)])),
        child: Center(
          child: Text(
            result,
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _scanQR,
          icon: Icon(Icons.camera_alt),
          label: Text('Scan')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
