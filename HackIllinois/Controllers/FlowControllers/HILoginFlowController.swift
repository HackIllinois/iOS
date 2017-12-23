//
//  HILoginFlowController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 12/2/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import UIKit
import Lottie
import SafariServices

class HILoginFlowController: UIViewController {

    let animationView = LOTAnimationView(name: "data")
    var shouldDisplayAnimationOnNextAppearance = true

    var loginSession: SFAuthenticationSession?

    lazy var navController: UINavigationController = {
        let vc = UINavigationController(rootViewController: loginSelectionViewController)
        vc.isNavigationBarHidden = true
        return vc
    }()

    lazy var loginSelectionViewController: HILoginSelectionViewController = {
        let vc = UIStoryboard(.login).instantiate(HILoginSelectionViewController.self)
        vc.delegate = self
        return vc
    }()

    lazy var userPassLoginViewController: HIUserPassLoginViewController = {
        let vc = UIStoryboard(.login).instantiate(HIUserPassLoginViewController.self)
        vc.delegate = self
        return vc
    }()

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
    }
}

// MARK: - HILoginSelectionViewControllerDelegate
extension HILoginFlowController: HILoginSelectionViewControllerDelegate {
    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController, didMakeLoginSelection selection: HILoginSelectionViewController.SelectionType) {
        switch selection {
        case .hacker:
            loginSession = SFAuthenticationSession(url: HIAuthService.githubLoginURL(), callbackURLScheme: nil) { [weak self] (url, error) in
                if let url = url,
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                    let queryItems = components.queryItems,
                    let code = queryItems.first(where: { $0.name == "code" })?.value {
                    print("auth success", code)
                } else {
                    let alert = UIAlertController(title: "Authentication Failed", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            loginSession?.start()

        case .mentor, .staff, .volunteer:
            navController.pushViewController(userPassLoginViewController, animated: true)
        }
    }
}

// MARK: - HIUserPassLoginViewControllerDelegate
extension HILoginFlowController: HIUserPassLoginViewControllerDelegate {
    func userPassLoginViewControllerDidSelectBackButton(_ userPassLoginViewController: HIUserPassLoginViewController) {
        navController.popViewController(animated: true)
    }

    func userPassLoginViewControllerDidSelectLoginButton(_ userPassLoginViewController: HIUserPassLoginViewController, forUsername username: String, andPassword password: String) {

        HIAuthService.login(email: username, password: password)
        .onSuccess { (data) in
            print(data)
        }
        .onFailure { (reason) in
            print(reason)
        }
        .perform(withAuthorization: nil)

    }


}


