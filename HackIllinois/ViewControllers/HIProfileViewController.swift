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
import SwiftUI

class HIProfileViewController: HIBaseViewController {
    // MARK: - Properties
    private var profile = HIProfile()
    private var profileTier = ""
    private var addedProfileCard = false
    private var dietaryRestrictions = [String]()
    private var profileCardController: UIHostingController<HIProfileCardView>?
    private let errorView = HIErrorView(style: .profile)
    private let logoutButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.baseImage = #imageLiteral(resourceName: "LogoutButton")
    }

    @objc dynamic override func setUpBackgroundView() {
        super.setUpBackgroundView()
        backgroundView.image = #imageLiteral(resourceName: "ProfileBackground")
    }
    private var tiers: [Tier] = []
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
            updateProfile()
            reloadProfile()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setCustomTitle(customTitle: "PROFILE")
    }

    func updateProfileCard() {
        if addedProfileCard == true {
            profileCardController?.view.removeFromSuperview()
            view.willRemoveSubview(profileCardController!.view)
            profileCardController?.removeFromParent()
        }
        profileCardController = UIHostingController(rootView: HIProfileCardView(firstName: profile.firstName,
                                                                                lastName: profile.lastName,
                                                                                dietaryRestrictions: dietaryRestrictions,
                                                                                points: profile.points,
                                                                                tier: profileTier,
                                                                                foodWave: profile.foodWave,
                                                                                id: profile.id
                                                                               ))
        
        addChild(profileCardController!)
        profileCardController!.view.backgroundColor = .clear
        profileCardController!.view.frame = view.bounds
        view.addSubview(profileCardController!.view)
        addedProfileCard = true
    }

    func layoutErrorView() {
        errorView.delegate = self
        view.addSubview(errorView)
        errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        errorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        errorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    func layoutLogOutButton() {
        self.navigationItem.rightBarButtonItem = logoutButton.toBarButtonItem()
        logoutButton.constrain(width: 25, height: 25)
        logoutButton.addTarget(self, action: #selector(didSelectLogoutButton(_:)), for: .touchUpInside)
    }

    func updateProfile() {
        updateProfileCard()
        if tiers.count > 0 {
            var max_threshold = 0
            for tier in tiers where (profile.points >= tier.threshold && tier.threshold >= max_threshold) {
                profileTier = "\(tier.name.capitalized) Tier"
                max_threshold = tier.threshold
            }
        } else {
            profileTier = "Tier: None"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutLogOutButton()
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
    @objc func reloadProfile () {
        guard let user = HIApplicationStateController.shared.user else { return }
        HIAPI.ProfileService.getUserProfile()
        .onCompletion { [weak self] result in
            do {
                let (apiProfile, _) = try result.get()
                self?.profile.id = apiProfile.id
                self?.profile.firstName = apiProfile.firstName
                self?.profile.lastName = apiProfile.lastName
                self?.profile.points = apiProfile.points
                self?.profile.foodWave = apiProfile.foodWave
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .loginProfile, object: nil, userInfo: ["profile": self?.profile])
                    self?.updateProfile()
                }
            } catch {
                print("Failed to reload profile with error: \(error)")
            }
        }
        .authorize(with: user)
        .launch()
        HIAPI.ProfileService.getTiers()
            .onCompletion { [weak self] result in
                do {
                    let (tiersList, _) = try result.get()
                    self?.tiers = tiersList.tiers
                    DispatchQueue.main.async {
                        self?.updateProfile()
                    }
                } catch {
                    print("An error has occurred \(error)")
                }
            }
            .launch()

        HIAPI.RegistrationService.getAttendee()
            .onCompletion { [weak self] result in
                do {
                    let (apiAttendeeContainer, _) = try result.get()
                    let dietaryRestrictions = apiAttendeeContainer.attendee.dietary ?? []
                    DispatchQueue.main.async {
                        self?.updateProfile()
                    }
                } catch {
                    print("An error has occurred \(error)")
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
