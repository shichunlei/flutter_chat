import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../commons/index.dart';

/// 二维码/条形码扫描
class ScanPage extends StatefulWidget {
  @override
  createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool flashState = false;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 5,
                cutOutSize: 300)),
        Positioned(
            child: Container(
                height: Utils.navigationBarHeight,
                child: AppBar(backgroundColor: Colors.transparent))),
        Positioned(
            child: Container(
                alignment: Alignment.center,
                child: Text('请将二维码置于方框中',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))),
            top: Utils.navigationBarHeight + 20,
            left: 0,
            right: 0),
        Positioned(
            child: IconButton(
                icon: Image.asset(
                    flashState
                        ? 'images/tool_flashlight_open.png'
                        : 'images/tool_flashlight_close.png',
                    color: Colors.white),
                onPressed: () {
                  if (controller != null) {
                    controller.toggleFlash();
                    setState(() => flashState = !flashState);
                  }
                }),
            left: 0,
            right: 0,
            bottom: 180)
      ]),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((String scanData) {
      if (null != scanData) {
        controller.pauseCamera();
      }

      Navigator.maybePop(qrKey.currentContext, scanData);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
