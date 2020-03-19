import 'dart:async';

import 'package:flutter/services.dart';

class FltBdFace {
  static const MethodChannel _channel =
      const MethodChannel('fltbdface');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
