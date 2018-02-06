//
//  HIUserDetailViewController.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 1/18/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIUserDetailViewController: HIBaseViewController {
    // MARK: - Properties
    var qrCode = UIImageView()
    var userNameLabel = UILabel()
    var userInfoLabel = UILabel()
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

        let userDetailContainer = UIView()
        userDetailContainer.layer.cornerRadius = 8
        userDetailContainer.backgroundColor = HIApplication.Color.white
        userDetailContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDetailContainer)
        userDetailContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        userDetailContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        userDetailContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true

        qrCode.backgroundColor = HIApplication.Color.darkIndigo
        qrCode.translatesAutoresizingMaskIntoConstraints = false
        userDetailContainer.addSubview(qrCode)
        qrCode.topAnchor.constraint(equalTo: userDetailContainer.topAnchor, constant: 32).isActive = true
        qrCode.leadingAnchor.constraint(equalTo: userDetailContainer.leadingAnchor, constant: 32).isActive = true
        qrCode.trailingAnchor.constraint(equalTo: userDetailContainer.trailingAnchor, constant: -32).isActive = true
        qrCode.heightAnchor.constraint(equalTo: qrCode.widthAnchor).isActive = true

        let userDataStackView = UIStackView()
        userDataStackView.axis = .vertical
        userDataStackView.alignment = .fill
        userDataStackView.distribution = .fillProportionally
        userDataStackView.translatesAutoresizingMaskIntoConstraints = false
        userDetailContainer.addSubview(userDataStackView)
        userDataStackView.topAnchor.constraint(equalTo: qrCode.bottomAnchor, constant: 22).isActive = true
        userDataStackView.leadingAnchor.constraint(equalTo: userDetailContainer.leadingAnchor, constant: 32).isActive = true
        userDataStackView.bottomAnchor.constraint(equalTo: userDetailContainer.bottomAnchor, constant: -32).isActive = true
        userDataStackView.trailingAnchor.constraint(equalTo: userDetailContainer.trailingAnchor, constant: -32).isActive = true
        userDataStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        userNameLabel.text = "ASDJH SADHJL ASD"
        userNameLabel.textAlignment = .center
        userNameLabel.textColor = HIApplication.Color.darkIndigo
        userNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userDataStackView.addArrangedSubview(userNameLabel)

        userInfoLabel.text = "NO DIETARY RESTRICTIONS"
        userInfoLabel.textAlignment = .center
        userInfoLabel.textColor = HIApplication.Color.hotPink
        userInfoLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        userInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        userDataStackView.addArrangedSubview(userInfoLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = HIApplicationStateController.shared.user,
            let url = URL(string: "hackillinois://qrcode/user?id=\(user.id)&identifier=\(user.identifier)") else { return }
        view.layoutIfNeeded()
        qrCode.image = QRCode(string: url.absoluteString, size: qrCode.frame.height)?.image
    }
}

// MARK: - UINavigationItem Setup
extension HIUserDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "PROFILE"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "LogoutButton"), style: .plain, target: self, action: #selector(HIUserDetailViewController.didSelectLogoutButton(_:)))
    }
}
