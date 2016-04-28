//
//  AppDelegate.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-01-18.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    struct Constants {
        static let ReceivedToken = "com.flybits.push.receivedToken"
        static let TokenKey      = "com.flybits.push.token"
    }

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Tutorial Section 0.0 (API Key)
        Session.sharedInstance.configuration.APIKey = "<#API Key#>"
        
        print("Server: \(Session.sharedInstance.configuration.serverURL)")
        
        Session.sharedInstance.configuration.preferredLocales = [
            NSLocale(localeIdentifier: "en_US"),
            NSLocale(localeIdentifier: "fr_FR")
        ]

        // Tutorial Section 7.1 (Push Notifications)
        let notificationTypes: UIUserNotificationType = [.Badge, .Sound, .Alert]
        let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Tutorial Section 7.2 (Push Notifications)
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.ReceivedToken, object: nil, userInfo:  [Constants.TokenKey : deviceToken])
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("application:didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }

    // Tutorial Section 7.5 (Push Notifications)
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let handled = PushManager.sharedManager.notificationReceived(userInfo) { (result) in
            completionHandler(result)
        }
        if !handled {
            completionHandler(.NoData)
        }
    }
}

