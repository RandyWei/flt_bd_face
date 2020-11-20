package dev.bughub.plugin.fltbdface

import android.app.Activity
import android.app.Application
import android.util.Log
import androidx.annotation.NonNull
import dev.bughub.plugin.fltbdface.face.FaceDelegate
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
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
    private var channel: MethodChannel? = null
    private var application: Application? = null


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterBinding = flutterPluginBinding
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

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            if (registrar.activity() == null) {
                return
            }
            val activity = registrar.activity()
            var application: Application? = null
            if (registrar.context() != null) {
                application = registrar.context().applicationContext as Application
            }
            val plugin = FltbdfacePlugin()
            plugin.setup(registrar.messenger(), application!!, activity, registrar, null)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
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
                val eyeClosedValue: Float? = call.argument<Float>("eyeClosedValue")
                val isOpenSound: Boolean = call.argument<Boolean>("isSound") ?: true
                val cacheImageNum: Int? = call.argument<Int>("cacheImageNum")
                val livenessRandomCount: Int? = call.argument<Int>("livenessRandomCount")
                val secType: Int? = call.argument<Int>("secType")


                delegate?.setFaceConfig(livenessTypeList, livenessRandom = livenessRandom, blurnessValue = blurnessValue, brightnessValue = brightnessValue,
                        headPitchValue = headPitchValue, headYawValue = headYawValue, headRollValue = headRollValue, minFaceSize = minFaceSize, notFaceValue = notFaceValue,
                        occlusionValue = occlusionValue, livenessRandomCount = livenessRandomCount, eyeClosedValue = eyeClosedValue, cacheImageNum = cacheImageNum,
                        isOpenSound = isOpenSound, scale = scale, cropHeight = cropHeight, secType = secType)

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
            registrar: Registrar?,
            activityBinding: ActivityPluginBinding?) {
        this.activity = activity
        this.application = application
        delegate = FaceDelegate(activity, flutterBinding?.binaryMessenger)
        channel = MethodChannel(messenger, CHANNEL)
        channel?.setMethodCallHandler(this)
        if (registrar != null) { // V1 embedding setup for activity listeners.
            registrar.addActivityResultListener(delegate)
            registrar.addRequestPermissionsResultListener(delegate)
        } else { // V2 embedding setup for activity listeners.
            activityBinding?.addActivityResultListener(delegate!!)
            activityBinding?.addRequestPermissionsResultListener(delegate!!)
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
        setup(flutterBinding?.binaryMessenger!!, flutterBinding?.applicationContext as Application, binding.activity, null, binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }
}
