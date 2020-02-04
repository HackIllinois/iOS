//
//  HIPopupViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/9/20.
//  Copyright © 2020 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI

class HIPopupViewController: HIBaseViewController {
    // MARK: - Properties
    private let containerView = HIView {
        $0.layer.cornerRadius = 32
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.qrBackground
    }
    private let exitButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintHIColor = \.qrTint
        $0.titleHIColor = \.qrTint
        $0.backgroundHIColor = \.qrBackground
        $0.baseImage = #imageLiteral(resourceName: "MenuClose")
        $0.titleLabel?.font = HIAppearance.Font.navigationTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.addTarget(self, action: #selector(didSelectClose(_:)), for: .touchUpInside)
    }
    private let logoutButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleHIColor = \.qrTint
        $0.tintHIColor = \.qrBackground
        $0.backgroundHIColor = \.qrBackground
        $0.title = "LOG OUT"
        $0.titleLabel?.font = HIAppearance.Font.navigationTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.addTarget(self, action: #selector(didSelectLogoutButton(_:)), for: .touchUpInside)
    }
    private let qrContainerView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.qrBackground
    }
    private let qrImageView = HITintImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintHIColor = \.qrTint
        $0.contentMode = .scaleAspectFit
    }
    private let userNameLabel = HILabel {
        $0.textHIColor = \.qrTint
        $0.backgroundHIColor = \.qrBackground
        $0.font = HIAppearance.Font.contentTitle
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    private let popupBackground = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.clear
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
    }
}

// MARK: - Actions
extension HIPopupViewController {
    @objc func didSelectLogoutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(title: "Logout", style: .destructive) { _ in
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .logoutUser, object: nil)
            }
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        alert.popoverPresentationController?.sourceView = sender
        present(alert, animated: true, completion: nil)
    }

    @objc func didSelectClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func didSelectBackground(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func didSwipeDown(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIViewController
extension HIPopupViewController {
    override func loadView() {
        super.loadView()
        view.addSubview(popupBackground)
        view.addSubview(containerView)

        popupBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        popupBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        popupBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        popupBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        containerView.addSubview(exitButton)
        containerView.addSubview(logoutButton)
        containerView.addSubview(qrContainerView)
        qrContainerView.addSubview(qrImageView)
        containerView.addSubview(userNameLabel)

        containerView.constrain(to: view.safeAreaLayoutGuide, trailingInset: -8, leadingInset: 8)
        view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: 12).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -22).isActive = true

        exitButton.constrain(to: containerView, topInset: 22, leadingInset: 32)
        logoutButton.constrain(to: containerView, topInset: 22, trailingInset: -32)
        qrContainerView.constrain(to: containerView, topInset: 54, trailingInset: -32, leadingInset: 32)
        qrContainerView.bottomAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: -22).isActive = true

        userNameLabel.constrain(to: containerView, trailingInset: -32, leadingInset: 32)
        userNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32).isActive = true

        qrImageView.centerXAnchor.constraint(equalTo: qrContainerView.centerXAnchor).isActive = true
        qrImageView.centerYAnchor.constraint(equalTo: qrContainerView.centerYAnchor).isActive = true

        qrImageView.topAnchor.constraint(greaterThanOrEqualTo: qrContainerView.topAnchor).isActive = true
        qrImageView.leadingAnchor.constraint(greaterThanOrEqualTo: qrContainerView.leadingAnchor).isActive = true
        qrContainerView.trailingAnchor.constraint(greaterThanOrEqualTo: qrImageView.trailingAnchor).isActive = true
        qrContainerView.bottomAnchor.constraint(greaterThanOrEqualTo: qrImageView.bottomAnchor).isActive = true

        qrImageView.widthAnchor.constraint(equalTo: qrImageView.heightAnchor, multiplier: 1).isActive = true

        let width = qrImageView.widthAnchor.constraint(equalTo: qrContainerView.widthAnchor, multiplier: 1)
        width.priority = UILayoutPriority(rawValue: 500)
        width.isActive = true
        let height = qrImageView.heightAnchor.constraint(equalTo: qrContainerView.heightAnchor, multiplier: 1)
        height.priority = UILayoutPriority(rawValue: 500)
        height.isActive = true

        popupBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBackground(_:))))
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown(_:)))
        swipeDownRecognizer.direction = .down
        containerView.addGestureRecognizer(swipeDownRecognizer)

        view.backgroundColor = .clear
        self.backgroundView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = HIApplicationStateController.shared.user,
            let url = user.qrURL else { return }
        view.layoutIfNeeded()
        let size = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        DispatchQueue.global(qos: .userInitiated).async {
            let qrImage = UIImage(qrString: url.absoluteString, size: size)?.withRenderingMode(.alwaysTemplate)
            DispatchQueue.main.async {
                self.qrImageView.image = qrImage
            }
        }
        userNameLabel.text = user.firstName.uppercased()
    }
}
// MARK: - UIViewControllerTransitioningDelegate
extension HIPopupViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HIPopinAnimator()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HIPopoutAnimator()
    }
}
