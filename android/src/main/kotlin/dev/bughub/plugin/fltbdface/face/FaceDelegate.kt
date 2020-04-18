package dev.bughub.plugin.fltbdface.face

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import com.baidu.idl.face.platform.FaceEnvironment
import com.baidu.idl.face.platform.FaceSDKManager
import com.baidu.idl.face.platform.LivenessTypeEnum
import com.chinahrt.app.pharmacist.QueuingEventSink
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.PluginRegistry
import java.util.*


class FaceDelegate(var activity: Activity) : PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {

    val REQUEST_CAMERA_VIDEO_PERMISSION = 2355
    val FACE_LIVENESS_REQUEST_CODE = 123
    var permissionManager: PermissionManager? = null
    private val eventSink = QueuingEventSink()


//    init {
//        permissionManager = object: PermissionManager{
//            override fun isPermissionGranted(permissionName: String?): Boolean {
//                return permissionName?.let { ActivityCompat.checkSelfPermission(activity, it) } == PackageManager.PERMISSION_GRANTED
//            }
//
//            override fun askForPermission(permissionName: String?, requestCode: Int) {
//                ActivityCompat.requestPermissions(activity, arrayOf(permissionName!!), requestCode)
//            }
//
//            override fun needRequestCameraPermission(): Boolean {
//                val greatOrEqualM = Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
//                return greatOrEqualM && isPermissionPresentInManifest(activity, Manifest.permission.CAMERA)
//            }
//
//        }
//    }

//    private fun needRequestCameraPermission(): Boolean {
//        return if (permissionManager == null) {
//            false
//        } else permissionManager!!.needRequestCameraPermission()
//    }

    fun initialize(licenseId: String, licenseFileName: String) {
        FaceSDKManager.getInstance().initialize(activity, licenseId, licenseFileName)
    }

    fun setFaceConfig(livenessTypeList: List<Int>, livenessRandom: Boolean = false, blurnessValue: Float?,
                      brightnessValue: Float?, cropFaceValue: Int?,
                      headPitchValue: Int?, headRollValue: Int?,
                      headYawValue: Int?, minFaceSize: Int?,
                      notFaceValue: Float?, occlusionValue: Float?,
                      checkFaceQuality: Boolean?, faceDecodeNumberOfThreads: Int?, livenessRandomCount: Int?) {
        val config = FaceSDKManager.getInstance().faceConfig
        // SDK初始化已经设置完默认参数（推荐参数），您也根据实际需求进行数值调整
        val livenessList = arrayListOf<LivenessTypeEnum>()
        livenessTypeList.forEach {
            livenessList.add(LivenessTypeEnum.values()[it])
        }

        config.setLivenessTypeList(livenessList)

        config.setLivenessRandom(livenessRandom)

        config.setLivenessRandomCount(livenessRandomCount ?: 0)

        if (null == blurnessValue)
            config.setBlurnessValue(FaceEnvironment.VALUE_BLURNESS)
        else
            config.setBlurnessValue(blurnessValue)

        if (null == brightnessValue)
            config.setBrightnessValue(FaceEnvironment.VALUE_BRIGHTNESS)
        else
            config.setBrightnessValue(brightnessValue)

        if (null == cropFaceValue)
            config.setCropFaceValue(FaceEnvironment.VALUE_CROP_FACE_SIZE)
        else
            config.setCropFaceValue(cropFaceValue)

        if (null == headPitchValue)
            config.setHeadPitchValue(FaceEnvironment.VALUE_HEAD_PITCH)
        else
            config.setHeadPitchValue(headPitchValue)

        if (null == headRollValue)
            config.setHeadRollValue(FaceEnvironment.VALUE_HEAD_ROLL)
        else
            config.setHeadRollValue(headRollValue)

        if (null == headYawValue)
            config.setHeadYawValue(FaceEnvironment.VALUE_HEAD_YAW)
        else
            config.setHeadYawValue(headYawValue)

        if (null == minFaceSize)
            config.setMinFaceSize(FaceEnvironment.VALUE_MIN_FACE_SIZE)
        else
            config.setMinFaceSize(minFaceSize)

        if (null == notFaceValue)
            config.setNotFaceValue(FaceEnvironment.VALUE_NOT_FACE_THRESHOLD)
        else
            config.setNotFaceValue(notFaceValue)

        if (null == occlusionValue)
            config.setOcclusionValue(FaceEnvironment.VALUE_OCCLUSION)
        else
            config.setOcclusionValue(occlusionValue)


        config.setCheckFaceQuality(checkFaceQuality ?: false)

        config.setFaceDecodeNumberOfThreads(faceDecodeNumberOfThreads ?: 2)

        FaceSDKManager.getInstance().faceConfig = config
    }

    fun startFaceLiveness(messenger: BinaryMessenger) {

        EventChannel(messenger, "com.chinahrt.app.pharmacist/event").setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(o: Any?, sink: EventChannel.EventSink?) {
                // 把eventSink存起来
                eventSink.setDelegate(sink)
            }

            override fun onCancel(o: Any?) {
                eventSink.setDelegate(null)
            }
        })

        val intent = Intent(activity, BdFaceLivenessActivity::class.java)
        activity.startActivityForResult(intent, FACE_LIVENESS_REQUEST_CODE)
    }

    fun start(actionNum: Int) {
//        permissionManager?.let {
//            if (needRequestCameraPermission()
//                    && !it.isPermissionGranted(Manifest.permission.CAMERA)) {
//                it.askForPermission(
//                        Manifest.permission.CAMERA, REQUEST_CAMERA_VIDEO_PERMISSION)
//                return
//            }
//        }


        setFaceConfig(activity, actionNum)

        val intent = Intent(activity, BdFaceLivenessActivity::class.java)
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
        livenessList.add(LivenessTypeEnum.HeadLeftOrRight)
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


    /*人脸识别初始化参数设置*/
    private fun setFaceConfig(activity: Activity, actionNum: Int) {
        FaceSDKManager.getInstance().initialize(activity, "pharmacist-license-face-android", "idl-license.face-android")
        val config = FaceSDKManager.getInstance().faceConfig
        // SDK初始化已经设置完默认参数（推荐参数），您也根据实际需求进行数值调整
        config.setLivenessTypeList(getRandomActions(actionNum))
        config.setLivenessRandom(isLivenessRandom)
        config.setBlurnessValue(FaceEnvironment.VALUE_BLURNESS)
        config.setBrightnessValue(FaceEnvironment.VALUE_BRIGHTNESS)
        config.setCropFaceValue(FaceEnvironment.VALUE_CROP_FACE_SIZE)
        config.setHeadPitchValue(FaceEnvironment.VALUE_HEAD_PITCH)
        config.setHeadRollValue(FaceEnvironment.VALUE_HEAD_ROLL)
        config.setHeadYawValue(FaceEnvironment.VALUE_HEAD_YAW)
        config.setMinFaceSize(FaceEnvironment.VALUE_MIN_FACE_SIZE)
        config.setNotFaceValue(FaceEnvironment.VALUE_NOT_FACE_THRESHOLD)
        config.setOcclusionValue(FaceEnvironment.VALUE_OCCLUSION)
        config.setCheckFaceQuality(true)
        config.setFaceDecodeNumberOfThreads(2)

        FaceSDKManager.getInstance().faceConfig = config
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == FACE_LIVENESS_REQUEST_CODE) {
            return if (null == data) {
                eventSink.error("10010", "采集失败", "采集失败")
                Log.i("===", "采集失败")
                true
            } else {
                val dataStr = data.getStringExtra("data")
                eventSink.success(dataStr)
                Log.i("===", dataStr)
                true
            }
        }
        return true

    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, grantResults: IntArray?): Boolean {
        val permissionGranted = grantResults!!.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED

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

    /** returns true, if permission present in manifest, otherwise false  */
    private fun isPermissionPresentInManifest(context: Context, permissionName: String): Boolean {
        return try {
            val packageManager = context.packageManager
            val packageInfo = packageManager.getPackageInfo(context.packageName, PackageManager.GET_PERMISSIONS)
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
}