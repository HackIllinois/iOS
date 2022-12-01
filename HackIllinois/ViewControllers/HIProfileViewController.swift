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
    private let errorView = HIErrorView(style: .profile)
    private let logoutButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.baseImage = #imageLiteral(resourceName: "LogoutButton")
    }
    private let contentView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.clear
        $0.layer.cornerRadius = 15
    }
    private let scrollView = UIScrollView(frame: .zero)
    private let profilePictureView = HIImageView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let profileNameView = HILabel(style: .profileName) {
        $0.text = ""
    }
    private let discordImageView = HIImageView()
    private let profileDiscordView = HILabel(style: .profileSubtitle) {
        $0.text = ""
    }
    
    private let statView = UIStackView()
    private let profilePointsView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.profileContainerTint
        $0.layer.cornerRadius = 12
    }
    
    private let profileTierView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.profileContainerTint
        $0.layer.cornerRadius = 12
    }
    private let profilePointsLabel = HILabel(style: .profileNumberFigure) {
        $0.text = ""
    }
    private let profileTierLabel = HILabel(style: .profileTier) {
        $0.text = ""
    }
    private let ticketView = HIButton {
        $0.backgroundHIColor = \.clear
        $0.activeImage = #imageLiteral(resourceName: "TicketFront")
        $0.baseImage = #imageLiteral(resourceName: "TicketFront")
    }
    private let dietLabel = HILabel(style: .profileDietaryRestrictions) {
        $0.text = "Dietary Restrictions"
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
            layoutProfile()
        //}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setCustomTitle(customTitle: "Profile")
    }
    func layoutProfile() {
        layoutButtons()
        layoutScrollView()
        layoutContentView()
        layoutProfileNameView()
      //  layoutProfileDiscordView()
      //  layoutProfilePicture()
        layoutStats()
        layoutTicketView()
        layoutDietLabel()
      //  layoutProfileCardView()
        contentView.bottomAnchor.constraint(equalTo: ticketView.bottomAnchor, constant: 107.09).isActive = true
        NotificationCenter.default.addObserver(self, selector: #selector(reloadProfile), name: .qrCodeSuccessfulScan, object: nil)
    }
    func layoutErrorView() {
        errorView.delegate = self
        view.addSubview(errorView)
        errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        errorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        errorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    func layoutScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.addSubview(contentView)
    }
    func layoutButtons() {
        self.navigationItem.rightBarButtonItem = logoutButton.toBarButtonItem()
        logoutButton.constrain(width: 25, height: 25)
        logoutButton.addTarget(self, action: #selector(didSelectLogoutButton(_:)), for: .touchUpInside)
    }
    func layoutContentView() {
        scrollView.addSubview(contentView)
        if UIDevice.current.userInterfaceIdiom == .pad {
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        } else {
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25).isActive = true
        }
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.75).isActive = true
        contentView.layer.contents = #imageLiteral(resourceName: "ProfileContainer").cgImage
    }
    func layoutProfileNameView() {
        contentView.addSubview(profileNameView)
        profileNameView.constrain(to: contentView, topInset: 50)
        profileNameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileNameView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func layoutStats() {
        contentView.addSubview(statView)
        statView.translatesAutoresizingMaskIntoConstraints = false

        statView.axis = .horizontal
        statView.alignment = .center
        statView.spacing = 8
        statView.topAnchor.constraint(equalTo: profileNameView.bottomAnchor, constant: 5).isActive = true
        statView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        statView.addArrangedSubview(profilePointsView)
       
        profilePointsView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        profilePointsView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        profilePointsView.addSubview(profilePointsLabel)
        profilePointsLabel.centerYAnchor.constraint(equalTo: profilePointsView.centerYAnchor).isActive = true
        profilePointsLabel.centerXAnchor.constraint(equalTo: profilePointsView.centerXAnchor).isActive = true
        
        statView.addArrangedSubview(profileTierView)
        profileTierView.widthAnchor.constraint(equalToConstant: 101).isActive = true
        profileTierView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        profileTierView.addSubview(profileTierLabel)
        profileTierLabel.centerYAnchor.constraint(equalTo: profileTierView.centerYAnchor).isActive = true
            profileTierLabel.centerXAnchor.constraint(equalTo: profileTierView.centerXAnchor).isActive = true
    }
    
    func layoutTicketView() {
        contentView.addSubview(ticketView)

       // closeButton.addTarget(self, action: #selector(didSelectCloseButton(_:)), for: .touchUpInside)
        ticketView.imageView?.contentMode = .scaleToFill
        ticketView.topAnchor.constraint(equalTo: profilePointsView.bottomAnchor, constant: 20).isActive = true
        ticketView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    func layoutDietLabel() {
        contentView.addSubview(dietLabel)
        dietLabel.topAnchor.constraint(equalTo: ticketView.bottomAnchor, constant: 24).isActive = true
        dietLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.setContentOffset(.zero, animated: true)
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
        profilePointsLabel.text = "\(profile.points) pts"
        if tiers.count > 0 {
            var max_threshold = 0
            for tier in tiers where (profile.points >= tier.threshold && tier.threshold >= max_threshold) {
                profileTierLabel.text = "\(tier.name.capitalized) Tier"
                max_threshold = tier.threshold
            }
        } else {
            profileTierLabel.text = "Tier: None"
        }
        profileDiscordView.text = profile.discord
        discordImageView.image = #imageLiteral(resourceName: "Discord")
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
                var profile = HIProfile()
                profile.id = apiProfile.id
                profile.firstName = apiProfile.firstName
                profile.lastName = apiProfile.lastName
                profile.points = apiProfile.points
                profile.timezone = apiProfile.timezone
                profile.discord = apiProfile.discord
                profile.avatarUrl = apiProfile.avatarUrl
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
