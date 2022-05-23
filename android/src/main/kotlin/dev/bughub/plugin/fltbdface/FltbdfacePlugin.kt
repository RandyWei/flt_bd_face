package dev.bughub.plugin.fltbdface

import android.app.Activity
import android.app.Application
import android.util.Log
import androidx.annotation.NonNull
import com.chinahrt.app.pharmacist.QueuingEventSink
import dev.bughub.plugin.fltbdface.face.FaceDelegate
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** FltbdfacePlugin */
class FltbdfacePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private var activity: Activity? = null
    private var delegate: FaceDelegate? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var flutterBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var channel: MethodChannel? = null
    private var application: Application? = null

    private var eventSink = QueuingEventSink()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterBinding = binding
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {

        private const val CHANNEL = "plugin.bughub.dev/fltbdface"

    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.i("2222", "${this.hashCode()}")
        if (activity == null) {
            result.error("no_activity", "face plugin requires a foreground activity.", null)
            return
        }

        when (call.method) {
            "initialize" -> {
                val licenseId = call.argument<String>("licenseId") ?: ""
                val licenseFileName = call.argument<String>("licenseFileName") ?: ""
                delegate?.initialize(licenseId, licenseFileName)
                result.success(null)
            }
            "setFaceConfig" -> {
                val livenessTypeList = call.argument<List<Int>>("livenessTypeList") ?: arrayListOf()

                val livenessRandom: Boolean = call.argument("isLivenessRandom") ?: false

                val blurnessValue: Float? = call.argument<Double>("blurnessValue")?.toFloat()

                val brightnessValue: Float? = call.argument<Double>("brightnessValue")?.toFloat()

                val cropHeight: Int? = call.argument<Int>("cropHeight")

                val headPitchValue: Int? = call.argument<Int>("headPitchValue")
                val headRollValue: Int? = call.argument<Int>("headRollValue")
                val headYawValue: Int? = call.argument<Int>("headYawValue")
                val minFaceSize: Int? = call.argument<Int>("minFaceSize")
                val notFaceValue: Float? = call.argument<Double>("notFaceValue")?.toFloat()
                val occlusionValue: Float? = call.argument<Double>("occlusionValue")?.toFloat()
                val scale: Float? = call.argument<Double>("scale")?.toFloat()
                val eyeClosedValue: Double? = call.argument<Double>("eyeClosedValue")
                val isOpenSound: Boolean = call.argument<Boolean>("isSound") ?: true
                val cacheImageNum: Int? = call.argument<Int>("cacheImageNum")
                val livenessRandomCount: Int? = call.argument<Int>("livenessRandomCount")
                val secType: Int? = call.argument<Int>("secType")


                delegate?.setFaceConfig(
                    livenessTypeList,
                    livenessRandom = livenessRandom,
                    blurnessValue = blurnessValue,
                    brightnessValue = brightnessValue,
                    headPitchValue = headPitchValue,
                    headYawValue = headYawValue,
                    headRollValue = headRollValue,
                    minFaceSize = minFaceSize,
                    notFaceValue = notFaceValue,
                    occlusionValue = occlusionValue,
                    livenessRandomCount = livenessRandomCount,
                    eyeClosedValue = eyeClosedValue,
                    cacheImageNum = cacheImageNum,
                    isOpenSound = isOpenSound,
                    scale = scale,
                    cropHeight = cropHeight,
                    secType = secType
                )

                result.success(null)
            }
            "startFaceLiveness" -> {
                delegate?.startFaceLiveness()
                result.success(null)
            }
        }
    }

    private fun tearDown() {
        delegate?.let {
            activityBinding?.removeActivityResultListener(it)
            delegate = null
            activityBinding = null
        }

    }

    private fun setup(
        messenger: BinaryMessenger,
        application: Application,
        activity: Activity,
        activityBinding: ActivityPluginBinding?
    ) {
        this.activity = activity
        this.application = application
        delegate = FaceDelegate(activity, eventSink)
        channel = MethodChannel(messenger, CHANNEL)
        channel?.setMethodCallHandler(this)

        EventChannel(flutterBinding?.binaryMessenger, "plugin.bughub.dev/event").setStreamHandler(
            object :
                EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink.setDelegate(events)
                }

                override fun onCancel(arguments: Any?) {
                    eventSink.setDelegate(null)
                }
            })

        activityBinding?.addActivityResultListener(delegate!!)
        activityBinding?.addRequestPermissionsResultListener(delegate!!)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterBinding = null
    }

    override fun onDetachedFromActivity() {
        tearDown()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        setup(
            flutterBinding?.binaryMessenger!!,
            flutterBinding?.applicationContext as Application,
            binding.activity,
            binding
        )
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }
}
