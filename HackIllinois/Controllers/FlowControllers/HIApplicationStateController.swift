//
//  HIApplicationStateController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/21/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainAccess

extension Notification.Name {
    static let loginUser  = Notification.Name("HIApplicationStateControllerLoginUser")
    static let switchUser = Notification.Name("HIApplicationStateControllerSwitchUser")
    static let logoutUser = Notification.Name("HIApplicationStateControllerLogoutUser")
}

class HIApplicationStateController {

    // MARK: - Properties
    var window = UIWindow(frame: UIScreen.main.bounds)
    var user: HIUser?

    // MARK: ViewControllers
    var loginFlowController = HILoginFlowController()
    var menuController = HIMenuController()

    // MARK: - Init
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(HIApplicationStateController.loginUser), name: .loginUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HIApplicationStateController.switchUser), name: .switchUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HIApplicationStateController.logoutUser), name: .logoutUser, object: nil)

        resetPersistentDataIfNeeded()
        recoverUserIfPossible()

        if user != nil {
            loginFlowController.shouldDisplayAnimationOnNextAppearance = false
        }

        updateWindowViewController(animated: false)
        window.makeKeyAndVisible()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - API
extension HIApplicationStateController {
    func resetPersistentDataIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: "HIAPPLICATION_INSTALLED") else { return }
        _ = Keychain.default.purge()
        UserDefaults.standard.set(true, forKey: "HIAPPLICATION_INSTALLED")
    }

    func recoverUserIfPossible() {
        for key in Keychain.default.allKeys() {
            guard let user = Keychain.default.retrieve(HIUser.self, forKey: key) else {
                Keychain.default.removeObject(forKey: key)
                continue
            }
            if user.isActive {
                if var user = self.user {
                    user.isActive = false
                    Keychain.default.store(user, forKey: user.identifier)
                }
                self.user = user
            }
        }
    }

    func viewControllersFor(user: HIUser) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        if [.attendee].contains(user.permissions) {
            viewControllers.append(HIHomeViewController())
        }
        if [.attendee, .volunteer, .staff, .admin].contains(user.permissions) {
            viewControllers.append(HIScheduleViewController())
        }
        if [.attendee, .volunteer, .staff, .admin].contains(user.permissions) {
            viewControllers.append(HIAnnouncementsViewController())
        }
        if [.attendee, .volunteer, .staff, .admin].contains(user.permissions) {
            viewControllers.append(HIUserDetailViewController())
        }
        if [.volunteer, .staff, .admin].contains(user.permissions) {
            viewControllers.append(HIScannerViewController())
        }
        return viewControllers
    }

    @objc func loginUser(_ notification: Notification) {
        guard var user = notification.userInfo?["user"] as? HIUser else { return }
        user.isActive = true
        Keychain.default.store(user, forKey: user.identifier)
        self.user = user

        updateWindowViewController(animated: true)
    }

    @objc func switchUser() {
        guard var user = user else { return }
        user.isActive = false
        Keychain.default.store(user, forKey: user.identifier)
        self.user = nil

        updateWindowViewController(animated: true)
    }

    @objc func logoutUser() {
        guard let user = user else { return }
        _ = Keychain.default.removeObject(forKey: user.identifier)
        self.user = nil

        updateWindowViewController(animated: true)
    }

    func updateWindowViewController(animated: Bool) {
        let viewController: UIViewController
        if let user = user {
            let menuViewControllers = viewControllersFor(user: user)
            menuController.setupMenuFor(menuViewControllers)
            menuController._tabBarController.selectedIndex = 0
            viewController = menuController
        } else {
            loginFlowController.navController.popToRootViewController(animated: false)
            viewController = loginFlowController
        }

        let duration = animated ? 0.3 : 0
        viewController.view.layoutIfNeeded()
        UIView.transition(with: window, duration: duration, options: .transitionCrossDissolve, animations: {
            self.window.rootViewController = viewController
        }, completion: nil)
    }
}
