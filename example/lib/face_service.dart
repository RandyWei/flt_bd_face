import 'dart:convert';
import 'dart:io';
import 'package:fltbdface/fltbdface.dart';

class FaceService {
  FacePlugin _facePlugin = FacePlugin();

  String _licenseId;
  String _licenseFileName;

  FaceService() {
    if (Platform.isIOS) {
      _licenseId = 'food-license-face-ios';
      _licenseFileName = 'idl-license.face-ios';
    } else {
      _licenseId = 'food-license-face-android';
      _licenseFileName = 'idl-license.face-android';
    }
  }

  startFaceLiveness({bool withMouth, Function data, Function onFailed}) {
    _facePlugin.initialize(
        licenseId: _licenseId, licenseFileName: _licenseFileName);
    FaceConfig _faceConfig = FaceConfig();

    List<LivenessType> livenessTypeList = [LivenessType.Eye];

    if (withMouth) {
      livenessTypeList.add(LivenessType.Mouth);
    }

    _faceConfig.livenessTypeList = livenessTypeList;
    _facePlugin.setFaceConfig(_faceConfig);
    _facePlugin.startFaceLiveness(data: data, onFailed: onFailed);
  }

}
