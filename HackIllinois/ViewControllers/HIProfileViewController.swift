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
        $0.tintHIColor = \.titleText
        $0.backgroundHIColor = \.clear
        $0.baseImage = #imageLiteral(resourceName: "LogoutButton")
        $0.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
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

    private let qrImageView = HITintImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintHIColor = \.qrTint
        $0.contentMode = .scaleAspectFit
    }
    private let qrBackground = HIView(style: .qrBackground)
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

    func layoutErrorView() {
        errorView.delegate = self
        view.addSubview(errorView)
        errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        errorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        errorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    func layoutQRCode() {
        contentView.addSubview(qrBackground)
        qrBackground.constrain(to: contentView, topInset: 0)
        qrBackground.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        qrBackground.constrain(width: 250, height: 250)
        qrBackground.addSubview(qrImageView)
        qrImageView.constrain(to: qrBackground, topInset: 0)
        qrImageView.centerYAnchor.constraint(equalTo: qrBackground.centerYAnchor).isActive = true
        qrImageView.centerXAnchor.constraint(equalTo: qrBackground.centerXAnchor).isActive = true
        qrImageView.constrain(width: 200, height: 200)
    }
    func layoutScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.addSubview(contentView)
    }
    func layoutButtons() {
        self.navigationItem.leftBarButtonItem = logoutButton.toBarButtonItem()
        logoutButton.addTarget(self, action: #selector(didSelectLogoutButton(_:)), for: .touchUpInside)
        logoutButton.constrain(width: 25, height: 25)
        if !HIApplicationStateController.shared.isGuest {
            self.navigationItem.rightBarButtonItem = editButton.toBarButtonItem()
            editButton.constrain(width: 22, height: 22)
            editButton.addTarget(self, action: #selector(didSelectEditButton(_:)), for: .touchUpInside)
            _ = editViewController.view
        }
    }
    func layoutContentView() {
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    func layoutDescription() {
        // Reference: https://medium.com/swift-productions/create-a-uiscrollview-programmatically-xcode-12-swift-5-3-f799b8280e30
        let profileStatStackView = UIStackView()
        contentView.addSubview(profileStatStackView)
        loadStatView(profileStatStackView: profileStatStackView)
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
    func layoutProfileNameView() {
        contentView.addSubview(profileNameView)
        profileNameView.topAnchor.constraint(equalTo: qrBackground.bottomAnchor, constant: 12).isActive = true
        profileNameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        profileNameView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
    }
    func layoutProfileStatus() {
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
    }
    func layoutProfile() {
        layoutButtons()
        layoutScrollView()
        layoutContentView()
        layoutQRCode()
        layoutProfileNameView()
        layoutProfileStatus()
        layoutDescription()
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
        guard let user = HIApplicationStateController.shared.user else { return }
        view.layoutIfNeeded()

        // Generate a QR Code with the user's id
        DispatchQueue.global(qos: .userInitiated).async {
            let qrImage: UIImage!
            if let logo = UIImage(named: "QRCodeLogo"), let whiteBackground = UIImage(named: "QRCodeBackground") {
                // Custom QR Code with logo
                qrImage = UIImage.init(qrString: user.id, qrCodeColor: (\HIAppearance.qrTint).value, backgroundImage: whiteBackground, logo: logo)
            } else {
                // Regular, black QR Code
                let size = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
                qrImage = UIImage.init(qrString: user.id, size: size)
            }
            DispatchQueue.main.async {
                self.qrImageView.image = qrImage
            }
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
