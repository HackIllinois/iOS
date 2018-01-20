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

    func userPassLoginViewControllerDidSelectLoginButton(_ userPassLoginViewController: HIUserPassLoginViewController, forUsername username: String, andPassword password: String)

    func userPassLoginViewControllerStyleFor(_ userPassLoginViewController: HIUserPassLoginViewController) -> HIUserPassLoginViewControllerStyle
}

enum HIUserPassLoginViewControllerStyle {
    case currentlyPerformingLogin
    case readyToLogin
}

class HIUserPassLoginViewController: HIBaseViewController {
    // MARK: - Properties
    weak var delegate: HIUserPassLoginViewControllerDelegate?

    var activityIndicator = UIActivityIndicatorView()

    // MARK: - Outlets
    var usernameTextFeild = UITextField()
    var passwordTextFeild = UITextField()
    var signInButton = UIButton()
}

// MARK: - Actions
extension HIUserPassLoginViewController {
    @objc func didSelectBack(_ sender: UIButton) {
        delegate?.userPassLoginViewControllerDidSelectBackButton(self)
    }

    @objc func didSelectLogin(_ sender: UIButton) {
        guard let username = usernameTextFeild.text, let password = passwordTextFeild.text else { return }
        delegate?.userPassLoginViewControllerDidSelectLoginButton(self, forUsername: username, andPassword: password)
    }
}

// MARK: - UIViewController
extension HIUserPassLoginViewController {

    override func loadView() {
        super.loadView()

        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(HIColor.hotPink, for: .normal)
        backButton.addTarget(self, action: #selector(HIUserPassLoginViewController.didSelectBack(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 29).isActive = true


        let logInLabel = UILabel()
        logInLabel.text = "LOG IN"
        logInLabel.textColor = HIColor.hotPink
        logInLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        logInLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logInLabel)
        logInLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 54).isActive = true
        logInLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 29).isActive = true
        logInLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -29).isActive = true
        logInLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true


        usernameTextFeild.placeholder = "USERNAME"
        usernameTextFeild.textColor = HIColor.darkIndigo
        usernameTextFeild.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        usernameTextFeild.textContentType = .username
        usernameTextFeild.tintColor = HIColor.hotPink
        usernameTextFeild.autocapitalizationType = .none
        usernameTextFeild.autocorrectionType = .no
        usernameTextFeild.enablesReturnKeyAutomatically = true
        usernameTextFeild.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameTextFeild)
        usernameTextFeild.topAnchor.constraint(equalTo: logInLabel.bottomAnchor, constant: 23).isActive = true
        usernameTextFeild.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        usernameTextFeild.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        usernameTextFeild.heightAnchor.constraint(equalToConstant: 44).isActive = true


        let separatorView = UIView()
        separatorView.backgroundColor = HIColor.hotPink
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: usernameTextFeild.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 23).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -23).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true


        passwordTextFeild.placeholder = "PASSWORD"
        passwordTextFeild.textColor = HIColor.darkIndigo
        passwordTextFeild.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        passwordTextFeild.textContentType = .username
        passwordTextFeild.tintColor = HIColor.hotPink
        passwordTextFeild.autocapitalizationType = .none
        passwordTextFeild.autocorrectionType = .no
        passwordTextFeild.enablesReturnKeyAutomatically = true
        passwordTextFeild.isSecureTextEntry = true
        passwordTextFeild.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextFeild)
        passwordTextFeild.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        passwordTextFeild.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        passwordTextFeild.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        passwordTextFeild.heightAnchor.constraint(equalToConstant: 44).isActive = true


        signInButton.backgroundColor = HIColor.lightPeriwinkle
        signInButton.layer.cornerRadius = 8
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(HIColor.darkIndigo, for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        signInButton.addTarget(self, action: #selector(HIUserPassLoginViewController.didSelectLogin(_:)), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        signInButton.topAnchor.constraint(equalTo: passwordTextFeild.bottomAnchor, constant: 71).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true


        activityIndicator.tintColor = HIColor.hotPink
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: signInButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let style = delegate?.userPassLoginViewControllerStyleFor(self) ?? .readyToLogin
        stylizeFor(style)
    }
}

// MARK: - Responder Chain
extension HIUserPassLoginViewController {
    override func nextReponder(current: UIResponder) -> UIResponder? {
        switch current {
        case usernameTextFeild:
            return passwordTextFeild
        case passwordTextFeild:
            return nil
        default:
            return nil
        }
    }

    override func actionForFinalResponder() {
        guard let username = usernameTextFeild.text, let password = passwordTextFeild.text else { return }
        delegate?.userPassLoginViewControllerDidSelectLoginButton(self, forUsername: username, andPassword: password)
    }
}

// MARK: - Styling
extension HIUserPassLoginViewController {
    func stylizeFor(_ style: HIUserPassLoginViewControllerStyle) {
        switch style {
        case .currentlyPerformingLogin:
            signInButton.isEnabled = false
            signInButton.setTitle(nil, for: .normal)
            signInButton.backgroundColor = UIColor.gray
            activityIndicator.startAnimating()

        case .readyToLogin:
            signInButton.isEnabled = true
            signInButton.setTitle("Sign In", for: .normal)
            signInButton.backgroundColor = HIColor.lightPeriwinkle
            activityIndicator.stopAnimating()
        }
    }
}
