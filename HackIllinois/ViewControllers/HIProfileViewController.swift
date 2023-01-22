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
//    private let errorView = HIErrorView(style: .profile)
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
        /* TEMPORARY SO IT SHOWS NO ERROR VIEW
        if HIApplicationStateController.shared.isGuest {
            layoutErrorView()
        } else {
         */
           // layoutProfile()
        //}
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setCustomTitle(customTitle: "PROFILE")
    }
    
    func layoutProfileCard() {
//        let hostingController = UIHostingController(rootView: HIProfileCardView(firstName: profile.firstName,
//                                                                                lastName: profile.lastName,
//                                                                                dietaryRestrictions: profile.dietaryRestrictions,
//                                                                                wave: "4",
//                                                                                points: profile.points,
//                                                                                tier: profileTier,
//                                                                                id: profile.id
//                                                                               ))
        
        let hostingController = UIHostingController(rootView: HIProfileCardView(firstName: "Bob",
                                                                                lastName: "Ross",
                                                                                dietaryRestrictions: ["vegetarian","vegan"],
                                                                                points: 100,
                                                                                tier: "some tier",
                                                                                wave: "4",
                                                                                id: "SOMEID"
                                                                               ))
        addChild(hostingController)
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
    }
//
//    func layoutErrorView() {
//        errorView.delegate = self
//        view.addSubview(errorView)
//        errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
//        errorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
//        errorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
//        errorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//    }
    
    func layoutLogOutButton() {
        self.navigationItem.rightBarButtonItem = logoutButton.toBarButtonItem()
        logoutButton.constrain(width: 25, height: 25)
        logoutButton.addTarget(self, action: #selector(didSelectLogoutButton(_:)), for: .touchUpInside)
    }
    
    func updateProfile() {
//        guard let profile = HIApplicationStateController.shared.profile else { return }
//        view.layoutIfNeeded()
//
//        if let url = URL(string: profile.avatarUrl), let imgValue = HIConstants.PROFILE_IMAGES[url.absoluteString] {
//                    profilePictureView.changeImage(newImage: imgValue)
//                }
//        profileNameView.text = profile.firstName + " " + profile.lastName
//        profilePointsLabel.text = "\(profile.points) pts"
//        if tiers.count > 0 {
//            var max_threshold = 0
//            for tier in tiers where (profile.points >= tier.threshold && tier.threshold >= max_threshold) {
//                profileTierLabel.text = "\(tier.name.capitalized) Tier"
//                max_threshold = tier.threshold
//            }
//        } else {
//            profileTierLabel.text = "Tier: None"
//        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfile()
        reloadProfile()
        layoutProfileCard()
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
                self?.profile.dietaryRestrictions = apiProfile.dietaryRestrictions
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
