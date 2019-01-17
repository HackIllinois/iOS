//
//  HIUserPassLoginViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/30/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
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

    var emailTextField = HITextField(style: .username)
    var passwordTextField = HITextField(style: .password)
    var signInButton = HIButton(style: .async(title: "Sign In"))
    var containerView = UIView()

    // MARK: - Init
    init(delegate: HIUserPassLoginViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        signInButton.addTarget(self, action: #selector(didSelectLogin), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }
}

// MARK: - Actions
extension HIUserPassLoginViewController {
    @objc func didSelectBack() {
        delegate?.userPassLoginViewControllerDidSelectBackButton(self)
    }

    @objc func didSelectLogin() {
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
    // swiftlint:disable:next function_body_length
    override func loadView() {
        super.loadView()

        let backButton = HIButton(style: .icon(image: #imageLiteral(resourceName: "BackButton")))
        backButton.addTarget(self, action: #selector(didSelectBack), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 67).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let logInLabel = HILabel(style: .loginHeader)
        logInLabel.text = "LOG IN"
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

        containerView.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        let separatorView = HIView(style: .separator)
        containerView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true

        containerView.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        view.addSubview(signInButton)
        signInButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 71).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
            signInButton.setAsyncTask(running: true)
        case .readyToLogin:
            signInButton.setAsyncTask(running: false)
        }
    }
}
