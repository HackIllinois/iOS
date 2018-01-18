//
//  AppDelegate.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 4/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // FIXME: Allows arbitary loads (make github issue)

//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
//        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
//              let url = userActivity.webpageURL,
//              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
//              let queryItems = components.queryItems,
//              let code = queryItems.first(where: { $0.name == "code" })?.value else { return false }
//        print(url.absoluteString)
//        print(code)
//        return true
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Appearance customization
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.tintColor = HIColor.hotPink
        navigationBarAppearace.barTintColor = HIColor.paleBlue
        navigationBarAppearace.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: HIColor.darkIndigo as Any,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15, weight: .bold) as Any
        ]
        navigationBarAppearace.shadowImage = UIImage()

        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        HIColor.paleBlue.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        navigationBarAppearace.setBackgroundImage(image, for: .default)
        navigationBarAppearace.isTranslucent = false

        window = UIWindow(frame: UIScreen.main.bounds)

        let menuController = UIStoryboard(.general).instantiate(HIMenuController.self)
        window?.rootViewController = UIStoryboard(.login).instantiate(HILoginFlowController.self)
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        CoreDataController.shared.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        CoreDataController.shared.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataController.shared.saveContext()
    }
}

