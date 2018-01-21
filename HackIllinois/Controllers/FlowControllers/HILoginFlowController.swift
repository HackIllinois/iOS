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

protocol HILoginFlowControllerDelegate: class {
    func loginFlowController(_ loginFlowController: HILoginFlowController, didLoginWith user: HIUser)
}

class HILoginFlowController: UIViewController {

    // MARK: - Properties
    weak var delegate: HILoginFlowControllerDelegate?

    let animationView = LOTAnimationView(name: "data")
    var shouldDisplayAnimationOnNextAppearance = true
    var userPassRequestToken: APIRequestToken?
    var keychainContents = [String]()

    // keeps the login session from going out of scope during presentation
    var loginSession: SFAuthenticationSession?

    // MARK: ViewControllers
    lazy var navController: UINavigationController = {
        let vc = UINavigationController(rootViewController: loginSelectionViewController)
        vc.isNavigationBarHidden = true
        return vc
    }()

    lazy var loginSelectionViewController: HILoginSelectionViewController = {
        let vc = HILoginSelectionViewController()
        vc.delegate = self
        return vc
    }()

    lazy var userPassLoginViewController: HIUserPassLoginViewController = {
        let vc = HIUserPassLoginViewController()
        vc.delegate = self
        return vc
    }()

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
            animationView.play { (_) in
                self.animationView.removeFromSuperview()
            }
            shouldDisplayAnimationOnNextAppearance = false
        }

        let testUser = HIUser(loginMethod: .userPass, permissions: .hacker, token: "toktok", identifier: "rauhul")
        print(Keychain.default.store(testUser, forKey: testUser.identifier))
        refreshKeychainContents()

        for key in Keychain.default.allKeys() {
            let retrievedValue = Keychain.default.retrieve(HIUser.self, forKey: key)
            print(retrievedValue ?? "retrieve failed")
        }
    }

    // MARK: - Login Flow
    func validateLogin(user: HIUser, failure: Void) {

        loginSucceeded(user: user)
    }

    func loginSucceeded(user: HIUser) {
        var user = user
        user.isActive = true
        Keychain.default.store(user, forKey: user.identifier)
        refreshKeychainContents()
        delegate?.loginFlowController(self, didLoginWith: user)
    }
}

// MARK: - Keychain
extension HILoginFlowController {
    func refreshKeychainContents() {
        keychainContents = Keychain.default.allKeys().sorted { $0 < $1 }
        loginSelectionViewController.tableView?.reloadData()
    }

    func removeUser(id: String) {
        Keychain.default.removeObject(forKey: id)
    }

    func keychainRetrievalSucceeded(user: HIUser) {
        // TODO: validation in the future
        // FIXME: theres a chance that a recovered github account will have a token that is revoked, we should probably validate this token.
        // low chance of this happening in 48 hours, fix it later.
        // this is also a concern for user-pass logins

        validateLogin(user: user, failure: ())
    }

    func keychainRetrievalFailed(id: String) {
        removeUser(id: id)
        refreshKeychainContents()
        let alert = UIAlertController(title: "Account Switch Failed", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

// MARK: - HILoginSelectionViewControllerDelegate
extension HILoginFlowController: HILoginSelectionViewControllerDelegate {
    func loginSelectionViewControllerKeychainAccounts(_ loginSelectionViewController: HILoginSelectionViewController) -> [String] {
        return keychainContents
    }

    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController, didMakeLoginSelection selection: HILoginMethod, withUserInfo info: String?) {
        switch selection {
        case .github:
            print("URL::", HIAuthService.githubLoginURL())
            loginSession = SFAuthenticationSession(url: HIAuthService.githubLoginURL(), callbackURLScheme: nil) { [weak self] (url, error) in
                print(url ?? "", error ?? "")
                if let url = url,
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                    let queryItems = components.queryItems,
                    let token = queryItems.first(where: { $0.name == "token" })?.value {
                    // TODO: add where token.stripping(newlineAndWhitespace Characters) != ""

                    // TODO: add permissions
                    print(token)
                    let newUser = HIUser(loginMethod: .github, permissions: .hacker, token: token, identifier: "")
                    self?.loginSucceeded(user: newUser)
                }

                // TODO: clean this code
                if let error = error {
                    do {
                        throw error
                    } catch SFAuthenticationError.canceledLogin {
                        // do nothing
                    } catch {
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
        .onSuccess { [weak self] (authContained) in

            _ = HIUser(loginMethod: .userPass, permissions: .hacker, token: authContained.data[0].auth, identifier: "")

            DispatchQueue.main.async {
                self?.userPassLoginViewController.stylizeFor(.readyToLogin)
            }

            print(authContained)
        }
        .onFailure { [weak self] (error) in
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

            DispatchQueue.main.async {
                // shake with error
                self?.userPassLoginViewController.stylizeFor(.readyToLogin)
            }
        }
        .perform()
    }
}
