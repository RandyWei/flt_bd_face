package dev.bughub.plugin.fltbdface.face

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FacePlugin:MethodChannel.MethodCallHandler,FlutterPlugin,ActivityAware{

    private val CHANNEL_NAME = "com.chinahrt.app.pharmacist/face"

    private var methodChannel: MethodChannel? = null
    private var flutterBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var activityBinding:ActivityPluginBinding? = null
    private var delegate: FaceDelegate? = null
    private var activity:Activity? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (activity == null) {
            result.error("no_activity", "image_picker plugin requires a foreground activity.", null)
            return
        }

        when (call.method) {
            "initialize" -> {
                val licenseId = call.argument<String>("licenseId")?:""
                val licenseFileName = call.argument<String>("licenseFileName")?:""
                delegate?.initialize(licenseId,licenseFileName)
                result.success(null)
            }
            "setFaceConfig" -> {
                val livenessTypeList = call.argument<List<Int>>("livenessTypeList")?: arrayListOf()

                val livenessRandom:Boolean = call.argument("isLivenessRandom")?:false

                val blurnessValue:Float? = call.argument<Double>("blurnessValue")?.toFloat()

                val brightnessValue:Float? = call.argument<Double>("brightnessValue")?.toFloat()

                val cropFaceValue:Int? = call.argument<Int>("cropFaceValue")

                val headPitchValue:Int? = call.argument<Int>("headPitchValue")
                val headRollValue:Int? =call.argument<Int>("headRollValue")
                val headYawValue:Int? =call.argument<Int>("headYawValue")
                val minFaceSize:Int? =call.argument<Int>("minFaceSize")
                val notFaceValue:Float? =call.argument<Double>("notFaceValue")?.toFloat()
                val occlusionValue:Float? =call.argument<Double>("occlusionValue")?.toFloat()
                val checkFaceQuality:Boolean? =call.argument<Boolean>("checkFaceQuality")
                val faceDecodeNumberOfThreads:Int? =call.argument<Int>("faceDecodeNumberOfThreads")
                val livenessRandomCount:Int? =call.argument<Int>("livenessRandomCount")


                delegate?.setFaceConfig(livenessTypeList,livenessRandom=livenessRandom,blurnessValue=blurnessValue,brightnessValue=brightnessValue,
                        cropFaceValue=cropFaceValue,headPitchValue=headPitchValue,headRollValue=headRollValue,headYawValue=headYawValue,minFaceSize=minFaceSize,
                        notFaceValue=notFaceValue,occlusionValue=occlusionValue,checkFaceQuality=checkFaceQuality,faceDecodeNumberOfThreads=faceDecodeNumberOfThreads,livenessRandomCount=livenessRandomCount)

                result.success(null)
            }
            "startFaceLiveness" -> {
                flutterBinding?.binaryMessenger?.let { delegate?.startFaceLiveness(it) }
                result.success(null)
            }
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterBinding = binding
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterBinding = null
    }

    private fun tearDown(){

        delegate?.let {
            activityBinding?.removeActivityResultListener(it)
            delegate = null
            activityBinding = null
        }

        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onDetachedFromActivity() {
        tearDown()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {

        activityBinding = binding

        methodChannel = MethodChannel(flutterBinding?.binaryMessenger, CHANNEL_NAME)
        methodChannel?.setMethodCallHandler(this)

        activity = binding.activity
        delegate = FaceDelegate(binding.activity)
        activityBinding?.addActivityResultListener(delegate!!)

        activityBinding?.addRequestPermissionsResultListener(delegate!!)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }
}