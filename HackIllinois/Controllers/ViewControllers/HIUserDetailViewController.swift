//
//  HIUserDetailViewController.swift
//  HackIllinois
//
//  Created by Sujay Patwardhan on 1/18/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import PassKit
import AudioToolbox

class HIUserDetailViewController: HIBaseViewController {
    // MARK: - Properties
    var qrCode = UIImageView()
    var userNameLabel = HILabel(style: .title)
    var userInfoLabel = HILabel(style: .subtitle)
    private var recognizer: UILongPressGestureRecognizer!
    private var userDetailContainer: HIView!

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
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

        userDetailContainer = HIView(style: .content)
        view.addSubview(userDetailContainer)
        userDetailContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13).isActive = true
        userDetailContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        userDetailContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true

        qrCode.backgroundColor = HIApplication.Palette.current.primary
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

        userInfoLabel.textAlignment = .center
        userDataStackView.addArrangedSubview(userNameLabel)
        userDataStackView.addArrangedSubview(userInfoLabel)

//        let recognizer = HIForceGestureRecognizer(target: self, action: #selector(forceTouchSetupPass))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = HIApplicationStateController.shared.user,
              let url = URL(string: "hackillinois://qrcode/user?id=\(user.id)&identifier=\(user.identifier)") else { return }
        view.layoutIfNeeded()
        setupQRCode(user: user, url: url)
        userNameLabel.text = (user.name ?? user.identifier).uppercased()
        userInfoLabel.text = user.dietaryRestrictions?.displayText ?? "UNKNOWN DIETARY RESTRICTIONS"

        recognizer = UILongPressGestureRecognizer(target: self, action: #selector(forceTouchSetupPass))
        recognizer.minimumPressDuration = 0.5
        userDetailContainer.isUserInteractionEnabled = true
        userDetailContainer.addGestureRecognizer(recognizer)

        setupPass()
    }
}

// MARK: - QRCode Setup
extension HIUserDetailViewController {
    func setupQRCode(user: HIUser, url: URL) {
        let frame = qrCode.frame.height
        let passString = "hackillinois://qrcode/user?id=\(user.id)&identifier=\(user.identifier)"
        let qrCodeKey = CacheController.shared.getQRCodeKey(uniquePassString: passString)
        if let cachedImage = CacheController.shared.qrCodeCache.object(forKey: qrCodeKey) {
            print("USED CACHED IMAGE")
            DispatchQueue.main.async {
                self.qrCode.image = cachedImage
            }
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                if let qrCodeImage = QRCode(string: url.absoluteString, size: frame)?.image {
                    DispatchQueue.main.async {
                        self.qrCode.image = qrCodeImage
                        CacheController.shared.qrCodeCache.setObject(qrCodeImage, forKey: qrCodeKey)
                    }
                }
            }
        }
    }
}

// MARK: - Passbook/Wallet support
extension HIUserDetailViewController {
    @objc func forceTouchSetupPass(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            print("actived touch")
            userDetailContainer.removeGestureRecognizer(sender)
            guard let user = HIApplicationStateController.shared.user else { return }
            UserDefaults.standard.set(false, forKey: "HIAPPLICATION_PASS_PROMPTED_\(user.id)")
            setupPass()
        default:
            print("shouldn't happen")
        }
    }
    func setupPass() {
        guard PKPassLibrary.isPassLibraryAvailable(),
              let user = HIApplicationStateController.shared.user,
              !UserDefaults.standard.bool(forKey: "HIAPPLICATION_PASS_PROMPTED_\(user.id)") else { return }
        let passString = "hackillinois://qrcode/user?id=\(user.id)&identifier=\(user.identifier)"
        let pkPassKey = CacheController.shared.getPKPassKey(uniquePassString: passString)
        if let cachedPass = CacheController.shared.pkPassCache.object(forKey: pkPassKey) {
            print("USED CACHED PKPASS")
            if PKPassLibrary().containsPass(cachedPass) {
                print("IT WAS ALREADY THERE")
                userDetailContainer.removeGestureRecognizer(recognizer)
                return
            }
            let vc = PKAddPassesViewController(pass: cachedPass)
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    UserDefaults.standard.set(true, forKey: "HIAPPLICATION_PASS_PROMPTED_\(user.id)")
                    strongSelf.present(vc, animated: true, completion: nil)
                    AudioServicesPlaySystemSound(1520)
                }
            }
        } else {
            HIPassService.getPass(with: passString)
                .onCompletion { result in
                    switch result {
                    case .success(let data):
                        let pass = PKPass(data: data, error: nil)
                        CacheController.shared.pkPassCache.setObject(pass, forKey: pkPassKey)
                        if PKPassLibrary().containsPass(pass) {
                            return
                        }
                        let vc = PKAddPassesViewController(pass: pass)
                        DispatchQueue.main.async { [weak self] in
                            if let strongSelf = self {
                                UserDefaults.standard.set(true, forKey: "HIAPPLICATION_PASS_PROMPTED_\(user.id)")
                                strongSelf.present(vc, animated: true, completion: nil)
                                AudioServicesPlaySystemSound(1520)
                            }
                        }
                    case .cancellation:
                        break
                    case .failure(let error):
                        print(error)
                    }
                }
                .perform()
        }
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

// MARK: - Themeable
extension HIUserDetailViewController {
    @objc func refreshForThemeChange() {
        guard let user = HIApplicationStateController.shared.user,
              let url = URL(string: "hackillinois://qrcode/user?id=\(user.id)&identifier=\(user.identifier)") else { return }
        setupQRCode(user: user, url: url)
    }
}
