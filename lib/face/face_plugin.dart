import 'package:flutter/services.dart';

import 'face_config.dart';

class FacePlugin {
  MethodChannel _channel = MethodChannel("plugin.bughub.dev/fltbdface");

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
    EventChannel("plugin.bughub.dev/event:init")
        .receiveBroadcastStream()
        .listen((value) {
      print(value);
      if (value['status'] == 0) {
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
    EventChannel("plugin.bughub.dev/event").receiveBroadcastStream().listen(
        (value) {
      data.call(value);
    }, onError: (error) {
      onFailed.call(error);
    });
  }
}
