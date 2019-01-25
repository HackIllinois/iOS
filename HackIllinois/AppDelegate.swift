//
//  AppDelegate.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 4/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import UIKit
import SwiftKeychainAccess
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBarAppearance()
        setupTableViewAppearance()
        _ = HIThemeEngine.shared
        HIApplicationStateController.shared.initalize()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        HICoreDataController.shared.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        HICoreDataController.shared.saveContext()
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
        HICoreDataController.shared.saveContext()
    }
}

// MARK: - Appearance Customization
extension AppDelegate {
    func setupNavigationBarAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold) as Any
        ]
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.isTranslucent = false
    }

    func setupTableViewAppearance() {
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.separatorStyle = .none
        tableViewAppearance.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
        tableViewAppearance.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
        tableViewAppearance.showsHorizontalScrollIndicator = false
    }
}
