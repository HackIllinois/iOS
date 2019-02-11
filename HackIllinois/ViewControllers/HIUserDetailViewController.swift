//
//  HIUserDetailViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/18/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import PassKit
import os
import HIAPI

class HIUserDetailViewController: HIBaseViewController {
    // MARK: - Properties
    private let userDetailContainer = HIView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.contentBackground
    }
    private let qrImageView = HIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintHIColor = \.action
    }
    private let userNameLabel = HILabel {
        $0.textHIColor = \.baseText
        $0.backgroundHIColor = \.contentBackground
        $0.font = HIAppearance.Font.navigationTitle
        $0.textAlignment = .center
    }
    private let userInfoLabel = HILabel {
        $0.textHIColor = \.baseText
        $0.backgroundHIColor = \.contentBackground
        $0.font = HIAppearance.Font.contentText
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
}

// MARK: - Actions
extension HIUserDetailViewController {
    @objc func didSelectLogoutButton(_ sender: Any) {
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
}

// MARK: - UIViewController
extension HIUserDetailViewController {
    override func loadView() {
        super.loadView()

        view.addSubview(userDetailContainer)
        userDetailContainer.constrain(to: view.safeAreaLayoutGuide, topInset: 13, trailingInset: -12, leadingInset: 12)

        userDetailContainer.addSubview(qrImageView)
        qrImageView.constrain(to: userDetailContainer, topInset: 32, trailingInset: -32, leadingInset: 32)
        qrImageView.heightAnchor.constraint(equalTo: qrImageView.widthAnchor).isActive = true

        let userDataStackView = UIStackView()
        userDataStackView.axis = .vertical
        userDataStackView.spacing = 2
        userDataStackView.alignment = .center
        userDataStackView.distribution = .fill
        userDataStackView.translatesAutoresizingMaskIntoConstraints = false
        userDetailContainer.addSubview(userDataStackView)
        userDataStackView.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 22).isActive = true
        userDataStackView.constrain(to: userDetailContainer, trailingInset: -32, bottomInset: -32, leadingInset: 32)

        userDataStackView.addArrangedSubview(userNameLabel)
        userDataStackView.addArrangedSubview(userInfoLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = HIApplicationStateController.shared.user,
            let url = user.qrURL else { return }
        view.layoutIfNeeded()
        let frame = qrImageView.frame.height
        DispatchQueue.global(qos: .userInitiated).async {
            let qrImage = UIImage(qrString: url.absoluteString, size: frame)?.withRenderingMode(.alwaysTemplate)
            DispatchQueue.main.async {
                self.qrImageView.image = qrImage
            }
        }
        userNameLabel.text = user.firstName.uppercased()
        userInfoLabel.text = user.attendee?.diet.description ?? "NO DIETARY RESTRICTIONS"
        setupPass()
    }
}

// MARK: - Passbook/Wallet support
extension HIUserDetailViewController {
    func setupPass() {
        guard PKPassLibrary.isPassLibraryAvailable(),
            let user = HIApplicationStateController.shared.user,
            let url = user.qrURL,
            !UserDefaults.standard.bool(forKey: HIConstants.PASS_PROMPTED_KEY(user: user)) else { return }
        let passUrl = "\(url.absoluteString)&identifier=\(user.email)"
        HIAPI.PassService.getPass(with: passUrl)
        .onCompletion { result in
            do {
                let (data, _) = try result.get()
                let pass = try PKPass(data: data)
                let passVC: PKAddPassesViewController
                if let vc = PKAddPassesViewController(pass: pass) {
                    passVC = vc
                } else {
                    throw HIError.passbookError
                }
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self {
                        UserDefaults.standard.set(true, forKey: HIConstants.PASS_PROMPTED_KEY(user: user))
                        strongSelf.present(passVC, animated: true, completion: nil)
                    }
                }
            } catch {
                os_log(
                    "Error initializing PKPass: %s",
                    log: Logger.ui,
                    type: .error,
                    error.localizedDescription
                )
            }
        }
        .launch()
    }
}

// MARK: - UINavigationItem Setup
extension HIUserDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "BADGE"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "LogoutButton"), style: .plain, target: self, action: #selector(didSelectLogoutButton(_:)))
    }
}
