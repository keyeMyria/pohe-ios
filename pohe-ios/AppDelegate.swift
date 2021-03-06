//
//  AppDelegate.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/23.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        settingRegisterRemoteNotifications()
        FirebaseApp.configure()
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let router = RootRouter(window: self.window!)
        router.showRootScreen()
        setUrlCache()
        UserDefaults.standard.register(defaults: ["longPress" : true])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if CheckReachability(host_name: "google.com") {
            print("インターネットへの接続が確認されました")
        } else {
            print("インターネットに接続してください")
            
            let alertController = UIAlertController(title: "インターネット未接続", message: "インターネット未接続でも\nブックマークを閲覧できます。\nブックマークに遷移しますか？", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "はい", style: .default, handler: {action in self.bookmark()})
            alertController.addAction(defaultAction)
            alertController.addAction(UIAlertAction(title: "やめる", style: .cancel, handler: nil))

            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let fcmToken = Messaging.messaging().fcmToken {
            UserDefaults.standard.set(fcmToken, forKey: "fcm_token")
            Messaging.messaging().apnsToken = deviceToken
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.noData)
    }

    private func setUrlCache() {
        let kB = 1024
        let MB = 1024 * kB
        let GB = 1024 * MB
        let urlCache = URLCache(memoryCapacity: 25 * MB, diskCapacity: 100 * MB, diskPath: nil)
    
        URLCache.shared = urlCache
    }
    
    func settingRegisterRemoteNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func bookmark() {
        let nc = PageViewController().initPages()
        window?.rootViewController?.present(nc, animated: true, completion: nil)
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response:UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}


