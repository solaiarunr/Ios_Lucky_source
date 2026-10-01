//
//  AppDelegate.swift
//  iDemand
//
//  Created by Roby on 28/01/19.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import FBSDKLoginKit
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import FirebaseCore
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate{
    var window: UIWindow?
    var isCurrentUser = String()
    var tabbarSelectedIndex = 0
    var current_lat: Double = 0
    var current_lon: Double = 0
    var loctionString:String = ""
    var currentString:String = ""
    var addressDict = NSDictionary()
    var FilterArray = NSMutableArray()
    var reset:String!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID
        //initial setup
        self.initialSetup()
        //register for push notification permission
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UIApplication.shared.isIdleTimerDisabled = false


    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Utility.shared.networkAlert()
        //connect socket
        if LocalDefault.shared.userID() != nil{
            SocketClass.sharedInstance.connect()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
    }
    
    
    //intial setup
    func initialSetup()  {
        //getFilterArray from userDefaults
        if LocalDefault.shared.getFilterArray().count != 0 {
            self.FilterArray.addObjects(from: LocalDefault.shared.getFilterArray() as! [Any])
        }
        if self.reset == "true"
        {
            self.reset = "false"
        }
        //set language
        if Utility.shared.language() == nil{
            Utility.shared.setApp(language: DEFAULT_LANGUAGE)
        }else{
            Utility.shared.setApp(language: Utility.shared.language()!)
        }
        //update theme
        self.updateAppTheme()
        //keyboard manager
        IQKeyboardManager.shared.enable = true
        //get default
        self.getDefaults()
        //Photo album
        PhotoAlbum.init()
        //initial view
        self.setInitialViewController()
    }
    //update theme
    func updateAppTheme()  {
        if LocalDefault.shared.theme() == nil{
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark{
                    let dark = Utility.shared.Json().value(forKey: "dark")
                    LocalDefault.shared.set(theme:dark as! NSString)
                }else{
                    let light = Utility.shared.Json().value(forKey: "light")
                    LocalDefault.shared.set(theme:light as! NSString)
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    //check user logged in or out
    func setInitialViewController()  {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        var viewController = UIViewController()
        if LocalDefault.shared.userID() != nil{
            Utility.shared.updateProfile()
            viewController = TabBarClass()
        }else{
            LocalDefault().setRole(type: "user")
            viewController = LoginPage()
        }
        
        let root = UINavigationController(rootViewController: viewController)
        root.navigationBar.isTranslucent = false
        root.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        window?.rootViewController = root
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        if GIDSignIn.sharedInstance().handle(url){
            return GIDSignIn.sharedInstance().handle(url)
        }else{
            let handled: Bool = ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            // Add any custom logic here.
            return handled
        }
    }
    
    //get default
    func getDefaults(){
        let Obj = BaseAPI()
        Obj.getDetails(subURl: APPDEFAULT_API, onSuccess: {response in
            let defaultDict = response.value as! NSDictionary
            LocalDefault.shared.setApp(data: defaultDict)
            let isInstant = defaultDict.value(forKey: "instant_location") as! String
            if isInstant == "true"{
                LocalDefault.shared.setLocation(current: true)
            }else{
                LocalDefault.shared.setLocation(current: false)
//                LocalDefault.shared.setLocation(current: true)
            }
            //qwerty
            LocalDefault.shared.setDistance(current: String(defaultDict.value(forKey: "distance") as! Int))
            LocalDefault.shared.setDistanceType(current: (defaultDict.value(forKey: "distance_type") as! String))

            Utility.shared.checkAppUpdate()
        })
    }
}



//MARK: Firebase Push notifications
extension AppDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        LocalDefault.shared.setFCM(token: fcmToken)
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
//    qwerty
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
//        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    //MARK:FCM PUSH NOTIFICATION ACTION
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("FCM MESSAGE 1 \(userInfo)")
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        
        // This notification is not auth related, developer should handle it.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("FCM MESSAGE 2 \(notification.request.content.userInfo)")
        let userDict =  self.convertToDictionary(text: notification.request.content.userInfo["notification_data"] as! String)
        let scope = userDict?.value(forKey: "scope") as! String
        
        print("scope \(scope)")
        var showMsg = true
        if let notificationDict =  userDict?.value(forKey:"message") as? NSDictionary {
            print("notificationDict \(notificationDict)")
            if scope == "chat"{
                let chatID = notificationDict.value(forKey: "chat_id") as! String
                if isCurrentUser == chatID{
                    showMsg = false
                }else{
                    showMsg = true
                }
                SocketClass.sharedInstance.updateMsg(msgDict: notificationDict, type: "user")
            }else if scope == "admin"{
                if isCurrentUser == "admin"{
                    showMsg = false
                }else{
                    showMsg = true
                }
                SocketClass.sharedInstance.updateMsg(msgDict: notificationDict, type: "admin")
            }else if scope == "booking"{
                SocketClass.sharedInstance.updateMsg(msgDict: notificationDict, type: "booking")
            }
        }
        else {
            let notificationDict =  self.convertToDictionary(text: userDict?.value(forKey:"message") as! String)
            print("notificationDict \(notificationDict)")
            if scope == "chat"{
                let chatID = notificationDict!.value(forKey: "chat_id") as! String
                if isCurrentUser == chatID{
                    showMsg = false
                }else{
                    showMsg = true
                }
                SocketClass.sharedInstance.updateMsg(msgDict: notificationDict!, type: "user")
            }else if scope == "admin"{
                if isCurrentUser == "admin"{
                    showMsg = false
                }else{
                    showMsg = true
                }
                SocketClass.sharedInstance.updateMsg(msgDict: notificationDict!, type: "admin")
            }else if scope == "booking"{
                SocketClass.sharedInstance.updateMsg(msgDict: notificationDict!, type: "booking")
            }
        }
        
        
        if showMsg{
            completionHandler(.alert)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("FCM MESSAGE 3 \(response.notification.request.content.userInfo)")
        let userDict =  self.convertToDictionary(text: response.notification.request.content.userInfo["notification_data"] as! String)
        let scope = userDict?.value(forKey: "scope") as! String
        
        print("scope \(scope)")
        if let notificationDict =  userDict?.value(forKey:"message") as? NSDictionary {
            if scope == "chat"{
                let chatID = notificationDict.value(forKey: "chat_id") as! String
                LocalDefault.shared.setNotification(redirection_id: chatID, type: "chat")
            }else if scope == "admin"{
                if (notificationDict.value(forKey: "type") as? String ?? "") == "text" {
                    LocalDefault.shared.setNotification(redirection_id: "", type: "text")
                    SocketClass.sharedInstance.updateMsg(msgDict: notificationDict, type: "admin")
                }
                else {
                    LocalDefault.shared.setNotification(redirection_id: "", type: "admin")
                    SocketClass.sharedInstance.updateMsg(msgDict: notificationDict, type: "admin")
                }
            }else if scope == "booking"{
                LocalDefault.shared.setNotification(redirection_id: notificationDict.value(forKeyPath: "message.booking_id") as! String, type: "booking")
            }else if scope == "review"{
                LocalDefault.shared.setNotification(redirection_id: LocalDefault.shared.userID()!, type: "review")
            }
        }
        else {
            let notificationDict =  self.convertToDictionary(text: userDict?.value(forKey:"message") as! String)
            if scope == "chat"{
                let chatID = notificationDict!.value(forKey: "chat_id") as! String
                LocalDefault.shared.setNotification(redirection_id: chatID, type: "chat")
            }else if scope == "admin"{
                LocalDefault.shared.setNotification(redirection_id: "", type: "admin")
                SocketClass.sharedInstance.updateMsg(msgDict: notificationDict!, type: "admin")
            }else if scope == "booking"{
                LocalDefault.shared.setNotification(redirection_id: notificationDict?.value(forKeyPath: "message.booking_id") as! String, type: "booking")
            }else if scope == "review"{
                LocalDefault.shared.setNotification(redirection_id: LocalDefault.shared.userID()!, type: "review")
            }
        }
        self.setInitialViewController()
        completionHandler()
    }
    func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
