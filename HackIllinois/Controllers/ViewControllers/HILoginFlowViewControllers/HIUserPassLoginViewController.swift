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
    var emailTextField = UITextField()
    var passwordTextField = UITextField()
    var signInButton = UIButton()

    // MARK: - Init
    convenience init(delegate: HIUserPassLoginViewControllerDelegate) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }
}

// MARK: - Actions
extension HIUserPassLoginViewController {
    @objc func didSelectBack(_ sender: UIButton) {
        delegate?.userPassLoginViewControllerDidSelectBackButton(self)
    }

    @objc func didSelectLogin(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        delegate?.userPassLoginViewControllerDidSelectLoginButton(self, forEmail: email, andPassword: password)
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

        emailTextField.placeholder = "USERNAME"
        emailTextField.textColor = HIColor.darkIndigo
        emailTextField.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        emailTextField.textContentType = .username
        emailTextField.tintColor = HIColor.hotPink
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.enablesReturnKeyAutomatically = true
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: logInLabel.bottomAnchor, constant: 23).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let separatorView = UIView()
        separatorView.backgroundColor = HIColor.hotPink
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 23).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -23).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        passwordTextField.placeholder = "PASSWORD"
        passwordTextField.textColor = HIColor.darkIndigo
        passwordTextField.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        passwordTextField.textContentType = .username
        passwordTextField.tintColor = HIColor.hotPink
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.enablesReturnKeyAutomatically = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        signInButton.backgroundColor = HIColor.lightPeriwinkle
        signInButton.layer.cornerRadius = 8
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(HIColor.darkIndigo, for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        signInButton.addTarget(self, action: #selector(HIUserPassLoginViewController.didSelectLogin(_:)), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 71).isActive = true
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
            signInButton.isEnabled = false
            signInButton.setTitle(nil, for: .normal)
            signInButton.backgroundColor = UIColor.gray
            activityIndicator.startAnimating()

            emailTextField.text = nil
            passwordTextField.text = nil

        case .readyToLogin:
            signInButton.isEnabled = true
            signInButton.setTitle("Sign In", for: .normal)
            signInButton.backgroundColor = HIColor.lightPeriwinkle
            activityIndicator.stopAnimating()
        }
    }
}
