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

  /// 裁剪图像中人脸时的大小
  var cropFaceValue = FaceEnvironment.VALUE_CROP_FACE_SIZE;

  /// 图像能被检测出人脸的最小人脸值
  var minFaceSize = FaceEnvironment.VALUE_MIN_FACE_SIZE;

  /// 图像能被检测出人脸阀值
  var notFaceValue = FaceEnvironment.VALUE_NOT_FACE_THRESHOLD;

  /// 人脸采集图片数量阀值
  var maxCropImageNum = FaceEnvironment.VALUE_MAX_CROP_IMAGE_NUM;

  /// 是否进行人脸图片质量检测
  var isCheckFaceQuality = FaceEnvironment.VALUE_IS_CHECK_QUALITY;

  /// 是否开启提示音
  var isSound = true;

  /// 是否进行检测
  var sVerifyLive = true;

  /// 人脸检测时开启的进程数，建议为CPU核数
  var faceDecodeNumberOfThreads = 0;

  /// 是否随机活体检测动作
  var isLivenessRandom = false;

  /// 随机活体检测动作数
  var livenessRandomCount = FaceEnvironment.VALUE_LIVENESS_DEFAULT_RANDOM_COUNT;

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
      'cropFaceValue': this.cropFaceValue,
      'minFaceSize': this.minFaceSize,
      'notFaceValue': this.notFaceValue,
      'maxCropImageNum': this.maxCropImageNum,
      'isCheckFaceQuality': this.isCheckFaceQuality,
      'isSound': this.isSound,
      'sVerifyLive': this.sVerifyLive,
      'faceDecodeNumberOfThreads': this.faceDecodeNumberOfThreads,
      'isLivenessRandom': this.isLivenessRandom,
      'livenessRandomCount': this.livenessRandomCount,
      'livenessTypeList': this.livenessTypeList.map((item) => item.index).toList(),
    };
  }
}
