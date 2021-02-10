//
//  HIProfileViewController.swift
//  HackIllinois
//
//  Created by Hyosang Ahn on 2/1/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
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
        $0.text = "First Last Name"
    }
    private let profileSubtitleView = HILabel(style: .profileSubtitle) {
        $0.text = "LOOKING FOR TEAM OR LOOKING FOR people"
    }
    private let profilePointsView = HILabel(style: .profileNumberFigure) {
        $0.text = "0"
    }
    private let profilePointsSubtitleView = HILabel(style: .profileDescription) {
        $0.text = "points"
    }
    private let profileTimeView = HILabel(style: .profileNumberFigure) {
        $0.text = "12:00am"
    }
    private let profileTimeSubtitleView = HILabel(style: .profileDescription) {
        $0.text = "time zone"
    }
    private let profileTimeStackView = UIStackView()
    private let profilePointsStackView = UIStackView()
    private let profileStatStackView = UIStackView()
    private let profileStatView = HIView() // Will be initialized in ViewController extension (.axis = .horizontal)
    // Good resource for UIStackView: https://stackoverflow.com/questions/43904070/programmatically-adding-views-to-a-uistackview
    private let profileDescriptionView = HILabel(style: .profileDescription) {
        $0.text = "Short description about yourself or team if you're on a team.\n\n(maybe?) I am interested in:\n\nLooking for TEAM"
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

// MARK: - UIViewController
extension HIProfileViewController {
    override func loadView() {
        super.loadView()
        self.navigationItem.rightBarButtonItem = editButton.toBarButtonItem()
        // To add action
        editButton.constrain(width: 22, height: 22)
        // Setup contentView (Display summary)
        view.addSubview(contentView)
        contentView.constrain(to: view.safeAreaLayoutGuide, topInset: 12, trailingInset: -12, leadingInset: 12)

        contentView.addSubview(profilePictureView)
        profilePictureView.constrain(to: contentView, topInset: 0)
        profilePictureView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        profilePictureView.constrain(width: 100, height: 100)
        
        contentView.addSubview(profileNameView)
        profileNameView.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 12).isActive = true
        profileNameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(profileSubtitleView)
        profileSubtitleView.topAnchor.constraint(equalTo: profileNameView.bottomAnchor).isActive = true
//        profileSubtitleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        profileSubtitleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        // Below code makes every content except image disappear
//        contentView.addSubview(profileStatView)
//        profileStatView.topAnchor.constraint(equalTo: profileSubtitleView.bottomAnchor, constant: 20).isActive = true
//        profileStatView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        profileStatView.addSubview(profileStatStackView)
//        profileStatStackView.constrain(to: profileStatView)
//        profileStatStackView.axis = .horizontal
//        profileStatStackView.distribution = .fillEqually
//        profileStatStackView.topAnchor.constraint(equalTo: profileSubtitleView.bottomAnchor, constant: 19).isActive = true
//        profileStatStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
//        profileStatStackView.addArrangedSubview(profileTimeStackView)
//        profileTimeStackView.addArrangedSubview(profileTimeView)
//        profileTimeStackView.addArrangedSubview(profileTimeSubtitleView)
//        profileStatStackView.addArrangedSubview(profilePointsStackView)
//        profilePointsStackView.addArrangedSubview(profilePointsView)
//        profilePointsStackView.addArrangedSubview(profilePointsSubtitleView)
        
        contentView.addSubview(profileDescriptionView)
        profileDescriptionView.lineBreakMode = .byWordWrapping
        profileDescriptionView.numberOfLines = 0
        profileDescriptionView.topAnchor.constraint(equalTo: profileSubtitleView.bottomAnchor, constant: 100).isActive = true
        profileDescriptionView.constrain(to: contentView, trailingInset: 0, leadingInset: 0)
//        profileDescriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        contentView.addSubview(profileDiscordImageView)
        profileDiscordImageView.constrain(width: 24, height: 17)
        profileDiscordImageView.topAnchor.constraint(equalTo: profileDescriptionView.bottomAnchor, constant: 29).isActive = true
        profileDiscordImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        contentView.addSubview(profileDiscordUsernameView)
        profileDiscordUsernameView.lineBreakMode = .byWordWrapping
        profileDiscordUsernameView.numberOfLines = 0
        profileDiscordUsernameView.topAnchor.constraint(equalTo: profileDiscordImageView.topAnchor).isActive = true
        profileDiscordUsernameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        profileDiscordImageView.trailingAnchor.constraint(equalTo: profileDiscordUsernameView.leadingAnchor, constant: -9).isActive = true
        contentView.addSubview(profileInterestsLabelView)
//        profileDiscordImageView.bottomAnchor.constraint(equalTo: profileInterestsLabelView.topAnchor).isActive = true
        profileDiscordUsernameView.bottomAnchor.constraint(equalTo: profileInterestsLabelView.topAnchor, constant: -10).isActive = true
        contentView.addSubview(profileInterestsView)
        profileInterestsView.topAnchor.constraint(equalTo: profileInterestsLabelView.bottomAnchor).isActive = true
        profileInterestsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        backgroundView.image = #imageLiteral(resourceName: "ProfileBackground")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profilePictureView.image = UIImage(named: "DefaultProfilePicture")
        profileDiscordImageView.image = UIImage(named: "DiscordLogo")
    }
}
