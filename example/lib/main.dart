import 'package:fltbdface_example/face_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fltbdface/fltbdface.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FaceService faceService = FaceService();

  var imageBytes;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  faceService.startFaceLiveness(data: (data) {
                    setState(() {
                      imageBytes = Base64Decoder().convert(data);
                    });
                  }, onFailed: (error) {
                    print(error);
                  });
                },
                child: Text("点击采集人脸"),
              ),
              imageBytes != null ? Image.memory(imageBytes) : Container()
            ],
          ),
        ),
      ),
    );
  }
}
