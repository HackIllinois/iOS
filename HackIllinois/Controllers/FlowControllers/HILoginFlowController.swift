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
        animationView.contentMode = .scaleAspectFill
        animationView.frame = view.frame
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(animationView)
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
            let url = URL(string: "http://ec2-107-20-14-41.compute-1.amazonaws.com/v1/auth?callbackUrl=hackillinois://")!
//            UIApplication.shared.open(URL(string: "http://ec2-107-20-14-41.compute-1.amazonaws.com/v1/auth")!, options: [:], completionHandler: nil)

            loginSession = SFAuthenticationSession(url: url, callbackURLScheme: "hackillinois://") { (url, error) in
                print(url ?? "empty url", error?.localizedDescription ?? "no error")
            }
            loginSession?.start()


//            if let loginViewController = HIAuthService.loginViewController() {
//                loginSelectionViewController.present(loginViewController, animated: true, completion: nil)
//            } else {
//                loginSelectionViewController.presentErrorController(title: "Error", message: "Internal Error.", dismissParentOnCompletion: false)
//            }

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


