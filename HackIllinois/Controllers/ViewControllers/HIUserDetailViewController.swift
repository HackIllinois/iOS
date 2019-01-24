//
//  HIUserDetailViewController.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 1/18/18.
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

class HIUserDetailViewController: HIBaseViewController {
    // MARK: - Properties
    var qrImageView = HIImageView(style: .template)
    var userNameLabel = HILabel(style: .title)
    var userInfoLabel = HILabel(style: .subtitle)
}

// MARK: - Actions
extension HIUserDetailViewController {
    @objc func didSelectLogoutButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(title: "Switch User", style: .default) { _ in
                NotificationCenter.default.post(name: .switchUser, object: nil)
            }
        )
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

        let userDetailContainer = HIView(style: .content)
        view.addSubview(userDetailContainer)
        userDetailContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        userDetailContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        userDetailContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true

        qrImageView.translatesAutoresizingMaskIntoConstraints = false
        userDetailContainer.addSubview(qrImageView)
        qrImageView.topAnchor.constraint(equalTo: userDetailContainer.topAnchor, constant: 32).isActive = true
        qrImageView.leadingAnchor.constraint(equalTo: userDetailContainer.leadingAnchor, constant: 32).isActive = true
        qrImageView.trailingAnchor.constraint(equalTo: userDetailContainer.trailingAnchor, constant: -32).isActive = true
        qrImageView.heightAnchor.constraint(equalTo: qrImageView.widthAnchor).isActive = true

        let userDataStackView = UIStackView()
        userDataStackView.axis = .vertical
        userDataStackView.alignment = .fill
        userDataStackView.distribution = .fillProportionally
        userDataStackView.translatesAutoresizingMaskIntoConstraints = false
        userDetailContainer.addSubview(userDataStackView)
        userDataStackView.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 22).isActive = true
        userDataStackView.leadingAnchor.constraint(equalTo: userDetailContainer.leadingAnchor, constant: 32).isActive = true
        userDataStackView.bottomAnchor.constraint(equalTo: userDetailContainer.bottomAnchor, constant: -32).isActive = true
        userDataStackView.trailingAnchor.constraint(equalTo: userDetailContainer.trailingAnchor, constant: -32).isActive = true
        userDataStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        userInfoLabel.textAlignment = .center
        userDataStackView.addArrangedSubview(userNameLabel)
        userDataStackView.addArrangedSubview(userInfoLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = HIApplicationStateController.shared.user,
            let url = URL(string: "hackillinois://qrcode/user?id=\(user.id)&identifier=\(user)") else { return }
        view.layoutIfNeeded()
        let frame = qrImageView.frame.height
        DispatchQueue.global(qos: .userInitiated).async {
            let qrImage = UIImage(qrString: url.absoluteString, size: frame)?.withRenderingMode(.alwaysTemplate)
            DispatchQueue.main.async {
                self.qrImageView.image = qrImage
            }
        }
        userNameLabel.text = (user.firstName).uppercased()
        userInfoLabel.text = user.dietaryRestrictions.displayText
        setupPass()
    }
}

// MARK: - Passbook/Wallet support
extension HIUserDetailViewController {
    func setupPass() {
        guard PKPassLibrary.isPassLibraryAvailable(),
            let user = HIApplicationStateController.shared.user,
            !UserDefaults.standard.bool(forKey: "HIAPPLICATION_PASS_PROMPTED_\(user.id)") else { return }
        let passString = "hackillinois://qrcode/user?id=\(user.id)&identifier=\(user.id)"
        HIPassService.getPass(with: passString)
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
                        UserDefaults.standard.set(true, forKey: "HIAPPLICATION_PASS_PROMPTED_\(user.id)")
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
