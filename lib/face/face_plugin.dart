import 'package:flutter/services.dart';

import 'face_config.dart';

class FacePlugin {
  MethodChannel _channel = MethodChannel("plugin.bughub.dev/fltbdface");
  Stream<dynamic> _eventStream =
      EventChannel("plugin.bughub.dev/event").receiveBroadcastStream();

  initialize(
      {String licenseId,
      String licenseFileName,
      Function onSuccess,
      Function onFailed}) {
    _channel.invokeMethod("initialize", {
      "licenseId": licenseId,
      "licenseFileName": licenseFileName
    }).catchError((error) {
      print("initialize:$error");
    });
    _eventStream.listen((value) {
      print(value);
      if (value['event'] == 'initialize' && value['status'] == 0) {
        onSuccess?.call();
      }
    }, onError: (error) {
      onFailed?.call(error);
    });
    return this;
  }

  setFaceConfig(FaceConfig _config) {
    _channel
        .invokeMethod("setFaceConfig", _config.toJson())
        .catchError((error) {
      print("setFaceConfig:$error");
    });
  }

  startFaceLiveness({Function data, Function onFailed}) {
    _channel.invokeMethod("startFaceLiveness").catchError((error) {
      print("startFaceLiveness:$error");
      onFailed.call(error);
    });
    _eventStream.listen((value) {
      if (value['event'] == 'startFaceLiveness') {
        data.call(value['data']);
      }
    }, onError: (error) {
      onFailed.call(error);
    });
  }
}
