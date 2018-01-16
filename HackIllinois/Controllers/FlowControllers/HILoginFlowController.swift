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

    // MARK: Properties
    let animationView = LOTAnimationView(name: "data")
    var shouldDisplayAnimationOnNextAppearance = true
    var userPassRequestToken: APIRequestToken?

    // keeps the login session from going out of scope during presentation
    var loginSession: SFAuthenticationSession?

    // MARK: ViewControllers
    lazy var navController: UINavigationController = {
        let vc = UINavigationController(rootViewController: userPassLoginViewController)
        vc.isNavigationBarHidden = true
        return vc
    }()

    lazy var loginSelectionViewController: HILoginSelectionViewController = {
        let vc = UIStoryboard(.login).instantiate(HILoginSelectionViewController.self)
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
            animationView.play { (finished) in
                self.animationView.removeFromSuperview()
            }
            shouldDisplayAnimationOnNextAppearance = false
        }
//        let testUser = HIUser(loginMethod: HIUser.LoginMethod.github, token: "testtokebnenenen", identifier: "rauhul - github")


        print(Keychain.default.allKeys())
//        print(Keychain.default.store(testUser, forKey: testUser.identifier))
//        print(Keychain.default.allKeys())

        for key in Keychain.default.allKeys() {
            let retrievedValue = Keychain.default.retrieve(HIUser.self, forKey: key)
            print(retrievedValue ?? "retrieve failed")
        }
    }

    // MARK: Login Flow


}

// MARK: - HILoginSelectionViewControllerDelegate
extension HILoginFlowController: HILoginSelectionViewControllerDelegate {
    func loginSelectionViewControllerKeychainAccounts(_ loginSelectionViewController: HILoginSelectionViewController) -> [String] {

        return []
    }

    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController, didMakeLoginSelection selection: HILoginMethod) {
        switch selection {
        case .github:
            loginSession = SFAuthenticationSession(url: HIAuthService.githubLoginURL(), callbackURLScheme: nil) { [weak self] (url, error) in
                print(url ?? "", error ?? "")
                if let url = url,
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                    let queryItems = components.queryItems,
                    let code = queryItems.first(where: { $0.name == "token" })?.value {
                    print("auth success", code)
                } else {
                    let alert = UIAlertController(title: "Authentication Failed", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            loginSession?.start()

        case .userPass:
            navController.pushViewController(userPassLoginViewController, animated: true)

        case .existing:
            // TODO: write this case
            break
        }
    }
}

// MARK: - HIUserPassLoginViewControllerDelegate
extension HILoginFlowController: HIUserPassLoginViewControllerDelegate {
    func userPassLoginViewControllerDidSelectBackButton(_ userPassLoginViewController: HIUserPassLoginViewController) {

//        cancellogin?
        navController.popViewController(animated: true)
    }

    func userPassLoginViewControllerDidSelectLoginButton(_ userPassLoginViewController: HIUserPassLoginViewController, forUsername username: String, andPassword password: String) {
        let style = userPassLoginViewControllerStyleFor(userPassLoginViewController)
        userPassLoginViewController.stylizeFor(style)

        userPassRequestToken = HIAuthService.login(email: username, password: password)
        .onSuccess { [weak self] (data) in

            DispatchQueue.main.async {
                if let strongSelf = self {
                    let style = strongSelf.userPassLoginViewControllerStyleFor(userPassLoginViewController)
                    strongSelf.userPassLoginViewController.stylizeFor(style)
                }
            }

            print(data)
        }
        .onFailure { [weak self] (reason) in
            print(reason)

            DispatchQueue.main.async {
                if let strongSelf = self {
                    let style = strongSelf.userPassLoginViewControllerStyleFor(userPassLoginViewController)
                    strongSelf.userPassLoginViewController.stylizeFor(style)
                }
            }
        }
        .perform()
    }

    func userPassLoginViewControllerStyleFor(_ userPassLoginViewController: HIUserPassLoginViewController) -> HIUserPassLoginViewControllerStyle {
        guard let state = userPassRequestToken?.state else { return .readyToLogin }
        return state == .running ? .currentlyPerformingLogin : .readyToLogin
    }
}


