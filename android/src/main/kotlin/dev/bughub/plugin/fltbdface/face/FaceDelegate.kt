package dev.bughub.plugin.fltbdface.face

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import com.baidu.idl.face.platform.FaceEnvironment
import com.baidu.idl.face.platform.FaceSDKManager
import com.baidu.idl.face.platform.LivenessTypeEnum
import com.baidu.idl.face.platform.listener.IInitCallback
import com.baidu.idl.face.platform.ui.utils.IntentUtils
import com.chinahrt.app.pharmacist.QueuingEventSink
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.PluginRegistry
import java.util.*
import kotlin.collections.HashMap


class FaceDelegate(private val activity: Activity, private val eventSink: QueuingEventSink) :
    PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {

    val REQUEST_CAMERA_VIDEO_PERMISSION = 2355
    val FACE_LIVENESS_REQUEST_CODE = 123

    fun initialize(licenseId: String, licenseFileName: String) {

        FaceSDKManager.getInstance()
            .initialize(activity, licenseId, licenseFileName, object : IInitCallback {
                override fun initSuccess() {
                    Log.i("FaceDelegate", "初始化成功")
                    activity.runOnUiThread {
                        val map = HashMap<String, Any>()
                        map["event"] = "initialize"
                        map["status"] = 0
                        map["message"] = "成功"
                        eventSink.success(map)
                    }
                }

                override fun initFailure(status: Int, message: String?) {
                    Log.e("FaceDelegate", "$status  -----   $message")
                    activity.runOnUiThread {
                        eventSink.error("$status", "$message", "")
                    }
                }

            })
    }


    /**
     * 设置人脸配置
     *
     * @param livenessTypeList 活动动作列表
     * @param livenessRandom 活动动作是否随机
     * @param blurnessValue 设置模糊度阈值
     * @param brightnessValue 设置光照阈值（范围0-255）
     * @param headPitchValue 设置人脸姿态角阈值
     * @param headRollValue
     * @param headYawValue 设置人脸姿态角阈值
     * @param minFaceSize 设置可检测的最小人脸阈值
     * @param notFaceValue 设置可检测到人脸的阈值
     * @param occlusionValue 设置遮挡阈值
     * @param livenessRandomCount
     * @param eyeClosedValue 设置闭眼阈值
     * @param cacheImageNum 设置图片缓存数量
     * @param isOpenSound 设置开启提示音
     * @param scale 原图缩放系数
     * @param cropHeight 抠图高的设定，为了保证好的抠图效果，我们要求高宽比是4：3，所以会在内部进行计算，只需要传入高即可
     * @param secType 加密类型，0：Base64加密，上传时image_sec传false；1：百度加密文件加密，上传时image_sec传true
     */
    fun setFaceConfig(
        livenessTypeList: List<Int>,
        livenessRandom: Boolean = false,
        blurnessValue: Float?,
        brightnessValue: Float?,
        headPitchValue: Int?,
        headRollValue: Int?,
        headYawValue: Int?,
        minFaceSize: Int?,
        notFaceValue: Float?,
        occlusionValue: Float?,
        livenessRandomCount: Int?,
        eyeClosedValue: Double?,
        cacheImageNum: Int?,
        isOpenSound: Boolean = true,
        scale: Float?,
        cropHeight: Int?,
        secType: Int?
    ) {
        val config = FaceSDKManager.getInstance().faceConfig
        // SDK初始化已经设置完默认参数（推荐参数），您也根据实际需求进行数值调整
        val livenessList = arrayListOf<LivenessTypeEnum>()
        livenessTypeList.forEach {
            livenessList.add(LivenessTypeEnum.values()[it])
        }

        // 设置活体动作，通过设置list，LivenessTypeEunm.Eye, LivenessTypeEunm.Mouth,
        // LivenessTypeEunm.HeadUp, LivenessTypeEunm.HeadDown, LivenessTypeEunm.HeadLeft,
        // LivenessTypeEunm.HeadRight, LivenessTypeEunm.HeadLeftOrRight
        config.livenessTypeList = livenessList
        // 设置动作活体是否随机
        config.isLivenessRandom = livenessRandom

        config.livenessRandomCount = livenessRandomCount ?: 0

        // 设置可检测的最小人脸阈值
        if (null == minFaceSize)
            config.minFaceSize = FaceEnvironment.VALUE_MIN_FACE_SIZE
        else
            config.minFaceSize = minFaceSize

        // 设置可检测到人脸的阈值
        if (null == notFaceValue)
            config.notFaceValue = FaceEnvironment.VALUE_NOT_FACE_THRESHOLD
        else
            config.notFaceValue = notFaceValue

        // 设置模糊度阈值
        if (null == blurnessValue)
            config.blurnessValue = FaceEnvironment.VALUE_BLURNESS
        else
            config.blurnessValue = blurnessValue

        // 设置光照阈值（范围0-255）
        if (null == brightnessValue)
            config.brightnessValue = FaceEnvironment.VALUE_BRIGHTNESS
        else
            config.brightnessValue = brightnessValue

        // 设置遮挡阈值
        if (null == occlusionValue)
            config.occlusionValue = FaceEnvironment.VALUE_OCCLUSION
        else
            config.occlusionValue = occlusionValue

        // 设置人脸姿态角阈值
        if (null == headPitchValue)
            config.headPitchValue = FaceEnvironment.VALUE_HEAD_PITCH
        else
            config.headPitchValue = headPitchValue
        if (null == headYawValue)
            config.headYawValue = FaceEnvironment.VALUE_HEAD_YAW
        else
            config.headYawValue = headYawValue

        // 设置闭眼阈值
        if (eyeClosedValue == null) {
            config.eyeClosedValue = FaceEnvironment.VALUE_CLOSE_EYES
        } else {
            config.eyeClosedValue = eyeClosedValue.toFloat()
        }

        // 设置图片缓存数量
        if (cacheImageNum == null) {
            config.cacheImageNum = FaceEnvironment.VALUE_CACHE_IMAGE_NUM
        } else {
            config.cacheImageNum = cacheImageNum
        }

        // 设置开启提示音
        config.isSound = isOpenSound

        // 原图缩放系数
        if (scale == null) {
            config.scale = FaceEnvironment.VALUE_SCALE
        } else {
            config.scale = scale
        }

        // 抠图高的设定，为了保证好的抠图效果，我们要求高宽比是4：3，所以会在内部进行计算，只需要传入高即可
        if (cropHeight == null) {
            config.cropHeight = FaceEnvironment.VALUE_CROP_HEIGHT
        } else {
            config.cropHeight = cropHeight
        }

        // 加密类型，0：Base64加密，上传时image_sec传false；1：百度加密文件加密，上传时image_sec传true
        if (secType == null) {
            config.secType = FaceEnvironment.VALUE_SEC_TYPE;
        } else {
            config.secType = secType
        }

        if (null == headRollValue)
            config.headRollValue = FaceEnvironment.VALUE_HEAD_ROLL
        else
            config.headRollValue = headRollValue


        FaceSDKManager.getInstance().faceConfig = config
    }

    fun startFaceLiveness() {
        val intent = Intent(activity, FaceLivenessExpActivity::class.java)
        activity.startActivityForResult(intent, FACE_LIVENESS_REQUEST_CODE)
    }


    var livenessList = arrayListOf<LivenessTypeEnum>()
    var isLivenessRandom = false

    private fun initLivenessList() {
        livenessList.clear()
        livenessList.add(LivenessTypeEnum.Eye)
        livenessList.add(LivenessTypeEnum.Mouth)
        livenessList.add(LivenessTypeEnum.HeadUp)
        livenessList.add(LivenessTypeEnum.HeadDown)
        livenessList.add(LivenessTypeEnum.HeadLeft)
        livenessList.add(LivenessTypeEnum.HeadRight)
    }

    /**
     * 生成n个不同的随机数，且随机数区间为[0,7)
     * @param n
     * @return
     */
    private fun getRandomActions(n: Int): List<LivenessTypeEnum> {
        initLivenessList()
        val list = arrayListOf<LivenessTypeEnum>()
        val rand = Random()
        val bool = BooleanArray(7)
        var num: Int
        for (i in 0 until n) {
            do {
                // 如果产生的数相同继续循环
                num = rand.nextInt(7)
            } while (bool[num])
            bool[num] = true
            list.add(livenessList[num])
        }
        return list
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == FACE_LIVENESS_REQUEST_CODE) {
            val imgData = IntentUtils.getInstance().bitmap
            return if (null == imgData) {
                eventSink.error("10010", "采集失败", "采集失败")
                Log.i("===", "采集失败")
                true
            } else {
                val map = HashMap<String, Any>()
                map["event"] = "startFaceLiveness"
                map["status"] = 0
                map["data"] = imgData
                eventSink.success(map)
                Log.i("===", imgData)
                true
            }
        }
        //释放
        FaceSDKManager.getInstance().release()
        return true

    }


    /** returns true, if permission present in manifest, otherwise false  */
    private fun isPermissionPresentInManifest(context: Context, permissionName: String): Boolean {
        return try {
            val packageManager = context.packageManager
            val packageInfo =
                packageManager.getPackageInfo(context.packageName, PackageManager.GET_PERMISSIONS)
            val requestedPermissions = packageInfo.requestedPermissions
            listOf(*requestedPermissions).contains(permissionName)
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
            false
        }
    }


    interface PermissionManager {
        fun isPermissionGranted(permissionName: String?): Boolean
        fun askForPermission(permissionName: String?, requestCode: Int)
        fun needRequestCameraPermission(): Boolean
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        val permissionGranted =
            grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED

        when (requestCode) {
            REQUEST_CAMERA_VIDEO_PERMISSION -> if (permissionGranted) {

            }
            else -> return false
        }

        if (!permissionGranted) {
            when (requestCode) {
            }
        }

        return true
    }
}