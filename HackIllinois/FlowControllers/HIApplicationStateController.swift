//
//  HIApplicationStateController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import Keychain

class HIApplicationStateController {

    static var shared = HIApplicationStateController()

    // MARK: - Properties
    var window = HIWindow(frame: UIScreen.main.bounds)
    var user: HIUser?

    // MARK: ViewControllers
    var loginFlowController = HILoginFlowController()
    var appFlowController = HITabBarController()

    // MARK: - Init
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(loginUser), name: .loginUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logoutUser), name: .logoutUser, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func initalize() {
        window.makeKeyAndVisible()

        resetPersistentDataIfNeeded()
        recoverUserIfPossible()

        if user != nil {
            loginFlowController.shouldDisplayAnimationOnNextAppearance = false
        }

        updateWindowViewController(animated: false)
    }
}

// MARK: - API
extension HIApplicationStateController {
    func resetPersistentDataIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: HIConstants.APPLICATION_INSTALLED_KEY) else { return }
        _ = Keychain.default.purge()
        HICoreDataController.shared.purge()
        UserDefaults.standard.set(true, forKey: HIConstants.APPLICATION_INSTALLED_KEY)
    }

    func recoverUserIfPossible() {
        guard Keychain.default.hasValue(forKey: HIConstants.STORED_ACCOUNT_KEY) else { return }
        guard let user = Keychain.default.retrieve(HIUser.self, forKey: HIConstants.STORED_ACCOUNT_KEY) else {
            Keychain.default.removeObject(forKey: HIConstants.STORED_ACCOUNT_KEY)
            return
        }
        self.user = user
    }

    func viewControllersFor(user: HIUser) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        viewControllers.append(HIHomeViewController())
        viewControllers.append(HIScheduleViewController())
        viewControllers.append(HIUserDetailViewController())
        viewControllers.append(HIIndoorMapsViewController())
        viewControllers.append(HIProjectViewController())

        if user.roles.contains(.admin) {
            viewControllers.append(HIAdminStatsViewController())
        }

        return viewControllers
    }

    @objc func loginUser(_ notification: Notification) {
        guard let user = notification.userInfo?["user"] as? HIUser else { return }
        guard Keychain.default.store(user, forKey: HIConstants.STORED_ACCOUNT_KEY) else { return }
        self.user = user
        HILocalNotificationController.shared.requestAuthorization()
        UIApplication.shared.registerForRemoteNotifications()
        updateWindowViewController(animated: true)
    }

    @objc func logoutUser() {
        guard user != nil else { return }
        Keychain.default.removeObject(forKey: HIConstants.STORED_ACCOUNT_KEY)
        user = nil
        updateWindowViewController(animated: true)
    }

    func updateWindowViewController(animated: Bool) {
        let viewController: UIViewController
        if let user = user {
            prepareAppControllerForDisplay(with: user)
            viewController = appFlowController
        } else {
            prepareLoginControllerForDisplay()
            viewController = loginFlowController
        }

        let duration = animated ? 0.3 : 0
        viewController.view.layoutIfNeeded()
        UIView.transition(with: window, duration: duration, options: .transitionCrossDissolve, animations: {
            self.window.rootViewController = viewController
        }, completion: nil)
    }

    func prepareAppControllerForDisplay(with user: HIUser) {
        let appViewControllers = viewControllersFor(user: user)
        appFlowController.setupMenuFor(appViewControllers)
        appFlowController.selectedIndex = 0

        // Disable the middle tabbar button (QR Code)
        if let items = appFlowController.tabBar.items {
            if items.count >= 3 {
                items[2].isEnabled = false
            }
        }

        HIEventDataSource.refresh()
        HIAnnouncementDataSource.refresh()
        HIProjectDataSource.refresh()
    }

    func prepareLoginControllerForDisplay() { }
}
