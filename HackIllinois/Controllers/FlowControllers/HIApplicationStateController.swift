//
//  HIApplicationStateController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import SwiftKeychainAccess
import UserNotifications

extension Notification.Name {
    static let loginUser  = Notification.Name("HIApplicationStateControllerLoginUser")
    static let switchUser = Notification.Name("HIApplicationStateControllerSwitchUser")
    static let logoutUser = Notification.Name("HIApplicationStateControllerLogoutUser")
}

class HIApplicationStateController {

    static var shared = HIApplicationStateController()

    // MARK: - Properties
    var window = HIWindow(frame: UIScreen.main.bounds)
    var user: HIUser?

    // MARK: ViewControllers
    var loginFlowController = HILoginFlowController()
    var menuController = HIMenuController()

    // MARK: - Init
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(loginUser), name: .loginUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchUser), name: .switchUser, object: nil)
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
        guard !UserDefaults.standard.bool(forKey: "HIAPPLICATION_INSTALLED") else { return }
        _ = Keychain.default.purge()

        UserDefaults.standard.set(true, forKey: "HIAPPLICATION_INSTALLED")
    }

    // FIXME:
    func recoverUserIfPossible() {
//        for key in Keychain.default.allKeys() {
//            guard let user = Keychain.default.retrieve(HIUser.self, forKey: key) else {
//                Keychain.default.removeObject(forKey: key)
//                continue
//            }
//            if user.isActive {
//                if var user = self.user {
//                    user.isActive = false
//                    Keychain.default.store(user, forKey: user.identifier)
//                }
//                self.user = user
//            }
//        }
    }

    func viewControllersFor(user: HIUser) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        viewControllers.append(HIHomeViewController())
        viewControllers.append(HIScheduleViewController())
        viewControllers.append(HIAnnouncementsViewController())
        viewControllers.append(HIUserDetailViewController())

        if !user.roles.intersection([.staff, .admin]).isEmpty {
            viewControllers.append(HIScannerViewController())
        }

        return viewControllers
    }

    // FIXME:
    @objc func loginUser(_ notification: Notification) {
        guard var user = notification.userInfo?["user"] as? HIUser else { return }
//        user.isActive = true
//        Keychain.default.store(user, forKey: user.identifier)
        self.user = user
        updateWindowViewController(animated: true)
    }

    // FIXME:
    @objc func switchUser() {
        guard var user = user else { return }
//        user.isActive = false
//        Keychain.default.store(user, forKey: user.identifier)
        self.user = nil

        updateWindowViewController(animated: true)
    }

    // FIXME:
    @objc func logoutUser() {
        guard let user = user else { return }
//        _ = Keychain.default.removeObject(forKey: user.identifier)
        self.user = nil

        updateWindowViewController(animated: true)
    }

    func updateWindowViewController(animated: Bool) {
        let viewController: UIViewController
        if let user = user {
            prepareMenuControllerForDisplay(with: user)
            viewController = menuController
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

    func prepareMenuControllerForDisplay(with user: HIUser) {
        let menuViewControllers = viewControllersFor(user: user)
        menuController.setupMenuFor(menuViewControllers)
        menuController._tabBarController.selectedIndex = 0

        HIEventDataSource.refresh()
        HIAnnouncementDataSource.refresh()
    }

    func prepareLoginControllerForDisplay() {
        loginFlowController.navController.popToRootViewController(animated: false)
    }
}
