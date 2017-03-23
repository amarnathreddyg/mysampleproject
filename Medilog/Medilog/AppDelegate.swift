//
//  AppDelegate.swift
//  Medilog
//
//  Created by Amarnath on 23/03/17.
//  Copyright © 2017 Amarnath. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import UserNotifications

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var slideMenu: SlideMenuController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if Platform.isSimulator == false {
            registerForPushNotifications(application: application)
        }

        if Utilities.getAuthToken() != "" {
            let sideMenuVC = MenuViewController()
            let mainVC = UIViewController()
            let slideNavigationController = UINavigationController(rootViewController: mainVC)
            slideNavigationController.isNavigationBarHidden = true
            let slideMenuController = SlideMenuController(mainViewController: slideNavigationController, leftMenuViewController: sideMenuVC)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.slideMenu = slideMenuController
            self.window?.rootViewController = slideMenuController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                if granted == true {
                    application.registerForRemoteNotifications()
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
    //MARK: - Notification delegates
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        if notificationSettings.types != .none {
            registerForPushNotifications(application: application)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        debugPrint(deviceTokenString)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        debugPrint("Notification received")
        debugPrint(userInfo)
        application.applicationIconBadgeNumber = 0
        
        if application.applicationState == .inactive || application.applicationState == .background {
            ////app launched from background
        } else {
            //app is in forground
        }
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


}

