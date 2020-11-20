import 'face_environment.dart';
import 'liveness_type_enum.dart';

class FaceConfig {
  /// 图像光照阀值
  var brightnessValue = FaceEnvironment.VALUE_BRIGHTNESS;

  /// 图像模糊阀值
  var blurnessValue = FaceEnvironment.VALUE_BLURNESS;

  /// 图像中人脸遮挡阀值
  var occlusionValue = FaceEnvironment.VALUE_OCCLUSION;

  /// 图像中人脸抬头低头角度阀值
  var headPitchValue = FaceEnvironment.VALUE_HEAD_PITCH;

  /// 图像中人脸左右角度阀值
  var headYawValue = FaceEnvironment.VALUE_HEAD_YAW;

  /// 图像中人脸偏头阀值
  var headRollValue = FaceEnvironment.VALUE_HEAD_ROLL;

  /// 抠图高的设定，为了保证好的抠图效果，我们要求高宽比是4：3，所以会在内部进行计算，只需要传入高即可
  var cropHeight = FaceEnvironment.VALUE_CROP_HEIGHT;

  /// 图像能被检测出人脸的最小人脸值
  var minFaceSize = FaceEnvironment.VALUE_MIN_FACE_SIZE;

  /// 图像能被检测出人脸阀值
  var notFaceValue = FaceEnvironment.VALUE_NOT_FACE_THRESHOLD;

  /// 是否开启提示音
  var isSound = true;

  /// 是否随机活体检测动作
  var isLivenessRandom = false;

  /// 随机活体检测动作数
  var livenessRandomCount = FaceEnvironment.VALUE_LIVENESS_DEFAULT_RANDOM_COUNT;

  /// 闭眼阈值
  var eyeClosedValue = FaceEnvironment.VALUE_CLOSE_EYES;

  /// 图片缓存数量
  var cacheImageNum = FaceEnvironment.VALUE_CACHE_IMAGE_NUM;

  /// 原图缩放系数
  var scale = FaceEnvironment.VALUE_SCALE;

  /// 加密类型，0：Base64加密，上传时image_sec传false；1：百度加密文件加密，上传时image_sec传true
  var secType = FaceEnvironment.VALUE_SEC_TYPE;

  /// 活体检测的动作类型列表
  List<LivenessType> livenessTypeList = [
    LivenessType.Eye,
    LivenessType.Mouth,
    LivenessType.HeadUp,
    LivenessType.HeadDown,
    LivenessType.HeadLeft,
    LivenessType.HeadRight
  ];

  toJson() {
    return {
      'brightnessValue': this.brightnessValue,
      'blurnessValue': this.blurnessValue,
      'occlusionValue': this.occlusionValue,
      'headPitchValue': this.headPitchValue,
      'headYawValue': this.headYawValue,
      'headRollValue': this.headRollValue,
      'cropHeight': this.cropHeight,
      'minFaceSize': this.minFaceSize,
      'notFaceValue': this.notFaceValue,
      'isSound': this.isSound,
      'isLivenessRandom': this.isLivenessRandom,
      'livenessRandomCount': this.livenessRandomCount,
      'livenessTypeList':
          this.livenessTypeList.map((item) => item.index).toList(),
      'eyeClosedValue': this.eyeClosedValue,
      'cacheImageNum': this.cacheImageNum,
      'scale': this.scale,
      'secType': this.secType
    };
  }
}
