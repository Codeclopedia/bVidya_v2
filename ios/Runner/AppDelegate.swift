import UIKit
import PushKit
import Flutter
import FirebaseMessaging
import flutter_callkit_incoming
import shared_preferences_ios
import UserNotifications


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let messanger = controller.binaryMessenger as FlutterBinaryMessenger
        let channel = FlutterMethodChannel(name: "notification_plugin", binaryMessenger: messanger)
        initChannel(channel: channel)
        GeneratedPluginRegistrant.register(with: self)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
        }
        registerForPushNotifications();
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
        
        if let ln = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: Any] {
            self.launchNotification = ln
            //   print("On Launch info=> \(ln)")
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        //        print("Received: \(userInfo)")
        
        completionHandler(.noData)
        return true
    }
    // override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    //    NSLog("PUSH registration failed: \(error)")
    // }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: UIKit.Data) {
        //        print("Registered for Apple Remote Notifications:")
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        //        print(deviceTokenString)
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func registerForPushNotifications() {
        //        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
        //            UNUserNotificationCenter.current().delegate = self
        //            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
        //                (granted, error) in
        //                print("Permission granted: \(granted)")
        //                // 1. Check if permission granted
        //                guard granted else { return }
        //                // 2. Attempt registration for remote notifications on the main thread
        //                DispatchQueue.main.async {
        //                    UIApplication.shared.registerForRemoteNotifications()
        //                }
        //            }
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("pushRegistry TOKEN")
        
        print(deviceToken)
        //Save deviceToken to your server
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("didInvalidatePushTokenFor")
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }
    
    
    //    override func applicationDidEnterBackground(_ application: UIApplication) {
    //        resumingFromBackground = true
    //    }
    //
    //    override func applicationDidBecomeActive(_ application: UIApplication) {
    //        resumingFromBackground = false
    //        UIApplication.shared.applicationIconBadgeNumber = -1;
    //    }
    //
    
    // Handle incoming pushes
    //    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
    //        print("didReceiveIncomingPushWith")
    //        guard type == .voIP else { return }
    //
    //        let id = payload.dictionaryPayload["id"] as? String ?? ""
    //        let nameCaller = payload.dictionaryPayload["nameCaller"] as? String ?? ""
    //        let handle = payload.dictionaryPayload["handle"] as? String ?? ""
    //        let isVideo = payload.dictionaryPayload["isVideo"] as? Bool ?? false
    //
    //   ̛     let data = flutter_callkit_incoming.Data(id: id, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
    //        //set more data
    //        data.extra = ["user": "abc@123", "platform": "ios"]
    //        //data.iconName = ...
    //        //data.....
    //        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
    //    }
    
    override  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        //        for key in userInfo.keys {
        //            print("foreground: \(key): \(userInfo[key])")
        //        }
        self.channel?.invokeMethod("onMessage", arguments: userInfo)
        completionHandler([.alert])
    }
    
    //This method is to handle a notification that arrived while the app was not in foreground
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         didReceive response: UNNotificationResponse,
                                         withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        //        for key in userInfo.keys {
        //            print("click: \(key): \(userInfo[key])")
        //        }
        self.channel?.invokeMethod("onMessageTap", arguments: userInfo)
        completionHandler()
    }
    
    var channel: FlutterMethodChannel?
    //    var resumingFromBackground = false
    var launchNotification: [String: Any]?
    
    
    func initChannel(channel: FlutterMethodChannel){
        self.channel = channel
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            if(call.method == "getLaunchMessage"){
                if(self.launchNotification != nil){
                    result(self.launchNotification)
                    self.launchNotification = nil
                }else{
                    result(nil)
                }
            }else{
                result(FlutterMethodNotImplemented)
            }
            
        })
    }
    
}
