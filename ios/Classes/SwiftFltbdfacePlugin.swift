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
            self.faceManager?.setLicenseID(arguments["licenseId"], andLocalLicenceFile: arguments["licenseFileName"], andRemoteAuthorize: true)
            if self.faceManager?.canWork() == true {
                var map = [String: Any]()
                map["event"] = "initialize"
                map["status"] = 0
                map["message"] = "初始化成功"
                self.eventSink?(map)
                print("初始化成功")
            }else{
                self.eventSink?(FlutterError(code: "10010", message:"初始化失败", details: ""))
                print("初始化失败")
            }
            return
        }
        else if call.method == "setFaceConfig" {
            let arguments = call.arguments as? [String: Any] ?? [:]
            
            self.faceManager?.setMinFaceSize(arguments["minFaceSize"] as? Int32 ?? 200)
            self.faceManager?.setNotFaceThreshold(arguments["notFaceValue"] as? CGFloat ?? 0.6)
            self.faceManager?.setBlurThreshold(arguments["blurnessValue"] as? CGFloat ?? 0.3)
            self.faceManager?.setIllumThreshold(arguments["brightnessValue"] as? CGFloat ?? 40)
            self.faceManager?.setOccluThreshold(arguments["occlusionValue"] as? CGFloat ?? 0.5)
            self.faceManager?.setEulurAngleThrPitch(arguments["headPitchValue"] as? Float ?? 8,
                                                    yaw: arguments["headYawValue"] as? Float ?? 8,
                                                    roll: arguments["headRollValue"] as? Float ?? 8)
            self.faceManager?.setImageWithScale(arguments["scale"] as? CGFloat ?? 1.0)
            self.faceManager?.setCropFaceSizeHeight(arguments["cropHeight"] as? CGFloat ?? 640)
            self.faceManager?.setMaxCropImageNum(6)
            self.faceManager?.setImageEncrypteWithType(arguments["secType"] as? Int32 ?? 0)
            
            
            IDLFaceLivenessManager.sharedInstance()?.livenesswithList(arguments["livenessTypeList"] as? NSMutableArray as? [Any] , order: !(arguments["isLivenessRandom"] as? Bool ?? true), numberOfLiveness: arguments["livenessRandomCount"] as? Int ?? 0)
            
            self.faceManager?.initCollect()
            
            return
        }
        else if call.method == "startFaceLiveness" {
            
            let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
            
            if(nil == rootViewController){
                result(FlutterError(code: "500", message: "rootViewController is nil.", details: "rootViewController is not set."))
                return
            }
            
            print("11111")
        
            
            let detectController = BDFaceLivenessViewController()

            detectController.resultHandler = { [weak self] imageString in
                var map = [String: Any]()
                map["event"] = "startFaceLiveness"
                map["status"] = 0
                map["message"] = "采集成功"
                map["data"] = imageString
                self?.eventSink?(map)
            }

            rootViewController?.present(detectController, animated: true, completion: nil)
            
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
