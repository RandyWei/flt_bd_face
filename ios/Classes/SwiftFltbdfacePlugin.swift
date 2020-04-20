import Flutter
import UIKit
import IDLFaceSDK

public class SwiftFltbdfacePlugin: NSObject, FlutterPlugin {
    
    var eventSink: FlutterEventSink?
    var faceManager = FaceSDKManager.sharedInstance()
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugin.bughub.dev/fltbdface", binaryMessenger: registrar.messenger())
        let instance = SwiftFltbdfacePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannelName = "plugin.bughub.dev/event"
        let eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "initialize" {
            let arguments = call.arguments as? [String: String] ?? [:]
            self.faceManager?.setLicenseID(arguments["licenseId"], andLocalLicenceFile: arguments["licenseFileName"])
            return
        }
        else if call.method == "setFaceConfig" {
            let arguments = call.arguments as? [String: Any] ?? [:]
            self.faceManager?.setIllumThreshold(arguments["brightnessValue"] as? Int ?? 40)
            self.faceManager?.setBlurThreshold(arguments["blurnessValue"] as? CGFloat ?? 0.5)
            self.faceManager?.setOccluThreshold(arguments["occlusionValue"] as? CGFloat ?? 0.5)
            self.faceManager?.setEulurAngleThrPitch(arguments["headPitchValue"] as? Int ?? 10,
                                                    yaw: arguments["headYawValue"] as? Int ?? 10,
                                                    roll: arguments["headRollValue"] as? Int ?? 10)
            self.faceManager?.setCropFaceSizeWidth(arguments["cropFaceValue"] as? CGFloat ?? 400)
            self.faceManager?.setMinFaceSize(arguments["minFaceSize"] as? Int ?? 200)
            self.faceManager?.setNotFaceThreshold(arguments["notFaceValue"] as? CGFloat ?? 0.6)
            self.faceManager?.setMaxCropImageNum(arguments["maxCropImageNum"] as? Int ?? 1)
            self.faceManager?.setIsCheckQuality(arguments["isCheckFaceQuality"] as? Bool ?? true)

            
            let configModel = LivingConfigModel.sharedInstance()
            configModel?.liveActionArray = arguments["livenessTypeList"] as? NSMutableArray ?? []
            configModel?.isByOrder = !(arguments["isLivenessRandom"] as? Bool ?? true)
            configModel?.numOfLiveness = arguments["livenessRandomCount"] as? Int ?? 0
            return
        }
        else if call.method == "startFaceLiveness" {
            let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
            if(nil == rootViewController){
                result(FlutterError(code: "500", message: "rootViewController is nil.", details: "rootViewController is not set."))
                return
            }
            let detectController = LivenessViewController()
            detectController.resultHandler = { [weak self] imageString in
                self?.eventSink?(imageString)
            }
            let navController = UINavigationController(rootViewController: detectController)
            navController.modalPresentationStyle = .fullScreen
            rootViewController?.present(navController, animated: true, completion: nil)
            return
        }
    }
}



extension SwiftFltbdfacePlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
