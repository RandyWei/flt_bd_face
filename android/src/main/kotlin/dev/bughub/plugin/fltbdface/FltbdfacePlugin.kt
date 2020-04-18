package dev.bughub.plugin.fltbdface

import android.app.Activity
import androidx.annotation.NonNull;
import dev.bughub.plugin.fltbdface.face.FaceDelegate
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FltbdfacePlugin */
public class FltbdfacePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private var activity: Activity? = null
    private var delegate: FaceDelegate? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var flutterBinding: FlutterPlugin.FlutterPluginBinding? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterBinding = flutterPluginBinding
        val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "fltbdface")
        channel.setMethodCallHandler(FltbdfacePlugin());
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
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "fltbdface")
            channel.setMethodCallHandler(FltbdfacePlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
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

                val cropFaceValue: Int? = call.argument<Int>("cropFaceValue")

                val headPitchValue: Int? = call.argument<Int>("headPitchValue")
                val headRollValue: Int? = call.argument<Int>("headRollValue")
                val headYawValue: Int? = call.argument<Int>("headYawValue")
                val minFaceSize: Int? = call.argument<Int>("minFaceSize")
                val notFaceValue: Float? = call.argument<Double>("notFaceValue")?.toFloat()
                val occlusionValue: Float? = call.argument<Double>("occlusionValue")?.toFloat()
                val checkFaceQuality: Boolean? = call.argument<Boolean>("checkFaceQuality")
                val faceDecodeNumberOfThreads: Int? = call.argument<Int>("faceDecodeNumberOfThreads")
                val livenessRandomCount: Int? = call.argument<Int>("livenessRandomCount")


                delegate?.setFaceConfig(livenessTypeList, livenessRandom = livenessRandom, blurnessValue = blurnessValue, brightnessValue = brightnessValue,
                        cropFaceValue = cropFaceValue, headPitchValue = headPitchValue, headRollValue = headRollValue, headYawValue = headYawValue, minFaceSize = minFaceSize,
                        notFaceValue = notFaceValue, occlusionValue = occlusionValue, checkFaceQuality = checkFaceQuality, faceDecodeNumberOfThreads = faceDecodeNumberOfThreads, livenessRandomCount = livenessRandomCount)

                result.success(null)
            }
            "startFaceLiveness" -> {
                flutterBinding?.binaryMessenger?.let { delegate?.startFaceLiveness(it) }
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

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
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
        activity = binding.activity
        delegate = FaceDelegate(binding.activity)
        activityBinding?.addActivityResultListener(delegate!!)
        activityBinding?.addRequestPermissionsResultListener(delegate!!)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }
}
