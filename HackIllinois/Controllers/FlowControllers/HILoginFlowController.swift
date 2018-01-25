//
//  HILoginFlowController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 12/2/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import UIKit
import APIManager
import Lottie
import SafariServices
import SwiftKeychainAccess

class HILoginFlowController: UIViewController {
    // MARK: - Properties
    let animationView = LOTAnimationView(name: "data")
    var shouldDisplayAnimationOnNextAppearance = true
    var userPassRequestToken: APIRequestToken?
    var keychainContents = [String]()

    // keeps the login session from going out of scope during presentation
    var loginSession: SFAuthenticationSession?

    // MARK: ViewControllers
    lazy var navController = UINavigationController(rootViewController: loginSelectionViewController)
    lazy var loginSelectionViewController = HILoginSelectionViewController(delegate: self)
    lazy var userPassLoginViewController = HIUserPassLoginViewController(delegate: self)
}

// MARK: - UIViewController
extension HILoginFlowController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HIColor.paleBlue
        navController.isNavigationBarHidden = true
        addChildViewController(navController)
        navController.view.frame = view.frame
        navController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(navController.view)
        navController.didMove(toParentViewController: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshKeychainContents()
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
            animationView.play { _ in
                self.animationView.removeFromSuperview()
            }
            shouldDisplayAnimationOnNextAppearance = false
        }
    }
}

// MARK: - Login Flow
extension HILoginFlowController {
    func populateUserData(loginMethod: HILoginMethod, token: String, sender: HIBaseViewController) {
        HIUserService.getUser(by: token, with: loginMethod)
        .onCompletion { result in
            switch result {
            case .success(let containedUser):
                let userInfo = containedUser.data[0]
                let user = HIUser(
                    loginMethod: loginMethod,
                    permissions: userInfo.roles.map { $0.permissions }.reduce(.attendee, max),
                    token: token,
                    identifier: userInfo.info.email,
                    isActive: true,
                    id: userInfo.info.id
                )

                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: ["user": user])
                }
            case .cancellation:
                break
            case .failure:
                sender.presentErrorController(title: "Authentication Failed", message: nil, dismissParentOnCompletion: false)
            }
        }
        .authorization(HIApplicationStateController.shared.user)
        .perform()
    }

}

// MARK: - Keychain
extension HILoginFlowController {
    func refreshKeychainContents() {
        keychainContents = Keychain.default.allKeys().sorted { $0 < $1 }
        loginSelectionViewController.tableView?.reloadData()
    }

    func keychainRetrievalSucceeded(user: HIUser) {
        // TODO: validation in the future
        // FIXME: theres a chance that a recovered github account will have a token that is revoked, we should probably validate this token.
        // low chance of this happening in 48 hours, fix it later.
        // this is also a concern for user-pass logins
        NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: [
            "user": user
        ])
    }

    func keychainRetrievalFailed(id: String) {
        Keychain.default.removeObject(forKey: id)
        refreshKeychainContents()
        let alert = UIAlertController(title: "Login Failed", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

// MARK: - HILoginSelectionViewControllerDelegate
extension HILoginFlowController: HILoginSelectionViewControllerDelegate {
    func loginSelectionViewControllerKeychainAccounts(_ loginSelectionViewController: HILoginSelectionViewController) -> [String] {
        return keychainContents
    }

    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController, didMakeLoginSelection selection: HILoginSelection, withUserInfo info: String?) {
        switch selection {
        case .github:
            print("URL ::", HIAuthService.githubLoginURL())
            loginSession = SFAuthenticationSession(url: HIAuthService.githubLoginURL(), callbackURLScheme: nil) { [weak self] (url, error) in

                if let url = url,
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                    let queryItems = components.queryItems,
                    let token = queryItems.first(where: { $0.name == "token" })?.value,
                    token.trimmingCharacters(in: .whitespacesAndNewlines) != "" {

                    DispatchQueue.main.async {
                        self?.populateUserData(loginMethod: .github, token: token, sender: loginSelectionViewController)
                    }
                }

                if let error = error {
                    if (error as? SFAuthenticationError)?.code == SFAuthenticationError.canceledLogin {
                        // do nothing
                    } else {
                        let alert = UIAlertController(title: "Authentication Failed", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
            loginSession?.start()

        case .userPass:
            navController.pushViewController(userPassLoginViewController, animated: true)

        case .existing:
            guard let identifier = info else { break }

            if let user = Keychain.default.retrieve(HIUser.self, forKey: identifier) {
                keychainRetrievalSucceeded(user: user)
            } else {
                keychainRetrievalFailed(id: identifier)
            }
        }
    }
}

// MARK: - HIUserPassLoginViewControllerDelegate
extension HILoginFlowController: HIUserPassLoginViewControllerDelegate {
    func userPassLoginViewControllerDidSelectBackButton(_ userPassLoginViewController: HIUserPassLoginViewController) {
        if userPassRequestToken?.state == .running {
            userPassRequestToken?.cancel()
            userPassRequestToken = nil
        }
        navController.popViewController(animated: true)
    }

    func userPassLoginViewControllerDidSelectLoginButton(_ userPassLoginViewController: HIUserPassLoginViewController, forEmail email: String, andPassword password: String) {
        userPassLoginViewController.stylizeFor(.currentlyPerformingLogin)

        userPassRequestToken = HIAuthService.login(email: email, password: password)
        .onCompletion { result in
            switch result {
            case .success(let containedAuth):
                DispatchQueue.main.async { [weak self] in
                    self?.populateUserData(loginMethod: .userPass, token: containedAuth.data[0].auth, sender: userPassLoginViewController)
                    self?.userPassLoginViewController.stylizeFor(.readyToLogin)
                }

            case .cancellation:
                break

            case .failure(let error):
                do {
                    throw error
                } catch DecodingError.dataCorrupted(let context) {
                    print("DecodingError.dataCorrupted", context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("DecodingError.keyNotFound", key, context)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("DecodingError.typeMismatch", type, context)
                } catch {
                    print(error)
                }

                DispatchQueue.main.async { [weak self] in
                    // TODO: Shake with error
                    self?.userPassLoginViewController.stylizeFor(.readyToLogin)
                }
            }
        }
        .perform()
    }
}
