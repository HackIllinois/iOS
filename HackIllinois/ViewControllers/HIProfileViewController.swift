//
//  HIProfileViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/24/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import CoreData
import HIAPI
import CoreImage.CIFilterBuiltins

class HIProfileViewController: HIBaseViewController {
    // MARK: - Properties
    private let errorView = HIErrorView(style: .profile)
    private let logoutButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.baseImage = #imageLiteral(resourceName: "LogoutButton")
    }
    private let editViewController = HIEditProfileViewController()
    private let contentView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.clear
        $0.layer.cornerRadius = 15
    }
    private let profilePictureView = HIImageView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let profileNameView = HILabel(style: .profileName) {
        $0.text = ""
    }
    private let profilePointsView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.profileContainerTint
        $0.layer.cornerRadius = 25
    }
    private let profilePointsLabel = HILabel(style: .profileNumberFigure) {
        $0.text = ""
    }
    private let profileTierLabel = HILabel(style: .profileTier) {
        $0.text = "Current Tier"
    }
    private let profileUsernameView = UIStackView() // Will be initialized in ViewController extension (.axis = .horizontal)

    @objc dynamic override func setUpBackgroundView() {
        super.setUpBackgroundView()
        backgroundView.image = #imageLiteral(resourceName: "ProfileBackground")
    }
}

// MARK: - UITabBarItem Setup
extension HIProfileViewController {
    override func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "profile"), selectedImage: #imageLiteral(resourceName: "ProfileSelected"))
    }
}

// MARK: - UIViewController
extension HIProfileViewController {
    override func loadView() {
        super.loadView()
        if HIApplicationStateController.shared.isGuest {
            layoutErrorView()
        } else {
            layoutProfile()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setCustomTitle(customTitle: "Profile")
    }
    func layoutProfile() {
        layoutButtons()
        layoutContentView()
        layoutProfileNameView()
        layoutProfilePicture()
        layoutPoints()
        contentView.bottomAnchor.constraint(equalTo: profilePointsView.bottomAnchor, constant: 75).isActive = true
    }
    func layoutErrorView() {
        errorView.delegate = self
        view.addSubview(errorView)
        errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        errorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        errorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    func layoutButtons() {
        self.navigationItem.rightBarButtonItem = logoutButton.toBarButtonItem()
        logoutButton.constrain(width: 25, height: 25)
        logoutButton.addTarget(self, action: #selector(didSelectLogoutButton(_:)), for: .touchUpInside)
    }
    func layoutContentView() {
        view.addSubview(contentView)
        contentView.layer.contents = #imageLiteral(resourceName: "ProfileContainer").cgImage

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75).isActive = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            contentView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        } else {
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        }
    }
    func layoutPoints() {
        contentView.addSubview(profilePointsView)
        profilePointsView.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 35).isActive = true
        profilePointsView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profilePointsView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.72).isActive = true
        profilePointsView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profilePointsView.addSubview(profileTierLabel)
        profileTierLabel.centerYAnchor.constraint(equalTo: profilePointsView.centerYAnchor, constant: -15).isActive = true
        profileTierLabel.centerXAnchor.constraint(equalTo: profilePointsView.centerXAnchor).isActive = true
        profilePointsView.addSubview(profilePointsLabel)
        profilePointsLabel.centerYAnchor.constraint(equalTo: profilePointsView.centerYAnchor, constant: 15).isActive = true
        profilePointsLabel.centerXAnchor.constraint(equalTo: profilePointsView.centerXAnchor).isActive = true
    }
    func layoutProfileNameView() {
        contentView.addSubview(profileNameView)
        profileNameView.constrain(to: contentView, topInset: 50)
        profileNameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileNameView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
    }
    func layoutProfilePicture() {
        contentView.addSubview(profilePictureView)
        profilePictureView.topAnchor.constraint(equalTo: profileNameView.bottomAnchor, constant: 35).isActive = true
        profilePictureView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profilePictureView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75).isActive = true
        profilePictureView.heightAnchor.constraint(equalTo: profilePictureView.widthAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfile()
        reloadProfile()
    }

    func updateProfile() {
        guard let profile = HIApplicationStateController.shared.profile else { return }
        view.layoutIfNeeded()

        if let url = URL(string: profile.avatarUrl), let imgValue = HIConstants.PROFILE_IMAGES[url.absoluteString] {
                    profilePictureView.changeImage(newImage: imgValue)
                }
        profileNameView.text = profile.firstName + " " + profile.lastName
        profilePointsLabel.text = "\(profile.points)"

    }

}

// MARK: - Actions
extension HIProfileViewController {
    @objc func didSelectLogoutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(title: "Log Out", style: .destructive) { _ in
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

}

// MARK: - API
extension HIProfileViewController {
    func reloadProfile () {

        guard let user = HIApplicationStateController.shared.user else { return }
        HIAPI.ProfileService.getUserProfile()
        .onCompletion { [weak self] result in
            do {
                let (apiProfile, _) = try result.get()
                var profile = HIProfile()
                profile.id = apiProfile.id
                profile.firstName = apiProfile.firstName
                profile.lastName = apiProfile.lastName
                profile.points = apiProfile.points
                profile.timezone = apiProfile.timezone
                profile.info = apiProfile.info
                profile.discord = apiProfile.discord
                profile.avatarUrl = apiProfile.avatarUrl
                profile.teamStatus = apiProfile.teamStatus
                profile.interests = apiProfile.interests
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .loginProfile, object: nil, userInfo: ["profile": profile])
                    self?.updateProfile()
                }
            } catch {
                print("Failed to reload profile with error: \(error)")
            }

        }
        .authorize(with: user)
        .launch()

    }

}

// MARK: - HIErrorViewDelegate
extension HIProfileViewController: HIErrorViewDelegate {
    func didSelectErrorLogout(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(
            UIAlertAction(title: "Log Out", style: .destructive) { _ in
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
}
