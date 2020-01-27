//
//  HIPopupController.swift
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

class HIPopupController: HIBaseViewController {
    // MARK: - Properties
    private let containerView = HIView {
        $0.layer.cornerRadius = 8
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
        $0.title = "  CLOSE"
        $0.titleLabel?.font = HIAppearance.Font.navigationTitle
        $0.titleLabel?.baselineAdjustment = .alignCenters
        $0.addTarget(self, action: #selector(didSelectClose(_:)), for: .touchUpInside)
    }
    private let logoutButton = HIButton {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleHIColor = \.qrTint
        $0.tintHIColor = \.qrBackground
        $0.baseImage = #imageLiteral(resourceName: "MenuClose")
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
    private let backgroundView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.clear
        $0.backgroundColor = .clear
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBackground(_:))))
        $0.isUserInteractionEnabled = true
    }
}

// MARK: - Actions
extension HIPopupController {
    @objc func didSelectLogoutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(title: "Logout", style: .destructive) { _ in
                NotificationCenter.default.post(name: .logoutUser, object: nil)
            }
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        present(alert, animated: true, completion: nil)
    }

    @objc func didSelectClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func didSelectBackground(_ sender: UITapGestureRecognizer) {
        print("TRYING TO DISMISS")
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIViewController
extension HIPopupController {
    override func loadView() {
        super.loadView()

        view.addSubview(containerView)

        containerView.addSubview(exitButton)
        containerView.addSubview(logoutButton)
        containerView.addSubview(qrContainerView)
        qrContainerView.addSubview(qrImageView)
        containerView.addSubview(userNameLabel)

        containerView.constrain(to: view.safeAreaLayoutGuide, trailingInset: -12, bottomInset: 32, leadingInset: 12)
        view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: 12).isActive = true

        exitButton.constrain(to: containerView, topInset: 18, leadingInset: 18)
        logoutButton.constrain(to: containerView, topInset: 18, trailingInset: -18)
        qrContainerView.constrain(to: containerView, topInset: 50, trailingInset: -32, leadingInset: 32)
        qrContainerView.bottomAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: -22).isActive = true

        userNameLabel.constrain(to: containerView, trailingInset: -32, leadingInset: 32)
        userNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -64).isActive = true

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

        view.backgroundColor = .clear

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
extension HIHomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HIPopinAnimator()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HIPopoutAnimator()
    }
}
