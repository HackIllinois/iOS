//
//  HILoginFlowController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 12/2/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import UIKit
import APIManager
import Lottie
import SafariServices
import SwiftKeychainAccess

class HILoginFlowController: UIViewController {
    // MARK: - Properties
    let animationView = LOTAnimationView(name: "intro")
    var shouldDisplayAnimationOnNextAppearance = true

    // MARK: Status Bar
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    var statusBarIsHidden = false
    override var prefersStatusBarHidden: Bool {
        return statusBarIsHidden
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return HIAppearance.current.preferredStatusBarStyle
    }

    // prevents the login session from going out of scope during presentation
    var loginSession: SFAuthenticationSession?

    // MARK: ViewControllers
    // FIME: remove
    lazy var navController = UINavigationController(rootViewController: loginSelectionViewController)
    lazy var loginSelectionViewController = HILoginSelectionViewController(delegate: self)

    // MARK: - Init
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - UIViewController
extension HILoginFlowController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HIAppearance.current.background
        navController.isNavigationBarHidden = true
        addChild(navController)
        navController.view.frame = view.frame
        navController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(navController.view)
        navController.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldDisplayAnimationOnNextAppearance {
            animationView.contentMode = .scaleAspectFill
            animationView.frame = view.frame
            animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(animationView)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldDisplayAnimationOnNextAppearance {
            statusBarIsHidden = true
            setNeedsStatusBarAppearanceUpdate()

            animationView.play { _ in
                self.animationView.removeFromSuperview()
                self.statusBarIsHidden = false
                UIView.animate(withDuration: 0.25) { () -> Void in
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            }
            shouldDisplayAnimationOnNextAppearance = false
        }
    }
}

// MARK: - Login Flow
private extension HILoginFlowController {
    private func attemptOAuthLogin(buildingUser user: HIUser, sender: HIBaseViewController) {
        let loginURL = HIAuthService.oauthURL(provider: user.provider)
        loginSession = SFAuthenticationSession(url: loginURL, callbackURLScheme: nil) { [weak self] (url, error) in
            if let url = url,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                let queryItems = components.queryItems,
                let code = queryItems.first(where: { $0.name == "code" })?.value,
                code.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                var user = user
                user.oauthCode = code
                self?.exchangeOAuthCodeForAPIToken(buildingUser: user, sender: sender)
            } else if let error = error {
                if (error as? SFAuthenticationError)?.code == SFAuthenticationError.canceledLogin {
                    // do nothing
                } else {
                    self?.presentAuthenticationFailure(withError: error, sender: sender)
                }
            } else {
                let error = HIError.unknownAuthenticationError
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        }
        loginSession?.start()
    }

    private func exchangeOAuthCodeForAPIToken(buildingUser user: HIUser, sender: HIBaseViewController) {
        HIAuthService.getAPIToken(provider: user.provider, code: user.oauthCode)
        .onCompletion { [weak self] result in
            do {
                let (apiToken, _) = try result.get()
                var user = user
                user.token = apiToken.token
                self?.populateUserData(buildingUser: user, sender: sender)
            } catch {
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        }
        .launch()
    }

    private func populateUserData(buildingUser user: HIUser, sender: HIBaseViewController) {
        HIUserService.getUser()
        .onCompletion { [weak self] result in
            do {
                let (apiUser, _) = try result.get()
                var user = user
                user.id = apiUser.id
                user.username = apiUser.username
                user.firstName = apiUser.firstName
                user.lastName = apiUser.lastName
                user.email = apiUser.email
                self?.populateRoleData(buildingUser: user, sender: sender)
            } catch {
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        }
        .authorize(with: user)
        .launch()
    }

    private func populateRoleData(buildingUser user: HIUser, sender: HIBaseViewController) {
        HIAuthService.getRoles()
        .onCompletion { [weak self] result in
            do {
                let (apiRolesContainer, _) = try result.get()
                var user = user
                user.roles = apiRolesContainer.roles
                self?.populateRegistrationData(buildingUser: user, sender: sender)
            } catch {
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        }
        .authorize(with: user)
        .launch()
    }

    private func populateRegistrationData(buildingUser user: HIUser, sender: HIBaseViewController) {
        HIRegistrationService.getAttendee()
        .onCompletion { [weak self] result in
            do {
                let (apiAttendeeContainer, _) = try result.get()
                var user = user
                user.dietaryRestrictions = apiAttendeeContainer.attendee.diet
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: ["user": user])
                }
            } catch {
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        }
        .authorize(with: user)
        .launch()
    }

    private func presentAuthenticationFailure(withError error: Error, sender: HIBaseViewController) {
        DispatchQueue.main.async {
            sender.presentErrorController(title: "Authentication Failed", message: error.localizedDescription, dismissParentOnCompletion: false)
        }
    }
}

// MARK: - HILoginSelectionViewControllerDelegate
extension HILoginFlowController: HILoginSelectionViewControllerDelegate {
    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController,
                                      didMakeLoginSelection selection: HIAuthService.OAuthProvider) {
        let user = HIUser(provider: selection)
        attemptOAuthLogin(buildingUser: user, sender: loginSelectionViewController)
    }
}
