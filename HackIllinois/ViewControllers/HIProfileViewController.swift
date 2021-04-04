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

class HIProfileViewController: HIBaseViewController {
    // MARK: - Properties
    private let editViewController = HIEditProfileViewController()

    private let editButton = HIButton {
        $0.tintHIColor = \.baseText
        $0.backgroundHIColor = \.clear
        $0.baseImage = #imageLiteral(resourceName: "Pencil")
    }

    private let scrollView = UIScrollView(frame: .zero)
    private let contentView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.clear
    }

    private let profilePictureView = HIImageView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let profileNameView = HILabel(style: .profileName) {
        $0.text = ""
    }
    private let profileStatusContainer = UIView()
    private let profileStatusIndicator = HICircularView {
        $0.backgroundHIColor = \.clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let profileStatusDescriptionView = HILabel(style: .profileSubtitle) {
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
    private let profileStatView = HIView() // Will be initialized in ViewController extension (.axis = .horizontal)
    // Good resource for UIStackView: https://stackoverflow.com/questions/43904070/programmatically-adding-views-to-a-uistackview
    private let profileDescriptionView = HILabel(style: .profileDescription) {
        $0.text = ""
    }
    private let profileDiscordImageView = HIImageView()
    private let profileDiscordUsernameView = HILabel(style: .profileUsername) {
        $0.text = "Discord Username"
    }
    private let profileUsernameView = UIStackView() // Will be initialized in ViewController extension (.axis = .horizontal)
    private let profileInterestsLabelView = HILabel(style: .profileUsername) {
        $0.text = "Skills"
    }
    lazy var profileInterestsView: UICollectionView = {
        let profileInterestsView = UICollectionView(frame: .zero, collectionViewLayout: HICollectionViewFlowLayout())
        profileInterestsView.backgroundColor = .clear
        profileInterestsView.register(HIInterestCell.self, forCellWithReuseIdentifier: "interestCell")
        profileInterestsView.dataSource = self
        profileInterestsView.delegate = self
        profileInterestsView.translatesAutoresizingMaskIntoConstraints = false
        return profileInterestsView
    }()
    private var profileInterestsViewHeight = NSLayoutConstraint()
    var interests: [String] = []

    @objc dynamic override func setUpBackgroundView() {
            super.setUpBackgroundView()
            backgroundView.image = #imageLiteral(resourceName: "ProfileBackground")
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
        if !HIApplicationStateController.shared.isGuest {
            self.navigationItem.rightBarButtonItem = editButton.toBarButtonItem()
            editButton.constrain(width: 22, height: 22)
            editButton.addTarget(self, action: #selector(didSelectEditButton(_:)), for: .touchUpInside)
            _ = editViewController.view
        }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.addSubview(contentView)

        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.addSubview(profilePictureView)
        profilePictureView.constrain(to: contentView, topInset: 0)
        profilePictureView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profilePictureView.constrain(width: 100, height: 100)
        contentView.addSubview(profileNameView)
        profileNameView.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 12).isActive = true
        profileNameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileStatusContainer.translatesAutoresizingMaskIntoConstraints = false
        profileStatusContainer.backgroundColor = .clear
        contentView.addSubview(profileStatusContainer)
        profileStatusContainer.topAnchor.constraint(equalTo: profileNameView.bottomAnchor).isActive = true
        profileStatusContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileStatusContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileStatusContainer.addSubview(profileStatusIndicator)
        profileStatusIndicator.topAnchor.constraint(equalTo: profileStatusContainer.topAnchor, constant: 15).isActive = true
        profileStatusIndicator.leadingAnchor.constraint(equalTo: profileStatusContainer.leadingAnchor, constant: 5).isActive = true
        profileStatusIndicator.centerYAnchor.constraint(equalTo: profileStatusContainer.centerYAnchor).isActive = true
        profileStatusIndicator.widthAnchor.constraint(equalToConstant: 10).isActive = true
        profileStatusContainer.addSubview(profileStatusDescriptionView)
        profileStatusDescriptionView.topAnchor.constraint(equalTo: profileStatusContainer.topAnchor).isActive = true
        profileStatusDescriptionView.bottomAnchor.constraint(equalTo: profileStatusContainer.bottomAnchor).isActive = true
        profileStatusDescriptionView.leadingAnchor.constraint(equalTo: profileStatusIndicator.trailingAnchor, constant: 5).isActive = true
        profileStatusDescriptionView.trailingAnchor.constraint(equalTo: profileStatusContainer.trailingAnchor).isActive = true
        let profileStatStackView = UIStackView()
        contentView.addSubview(profileStatStackView)
        loadStatView(profileStatStackView: profileStatStackView)
        // Reference: https://medium.com/swift-productions/create-a-uiscrollview-programmatically-xcode-12-swift-5-3-f799b8280e30
        let descriptionContentView = UIView()
        contentView.addSubview(descriptionContentView)
        descriptionContentView.translatesAutoresizingMaskIntoConstraints = false
        descriptionContentView.topAnchor.constraint(equalTo: profileStatStackView.bottomAnchor, constant: 20).isActive = true
        descriptionContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        descriptionContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        descriptionContentView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descriptionContentView.addSubview(profileDescriptionView)
        loadDescriptionView(descriptionContentView: descriptionContentView)
    }

    func loadStatView(profileStatStackView: UIStackView) {
        profileStatStackView.axis = .horizontal
        profileStatStackView.distribution = .fillEqually
        profileStatStackView.topAnchor.constraint(equalTo: profileStatusContainer.bottomAnchor, constant: 19).isActive = true
        profileStatStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        profileStatStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
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
        profileDiscordUsernameView.leadingAnchor.constraint(equalTo: profileDiscordImageView.trailingAnchor, constant: 10).isActive = true
        profileDiscordUsernameView.bottomAnchor.constraint(equalTo: profileDiscordImageView.bottomAnchor).isActive = true
        descriptionContentView.addSubview(profileInterestsLabelView)
        profileInterestsLabelView.topAnchor.constraint(equalTo: profileDiscordImageView.bottomAnchor, constant: 20).isActive = true
        profileInterestsLabelView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        profileInterestsLabelView.leadingAnchor.constraint(equalTo: profileDiscordImageView.leadingAnchor).isActive = true
        profileInterestsView.isScrollEnabled = false
        descriptionContentView.addSubview(profileInterestsView)
        profileInterestsView.topAnchor.constraint(equalTo: profileInterestsLabelView.bottomAnchor, constant: 10).isActive = true
        profileInterestsView.bottomAnchor.constraint(equalTo: descriptionContentView.bottomAnchor).isActive = true
        profileInterestsView.leadingAnchor.constraint(equalTo: profileInterestsLabelView.leadingAnchor).isActive = true
        profileInterestsView.trailingAnchor.constraint(equalTo: descriptionContentView.trailingAnchor).isActive = true
        profileInterestsViewHeight = profileInterestsView.heightAnchor.constraint(equalToConstant: 0)
        profileInterestsViewHeight.isActive = true
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
        let modifiedTeamStatus = profile.teamStatus.capitalized.replacingOccurrences(of: "_", with: " ")
        if modifiedTeamStatus == "Looking For Team" {
            profileStatusIndicator.changeCircleColor(color: \.groupSearchText)
            profileStatusDescriptionView.changeTextColor(color: \.groupSearchText)
        } else if modifiedTeamStatus == "Looking For Members" {
            profileStatusIndicator.changeCircleColor(color: \.memberSearchText)
            profileStatusDescriptionView.changeTextColor(color: \.memberSearchText)
        } else {
            profileStatusIndicator.changeCircleColor(color: \.noSearchText)
            profileStatusDescriptionView.changeTextColor(color: \.noSearchText)
        }
        profileStatusDescriptionView.text = modifiedTeamStatus
        profilePointsView.text = "\(profile.points)"
        profileTimeView.text = profile.timezone
        profileDescriptionView.text = profile.info
        profileDiscordUsernameView.text = profile.discord
        interests = profile.interests
        profileInterestsView.reloadData()
        profileInterestsViewHeight.constant = profileInterestsView.collectionViewLayout.collectionViewContentSize.height + 20

        profileDiscordImageView.image = #imageLiteral(resourceName: "DiscordLogo")

    }

    override func viewDidLayoutSubviews() {
        profileInterestsViewHeight.constant = profileInterestsView.collectionViewLayout.collectionViewContentSize.height + 20
    }

}

// MARK: - UICollectionViewDataSource
extension HIProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCell", for: indexPath)
        if let cell = cell as? HIInterestCell {
            let interest = interests[indexPath.row]
            cell <- interest
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HIProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interest = interests[indexPath.row]
        let bound = Int(collectionView.frame.width)
        return CGSize(width: min((10 * interest.count) + 35, bound), height: 40)
    }
}

// MARK: - Actions
extension HIProfileViewController {
    @objc func didSelectEditButton(_ sender: UIButton) {
        if let navController = navigationController as? HINavigationController {
            navController.pushViewController(editViewController, animated: true)
        }
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
