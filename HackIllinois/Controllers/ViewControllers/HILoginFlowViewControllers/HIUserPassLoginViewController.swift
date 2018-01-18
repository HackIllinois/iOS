//
//  HIUserPassLoginViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/30/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

protocol HIUserPassLoginViewControllerDelegate: class {
    func userPassLoginViewControllerDidSelectBackButton(_ userPassLoginViewController: HIUserPassLoginViewController)

    func userPassLoginViewControllerDidSelectLoginButton(_ userPassLoginViewController: HIUserPassLoginViewController, forEmail email: String, andPassword password: String)
}

enum HIUserPassLoginViewControllerStyle {
    case currentlyPerformingLogin
    case readyToLogin
}

class HIUserPassLoginViewController: HIBaseViewController {
    // MARK: - Properties
    weak var delegate: HIUserPassLoginViewControllerDelegate?
    var activityIndicator = UIActivityIndicatorView()
    var originalLoginButtonColor: UIColor?

    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
}

// MARK: - Actions
extension HIUserPassLoginViewController {
    @IBAction func didSelectBack(_ sender: UIButton) {
        delegate?.userPassLoginViewControllerDidSelectBackButton(self)
    }

    @IBAction func didSelectLogin(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        delegate?.userPassLoginViewControllerDidSelectLoginButton(self, forEmail: email, andPassword: password)
    }
}

// MARK: - UIViewController
extension HIUserPassLoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stylizeFor(.readyToLogin)
    }
}

// MARK: - Responder Chain
extension HIUserPassLoginViewController {
    override func nextReponder(current: UIResponder) -> UIResponder? {
        switch current {
        case emailTextField:
            return passwordTextField
        case passwordTextField:
            return nil
        default:
            return nil
        }
    }

    override func actionForFinalResponder() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        delegate?.userPassLoginViewControllerDidSelectLoginButton(self, forEmail: email, andPassword: password)
    }
}

// MARK: - Styling
extension HIUserPassLoginViewController {
    func stylizeFor(_ style: HIUserPassLoginViewControllerStyle) {
        switch style {
        case .currentlyPerformingLogin:
            loginButton.isEnabled = false
            loginButton.setTitle(nil, for: .normal)
            originalLoginButtonColor = loginButton.backgroundColor
            loginButton.backgroundColor = UIColor.gray

            activityIndicator.startAnimating()

        case .readyToLogin:
            loginButton.isEnabled = true
            loginButton.setTitle("Login", for: .normal)
            loginButton.backgroundColor = originalLoginButtonColor

            activityIndicator.stopAnimating()
        }
    }
}
