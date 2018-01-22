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
    var window: UIWindow?

    // MARK: ViewControllers
    lazy var loginFlowController = HILoginFlowController()
    lazy var menuController = HIMenuController()

    // MARK: - Init
    init(window: UIWindow?) {
        self.window = window
        
    }

    deinit {

    }
}

// MARK: - API
extension HIApplicationStateController {
    func startUp() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = initalViewController()
        window?.makeKeyAndVisible()
    }

    func initalViewController() -> UIViewController {
        var userToActivate: HIUser?
        for key in Keychain.default.allKeys() {
            guard let user = Keychain.default.retrieve(HIUser.self, forKey: key) else {
                Keychain.default.removeObject(forKey: key)
                continue
            }
            if user.isActive {
                if var user = userToActivate {
                    user.isActive = false
                    Keychain.default.store(user, forKey: user.identifier)
                }
                userToActivate = user
            }
        }

        // TODO: remove
        // userToActivate = HIUser(loginMethod: .userPass, permissions: .hacker, token: "sf", identifier: "rauhul_test")
        // userToActivate?.isActive = true

        if let user = userToActivate {
            setupMenuControllerFor(user: user)
            return menuController
        } else {
            return loginFlowController
        }
    }

    func setupMenuControllerFor(user: HIUser) {
        var viewControllers = [UIViewController]()
        if [.hacker].contains(user.permissions) {
            viewControllers.append(HIHomeViewController())
        }
        if [.hacker, .volunteer, .staff, .superUser].contains(user.permissions) {
            viewControllers.append(HIScheduleViewController())
        }
        if [.hacker, .volunteer, .staff, .superUser].contains(user.permissions) {
            viewControllers.append(HIAnnouncementsViewController())
        }
        if [.hacker, .volunteer, .staff, .superUser].contains(user.permissions) {
            viewControllers.append(HIUserDetailViewController())
        }
        if [.volunteer, .staff, .superUser].contains(user.permissions) {
            viewControllers.append(HIScannerViewController())
        }
        menuController.setupMenuFor(viewControllers)
    }

    func switchAccounts() {
//        vc.view.frame = rootViewController.view.frame
//        vc.view.layoutIfNeeded()
//
//        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            window.rootViewController = vc
//        }, completion: { completed in
//            // maybe do something here
//        })

    }
}

