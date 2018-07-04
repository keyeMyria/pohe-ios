//
//  AppDelegate.swift
//  pohe-ios
//
//  Created by 石 臙慧 on 2018/04/23.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit
import Mattress

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let router = RootRouter(window: self.window!)
        router.showRootScreen()
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let kB = 1024
        let MB = 1024 * kB
        let GB = 1024 * MB
        let isOfflineHandler: (() -> Bool) = {
            /*
             We are returning true here for demo purposes only.
             You should use Reachability or another method for determining whether the user is
             offline and return the appropriate value
             */
            return true
        }
        let urlCache = Mattress.URLCache(memoryCapacity: 20 * MB, diskCapacity: 20 * MB, diskPath: nil,
                                         mattressDiskCapacity: 1 * GB, mattressDiskPath: nil, mattressSearchPathDirectory: .documentDirectory,
                                         isOfflineHandler: isOfflineHandler)
        
        NSURLCache.shared = urlCache
        return true
    }


}

