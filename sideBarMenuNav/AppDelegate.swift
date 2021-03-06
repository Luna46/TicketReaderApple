//
//  AppDelegate.swift
//  TicketReaderApple
//
//  Created by Miguel Angel Luna on 5/12/16.
//  Copyright © 2016 Miguel Angel Luna. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FIRMessagingDelegate {
    /// The callback to handle data message received via FCM for devices running iOS 10 or above.
    public func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@",remoteMessage.appData)
        /**let content = UNMutableNotificationContent()
        
        content.title = "Hello"
        content.body = "What up?"
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error)
        }
        print("should have been added")*/
        var localNotification = UILocalNotification()
        //localNotification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
        localNotification.fireDate = NSDate(timeIntervalSinceNow: -1) as Date
        localNotification.alertAction = "Nuevo ticket"
        localNotification.alertBody = "Ticket"
        localNotification.timeZone = NSTimeZone.default
        localNotification.applicationIconBadgeNumber = 0
        UIApplication.shared.scheduleLocalNotification(localNotification)
        /**var notification = UILocalNotification()
        // debe de activarse dentro de 5 segundos
        notification.fireDate! = Date(timeIntervalSinceNow: 5)
        // mensaje que saldrá en la alerta
        notification.alertBody! = "¡Nuevo Ticket!"
        // sonido por defecto
        notification.soundName! = UILocalNotificationDefaultSoundName
        // título del botón
        notification.alertAction! = "Ahora te lo cuento"
        notification.hasAction = true
        // activa la notificación
        UIApplication.shared.scheduleLocalNotification(notification)*/
        
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        //application.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
    }
    
    // [START disconnect_from_fcm]
    /**func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }*/


    var window: UIWindow?
    
     let gcmMessageIDKey = "gcm.message_id"


    /**func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }*/
    
    /**func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FIRApp.configure()
        
        NotificationCenter.default.addObserver(self,
                                                       selector: #selector(tokenRefreshNotification),
                                                       name: NSNotification.Name.firInstanceIDTokenRefresh,
                                                       object: nil)
        
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        
        
    }
    
    /**override func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        
        NotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(tokenRefreshNotification(_:)),
                                                         name: kFIRInstanceIDTokenRefreshNotification,
                                                         object: nil)
    }*/
    
    // NOTE: Need to use this when swizzling is disabled
    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
        
        connectToFcm()
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
    }*/
    
    /**func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: FIRInstanceIDAPNSTokenType.sandbox
)
    }*/
    
    /**func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }*/
    /**func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }*/
    
    //FIRInstanceIDAPNSTokenTypeSandbox
    
    /**func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
        -> Bool {
            FIRApp.configure()
            return true
    }
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
        
        connectToFcm()
    }*/
    
    //*func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
        /**FIRApp.configure()
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(tokenRefreshNotification),
                                                         name: NSNotification.Name.firInstanceIDTokenRefresh,
                                                         object: nil)*/
        //return true
    //}
    
    // NOTE: Need to use this when swizzling is disabled
    /**public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }*/
    
    //func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    /**func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(tokenRefreshNotification),
                                                         name: NSNotification.Name.firInstanceIDTokenRefresh,
                                                         object: nil)
        return true
    }*/
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = .lightContent
        //application.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        application.applicationIconBadgeNumber = 0
        UILabel.appearance().substituteFontName = "AvenirNext-Regular"
        
        if #available(iOS 10.0, *) {
            //let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            //UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_,_ in })
            
            let center = UNUserNotificationCenter.current() //get the notification center
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: NSNotification.Name.firInstanceIDTokenRefresh,
                                               object: nil)
        
        return true
    }
    
    /**func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }*/
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    // NOTE: Need to use this when swizzling is disabled
    /**public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: FIRInstanceIDAPNSTokenType.sandbox)
    }*/
    
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
        
        connectToFcm()
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    /**public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
    }*/
    
    func application(_ application: UIApplication,  didReceiveRemoteNotification userInfo: [String : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        //userInfo.index(forKey: "grupo" as NSObject)
        //print(userInfo["grupo"])
        //userInfo.keys
        
        
        //let todo = try JSONSerialization.jsonObject(with: userInfo, options: []) as? [String: AnyObject]
        //let todoTicket = userInfo["ticket"] as? String
        let todoId : String = userInfo["idTicket"] as! String
        
        if TicketConstant.ticketList.count > 0{
            var ticketFind = TicketConstant.ticketList[0]
            if ticketFind.getIdticket() == Int(todoId) {
                print("Ticket repetido con id \(todoId)")
                return
            }
        }
        
        
       
            
        var ticket = Ticket()
        ticket.setIdticket(idTicket: Int(todoId)!)
        //TicketConstant.ticketList.append(ticket)
        TicketConstant.ticketList.insert(ticket, at: 0)
        print("Ticket Insertado")
        /**self.window = UIWindow(frame: UIScreen.main.bounds)
        /**let datos = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        
        self.navigationController?.pushViewController(datos, animated: true)
        
        datos.indexTouch = indexPath.row
        datos.lastTicketView = true*/
        let  storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let datos = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController as UIViewController
        let navigationController = application.windows[0].rootViewController as! UINavigationController
        navigationController.setViewControllers([datos], animated: true)
        datos.indexTouch = TicketConstant.ticketList.count-1
        //self.window?.inputViewController = datos
        self.window?.rootViewController = datos
        self.window?.makeKeyAndVisible()//ESTO FUNCIONA*/
        
        //self.window = UIWindow(frame: UIScreen.main.bounds)
        /**let datos = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
         
         self.navigationController?.pushViewController(datos, animated: true)
         
         datos.indexTouch = indexPath.row
         datos.lastTicketView = true*/
        //let  storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //let datos = storyboard.instantiateViewController(withIdentifier: "lastTickets") as! LastTicketsView
        //let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        //navigationController.viewControllers = [datos]
        //navigationController.setViewControllers([datos], animated: true)
        /**datos.indexTouch = TicketConstant.ticketList.count-1
        datos.alarmTicket = true
        datos.mainWindow = self
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()*/
        //datos.navigationController?.pushViewController(datos, animated: true)
        

        //datos.lastTicketView = true
        if (TicketConstant.pageView != nil){
            
            TicketConstant.pageView?.indexTouch = 0
            TicketConstant.pageView?.mostrarUltimoTicket()
            
        }
        
        else {
            
            LastTicketsView.alarmTicket = true;
            
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    /**func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }*/

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    /**func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }*/

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

@available(iOS 10, *)

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(center: UNUserNotificationCenter,
                                willPresentNotification notification: UNNotification,
                                withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        // Print full message.
        print("%@", userInfo)
    }
}

