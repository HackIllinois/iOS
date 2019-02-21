//
//  HIAdminAnnouncementViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/1/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import CoreData
import HIAPI

enum HIAnnouncementAdminViewControllerStyle {
    case currentlyCreatingAnnouncement
    case readyToCreateAnnouncement
}

class HIAdminAnnouncementViewController: HIBaseViewController {
    // MARK: - Properties
    private let titleTextField = HITextField { $0.placeholder = "TITLE" }
    private let separatorView = HIView(style: .separator)
    private let descriptionTextField = HITextField { $0.placeholder = "DESCRIPTION" }
    private let createAnnouncementButton = HIButton {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.titleLabel?.font = HIAppearance.Font.button
        $0.backgroundHIColor = \.contentBackground
        $0.titleHIColor = \.action
        $0.title = "Create Announcement"
    }
    private let topicButton = HIButton {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.titleLabel?.font = HIAppearance.Font.button
        $0.backgroundHIColor = \.contentBackground
        $0.titleHIColor = \.action
        $0.title = "User"
    }
    private var currentTopic = "User"

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        createAnnouncementButton.addTarget(self, action: #selector(didSelectCreateAnnouncement), for: .touchUpInside)
        topicButton.addTarget(self, action: #selector(didSelectTopic(sender:)), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }
}

// MARK: - Actions
extension HIAdminAnnouncementViewController {
    @objc func didSelectCreateAnnouncement() {
        guard let title = titleTextField.text, let description = descriptionTextField.text, title != "", description != "" else {
                return
        }

        let message = "Create a new announcement with title \"\(title)\", description \"\(description)\", to topic \"\(currentTopic)\"?"
        let confirmAlertController = UIAlertController(title: "Confirm Announcement", message: message, preferredStyle: .alert)
        confirmAlertController.addAction(
            UIAlertAction(title: "Yes", style: .default) { _ in
                self.stylizeFor(.currentlyCreatingAnnouncement)
                HIAPI.AnnouncementService.create(title: title, description: description, topic: self.currentTopic)
                .onCompletion { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async { [weak self] in
                            self?.stylizeFor(.readyToCreateAnnouncement)
                            self?.titleTextField.text = ""
                            self?.descriptionTextField.text = ""
                            let alert = UIAlertController(title: "Announcement Created", message: nil, preferredStyle: .alert)
                            alert.addAction(
                                UIAlertAction(title: "OK", style: .default) { _ in
                                    self?.navigationController?.popViewController(animated: true)
                                }
                            )
                            self?.present(alert, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async { [weak self] in
                            self?.stylizeFor(.readyToCreateAnnouncement)
                            print(error)
                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                .authorize(with: HIApplicationStateController.shared.user)
                .launch()
            }
        )
        confirmAlertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(confirmAlertController, animated: true, completion: nil)
    }

    @objc func didSelectTopic(sender: UIButton) {
        let alert = UIAlertController(title: "Topic", message: "Please select a topic", preferredStyle: .actionSheet)
        HIAPI.Roles.allRoles.forEach { topic in
            alert.addAction(
                UIAlertAction(title: topic, style: .default) { [weak self] _ in
                    self?.topicButton.setTitle(topic, for: .normal)
                    self?.currentTopic = topic
                }
            )
        }
        alert.popoverPresentationController?.sourceRect = sender.bounds
        alert.popoverPresentationController?.sourceView = sender
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIViewController
extension HIAdminAnnouncementViewController {
    override func loadView() {
        super.loadView()

        // Title TextField
        view.addSubview(titleTextField)
        titleTextField.constrain(to: view.safeAreaLayoutGuide, topInset: 24, trailingInset: -30, leadingInset: 30)
        titleTextField.constrain(height: 44)

        // Seperator View
        view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        separatorView.constrain(to: view.safeAreaLayoutGuide, trailingInset: -30, leadingInset: 30)

        // Description TextField
        view.addSubview(descriptionTextField)
        descriptionTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0).isActive = true
        descriptionTextField.constrain(to: view.safeAreaLayoutGuide, trailingInset: -30, leadingInset: 30)
        descriptionTextField.constrain(height: 44)

        // Staff, Mentor, Attendee, Sponsor, User, Applicant, Admin
        // Topic Picker Button
        view.addSubview(topicButton)
        topicButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 44).isActive = true
        topicButton.constrain(to: view.safeAreaLayoutGuide, trailingInset: -12, leadingInset: 12)
        topicButton.constrain(height: 50)

        // Create Announcement Button
        view.addSubview(createAnnouncementButton)
        createAnnouncementButton.topAnchor.constraint(equalTo: topicButton.bottomAnchor, constant: 44).isActive = true
        createAnnouncementButton.constrain(to: view.safeAreaLayoutGuide, trailingInset: -12, leadingInset: 12)
        createAnnouncementButton.constrain(height: 50)
    }
}

// MARK: - Responder Chain
extension HIAdminAnnouncementViewController {
    override func nextReponder(current: UIResponder) -> UIResponder? {
        switch current {
        case titleTextField:
            return descriptionTextField
        case descriptionTextField:
            return nil
        default:
            return nil
        }
    }
    override func actionForFinalResponder() {
        didSelectCreateAnnouncement()
    }
}

// MARK: - UINavigationItem Setup
extension HIAdminAnnouncementViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "CREATE NOTIFICATION"
    }
}

// MARK: - Styling
extension HIAdminAnnouncementViewController {
    func stylizeFor(_ style: HIAnnouncementAdminViewControllerStyle) {
        switch style {
        case .currentlyCreatingAnnouncement:
            createAnnouncementButton.isRunning = true
        case .readyToCreateAnnouncement:
            createAnnouncementButton.isRunning = false
        }
    }
}
