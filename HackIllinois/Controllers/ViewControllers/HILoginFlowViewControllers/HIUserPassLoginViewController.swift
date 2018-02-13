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
    var containerView = UIView()

    // MARK: - Init
    init(delegate: HIUserPassLoginViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
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

    func shakeWithError() {
        let duration: TimeInterval = 0.5
        let translation: CGFloat = 15
        let viewCenter  = containerView.center
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        animator.addAnimations {
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeCubic], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.125) {
                    self.containerView.center  = CGPoint(x: viewCenter.x + translation, y: viewCenter.y)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.125, relativeDuration: 0.25) {
                    self.containerView.center  = CGPoint(x: viewCenter.x - (translation - 3), y: viewCenter.y)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.375, relativeDuration: 0.25) {
                    self.containerView.center  = CGPoint(x: viewCenter.x + (translation - 6), y: viewCenter.y)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.625, relativeDuration: 0.25) {
                    self.containerView.center  = CGPoint(x: viewCenter.x - (translation - 9), y: viewCenter.y)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.875, relativeDuration: 0.125) {
                    self.containerView.center  = viewCenter
                }
            })
        }
        animator.startAnimation()
    }
}

// MARK: - UIViewController
extension HIUserPassLoginViewController {

    override func loadView() {
        super.loadView()

        let backButton = UIButton(type: .system)
        backButton.setImage(#imageLiteral(resourceName: "BackButton"), for: .normal)
        backButton.tintColor = HIApplication.Color.hotPink
        backButton.addTarget(self, action: #selector(didSelectBack(_:)), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 67).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let logInLabel = UILabel()
        logInLabel.text = "LOG IN"
        logInLabel.textColor = HIApplication.Color.hotPink
        logInLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        logInLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logInLabel)
        logInLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 54).isActive = true
        logInLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 29).isActive = true
        logInLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -29).isActive = true
        logInLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true

        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: logInLabel.bottomAnchor, constant: 23).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 89).isActive = true

        emailTextField.placeholder = "USERNAME"
        emailTextField.textColor = HIApplication.Color.darkIndigo
        emailTextField.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        emailTextField.textContentType = .username
        emailTextField.tintColor = HIApplication.Color.hotPink
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.enablesReturnKeyAutomatically = true
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let separatorView = UIView()
        separatorView.backgroundColor = HIApplication.Color.hotPink
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        passwordTextField.placeholder = "PASSWORD"
        passwordTextField.textColor = HIApplication.Color.darkIndigo
        passwordTextField.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        passwordTextField.textContentType = .username
        passwordTextField.tintColor = HIApplication.Color.hotPink
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.enablesReturnKeyAutomatically = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        signInButton.backgroundColor = HIApplication.Color.lightPeriwinkle
        signInButton.layer.cornerRadius = 8
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(HIApplication.Color.darkIndigo, for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        signInButton.addTarget(self, action: #selector(didSelectLogin(_:)), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
        signInButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 71).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        activityIndicator.tintColor = HIApplication.Color.hotPink
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
        emailTextField.text = nil
        passwordTextField.text = nil
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

        case .readyToLogin:
            signInButton.isEnabled = true
            signInButton.setTitle("Sign In", for: .normal)
            signInButton.backgroundColor = HIApplication.Color.lightPeriwinkle
            activityIndicator.stopAnimating()
        }
    }
}
