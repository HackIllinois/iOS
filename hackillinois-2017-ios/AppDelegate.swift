//
//  AppDelegate.swift
//  hackillinois-2017-ios
//
//  Created by Shotaro Ikeda on 5/22/16.
//  Copyright © 2016 Shotaro Ikeda. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var HACKILLINOIS_API_URL: String!
    var mTimer = Timer()
    var funcList = [String: ((Void) -> Void)]()
    
    
    
    func iterateFunctions() {
        CoreDataHelpers.updateEventsFeed()
        for (_, callback) in funcList {
            callback()
        }
    }
    
    func setInterval(key: String, callback: @escaping ((Void) -> Void)) {
        print("Delegate: Set interval for key \(key)")
        self.funcList[key] = callback
    }
    
    func clearIntereval(key: String) {
        print("Delegate: Cleared interval for key \(key)")
        self.funcList[key] = nil
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.isTranslucent = false
        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.hiaDarkSlateBlue
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        let tabBarAppearace = UITabBar.appearance()
        tabBarAppearace.isTranslucent = false
        tabBarAppearace.tintColor = UIColor.white
        tabBarAppearace.barTintColor = UIColor.hiaDarkSlateBlue

        UIApplication.shared.statusBarStyle = .lightContent
        
        mTimer = Timer.scheduledTimer(timeInterval: 10, target:self, selector: #selector(self.iterateFunctions), userInfo: nil, repeats: true)
        
        //
        //        // Parse API Keys from keys.plist file
        //        var keys: NSDictionary?
        //        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
        //            keys = NSDictionary(contentsOfFile: path)
        //        } else {
        //            print("keys.plist file could not be found. Please see README.md for information about keys.plist")
        //        }
        //
        //        if let dict = keys {
        //            // Read keys here
        //            print(dict["HACKILLINOIS_API_URL"]!)
        //            HACKILLINOIS_API_URL = dict["HACKILLINOIS_API_URL"]! as! String
        //        }
        //
        //        /* Find out which part of the application to go to */
        //        let user = CoreDataHelpers.loadContext(entityName: "User", fetchConfiguration: nil) as! [User]
        //        if !user.isEmpty {
        //            print("User set to expire: \(user[0].expireTime)")
        //            print("Current: \(NSDate())")
        //        }
        //
        //        if user.isEmpty {
        //            print("First launch, no user found")
        //            self.window?.rootViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        //        } else if user[0].expireTime.compare(Date()) == .orderedAscending {
        //            print("User already logged in before")
        //            // TODO: Check if this method crashes
        //            let loginView: LoginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as! LoginViewController
        //            loginView.initialEmail = user[0].email // Initialize it with user's email
        //            self.window?.rootViewController = loginView
        //        } else {
        //            // Login not necessary
        //            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        //        }
        //
        
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
        self.saveContext()
    }
    

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "me.hackillinois.hackillinois_2017_ios" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    /* We need to keep this API for legacy iOS 9.0 support */
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "hackillinois_2017_ios", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSOverwriteMergePolicy // Newest data is what should be used
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

