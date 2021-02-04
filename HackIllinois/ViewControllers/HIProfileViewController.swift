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
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.action
    }
//    private let scrollView = UIScrollView(frame: .zero)
    private let profilePictureView = HIImageView {
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
    private let profilePointsStackView = UIStackView() // Will be initialized in ViewController extension
    private let profileTimeView = HILabel(style: .profileNumberFigure) {
        $0.text = "12:00am"
    }
    private let profileTimeSubtitleView = HILabel(style: .profileDescription) {
        $0.text = "time zone"
    }
    private let profileTimeStackView = UIStackView() // Will be initialized in ViewController extension
    private let profileStatView = UIStackView() // Will be initialized in ViewController extension (.axis = .horizontal)
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
    private let profileInterestsView = HILabel()


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
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 12).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12).isActive = true
        
        contentView.addSubview(profilePictureView)
        profilePictureView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor).isActive = true
        profilePictureView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor).isActive = true
        profilePictureView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor).isActive = true
        profilePictureView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        backgroundView.image = #imageLiteral(resourceName: "ProfileBackground")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profilePictureView.image = UIImage(named: "DefaultProfilePicture")
    }
}
