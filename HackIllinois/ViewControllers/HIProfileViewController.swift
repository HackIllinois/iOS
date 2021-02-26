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

class HIProfileViewController: HIBaseViewController {
    // MARK: - Properties
    private let editButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.baseImage = #imageLiteral(resourceName: "Pencil")
    }

    private let contentView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.clear
    }
//    private let scrollView = UIScrollView(frame: .zero)
    private let profilePictureView = HIImageView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let profileNameView = HILabel(style: .profileName) {
        $0.text = ""
    }
    private let profileSubtitleView = HILabel(style: .profileSubtitle) {
        $0.text = ""
    }
    private let profilePointsView = HILabel(style: .profileNumberFigure) {
        $0.text = ""
    }
    private let profilePointsSubtitleView = HILabel(style: .profileDescription) {
        $0.text = "points"
    }
    private let profileTimeView = HILabel(style: .profileNumberFigure) {
        $0.text = ""
    }
    private let profileTimeSubtitleView = HILabel(style: .profileDescription) {
        $0.text = "time zone"
    }
//    private let profileTimeStackView = UIStackView()
//    private let profilePointsStackView = UIStackView()
//    private let profileStatStackView = UIStackView()
    private let profileStatView = HIView() // Will be initialized in ViewController extension (.axis = .horizontal)
    // Good resource for UIStackView: https://stackoverflow.com/questions/43904070/programmatically-adding-views-to-a-uistackview
    private let profileDescriptionView = HILabel(style: .profileDescription) {
        $0.text = ""
    }
    private let profileDiscordImageView = HIImageView() // May need to modify depending on its intention
    private let profileDiscordUsernameView = HILabel(style: .profileUsername) {
        $0.text = "Discord Username"
    } // May need to modify depending on its intention
    private let profileUsernameView = UIStackView() // Will be initialized in ViewController extension (.axis = .horizontal)
    private let profileInterestsLabelView = HILabel(style: .profileUsername) {
        $0.text = "Interests"
    }
    private let profileInterestsView = HILabel() // Will be replaced by UICollectionView

    private let userNameLabel = HILabel {
        $0.textHIColor = \.baseText
    }
}

// MARK: - UITabBarItem Setup
extension HIProfileViewController {
    override func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "profile"), tag: 0)
    }
}

// MARK: - UIViewController
extension HIProfileViewController {
    override func loadView() {
        super.loadView()
        self.navigationItem.rightBarButtonItem = editButton.toBarButtonItem()
        // To add action
        editButton.constrain(width: 22, height: 22)
        // Setup contentView (Display summary)
        let profileScrollView = UIScrollView()
        view.addSubview(profileScrollView)
        profileScrollView.translatesAutoresizingMaskIntoConstraints = false
//        profileScrollView.constrain(to: view.safeAreaLayoutGuide, topInset: 0, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        profileScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        profileScrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        profileScrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        profileScrollView.addSubview(contentView)
//        contentView.constrain(to: profileScrollView, topInset: 12, trailingInset: -12, bottomInset: -12, leadingInset: 12)
        contentView.topAnchor.constraint(equalTo: profileScrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: profileScrollView.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: profileScrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: profileScrollView.widthAnchor).isActive = true
        contentView.addSubview(profilePictureView)
        profilePictureView.constrain(to: contentView, topInset: 0)
        profilePictureView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profilePictureView.constrain(width: 100, height: 100)
        contentView.addSubview(profileNameView)
        profileNameView.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 12).isActive = true
        profileNameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        contentView.addSubview(profileSubtitleView)
        profileSubtitleView.topAnchor.constraint(equalTo: profileNameView.bottomAnchor).isActive = true
        profileSubtitleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        let profileStatStackView = UIStackView()
        contentView.addSubview(profileStatStackView)
        loadStatView(profileStatStackView: profileStatStackView)
        // Reference: https://medium.com/swift-productions/create-a-uiscrollview-programmatically-xcode-12-swift-5-3-f799b8280e30
        let descriptionContentView = UIView()
        contentView.addSubview(descriptionContentView)
        descriptionContentView.translatesAutoresizingMaskIntoConstraints = false
        descriptionContentView.topAnchor.constraint(equalTo: profileStatStackView.bottomAnchor, constant: 20).isActive = true
        descriptionContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        descriptionContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        descriptionContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        descriptionContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descriptionContentView.addSubview(profileDescriptionView)
        loadDescriptionView(descriptionContentView: descriptionContentView)
    }

    func loadStatView(profileStatStackView: UIStackView) {
        profileStatStackView.axis = .horizontal
        profileStatStackView.distribution = .fillEqually
        profileStatStackView.topAnchor.constraint(equalTo: profileSubtitleView.bottomAnchor, constant: 19).isActive = true
        profileStatStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        profileStatStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        profileStatStackView.translatesAutoresizingMaskIntoConstraints = false
        let profilePointsStackView = UIStackView()
        profilePointsStackView.axis = .vertical
        profilePointsStackView.distribution = .fillEqually
        profilePointsStackView.alignment = .center
        profileStatStackView.addArrangedSubview(profilePointsStackView)
        profilePointsStackView.addArrangedSubview(profilePointsView)
        profilePointsStackView.addArrangedSubview(profilePointsSubtitleView)
        let profileTimeStackView = UIStackView()
        profileTimeStackView.axis = .vertical
        profileTimeStackView.distribution = .fillEqually
        profileTimeStackView.alignment = .center
        profileStatStackView.addArrangedSubview(profileTimeStackView)
        profileTimeStackView.addArrangedSubview(profileTimeView)
        profileTimeStackView.addArrangedSubview(profileTimeSubtitleView)
    }
    func loadDescriptionView(descriptionContentView: UIView) {
        profileDescriptionView.lineBreakMode = .byWordWrapping
        profileDescriptionView.numberOfLines = 0
        profileDescriptionView.constrain(to: descriptionContentView, topInset: 0, trailingInset: 0, leadingInset: 0)
        descriptionContentView.addSubview(profileDiscordImageView)
        profileDiscordImageView.constrain(width: 24, height: 17)
        profileDiscordImageView.topAnchor.constraint(equalTo: profileDescriptionView.bottomAnchor, constant: 29).isActive = true
        profileDiscordImageView.leadingAnchor.constraint(equalTo: descriptionContentView.leadingAnchor).isActive = true
        descriptionContentView.addSubview(profileDiscordUsernameView)
        profileDiscordUsernameView.lineBreakMode = .byWordWrapping
        profileDiscordUsernameView.numberOfLines = 0
        profileDiscordUsernameView.topAnchor.constraint(equalTo: profileDiscordImageView.topAnchor).isActive = true
        profileDiscordUsernameView.trailingAnchor.constraint(equalTo: descriptionContentView.trailingAnchor).isActive = true
        profileDiscordImageView.trailingAnchor.constraint(equalTo: profileDiscordUsernameView.leadingAnchor, constant: -10).isActive = true
        descriptionContentView.addSubview(profileInterestsLabelView)
        profileDiscordUsernameView.bottomAnchor.constraint(equalTo: profileInterestsLabelView.topAnchor, constant: -10).isActive = true
        descriptionContentView.addSubview(profileInterestsView)
        profileInterestsView.topAnchor.constraint(equalTo: profileInterestsLabelView.bottomAnchor).isActive = true
        profileInterestsView.bottomAnchor.constraint(equalTo: descriptionContentView.bottomAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        backgroundView.image = #imageLiteral(resourceName: "ProfileBackground")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let profile = HIApplicationStateController.shared.profile else { return }
        view.layoutIfNeeded()

        profileNameView.text = profile.firstName + " " + profile.lastName
        profileSubtitleView.text = profile.teamStatus
        profilePointsView.text = "\(profile.points)"
        profileTimeView.text = profile.timezone
        profileDescriptionView.text = profile.info
        profileDiscordUsernameView.text = profile.discord

        profilePictureView.image = UIImage(named: "DefaultProfilePicture")
        profileDiscordImageView.image = UIImage(named: "DiscordLogo")
    }
}
