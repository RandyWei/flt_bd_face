import 'dart:convert';
import 'dart:io';
import 'package:fltbdface/fltbdface.dart';

class FaceService {
  FacePlugin _facePlugin = FacePlugin();

  late String _licenseId;
  late String _licenseFileName;

  FaceService() {
    if (Platform.isIOS) {
      _licenseId = 'pharmacist-license-face-ios'; //百度云后台licenseID
      _licenseFileName = 'idl-license.face-ios'; //放置在ios项目中的license文件
    } else {
      _licenseId = 'pharmacist-license-face-android'; //百度云后台licenseID
      _licenseFileName =
          'idl-license.face-android'; // 位于android/app/src/main/assets下的license文件名称
    }
  }

  startFaceLiveness({required Function data,required Function onFailed}) {
    //初始化插件
    _facePlugin.initialize(
        licenseId: _licenseId, licenseFileName: _licenseFileName);

    //创建插件配置
    FaceConfig _faceConfig = FaceConfig();

    //验证活动动作列表
    List<LivenessType> livenessTypeList = [LivenessType.Eye];
    livenessTypeList.add(LivenessType.Mouth);
    _faceConfig.livenessTypeList = livenessTypeList;
    //设置配置
    _facePlugin.setFaceConfig(_faceConfig);
    //启动人脸采集界面
   _facePlugin.startFaceLiveness(data: data, onFailed: onFailed);
  }
}
