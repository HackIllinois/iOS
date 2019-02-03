//
//  HIAdminAnnouncementViewController.swift
//  HackIllinois
//
//  Created by Kevin Rajan on 2/1/18.
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
    var titleTextField = HITextField { $0.placeholder = "TITLE" }
    var descriptionTextField = HITextField { $0.placeholder = "DESCRIPTION" }
    var createAnnouncementButton = HIButton {
        $0.backgroundHIColor = \.action
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        $0.title = "Create Announcement"
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        createAnnouncementButton.addTarget(self, action: #selector(didSelectCreateAnnouncement), for: .touchUpInside)
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

        let message = "Create a new announcement with title \"\(title)\" and description \"\(description)\"?"
        let confirmAlertController = UIAlertController(title: "Confirm Announcement", message: message, preferredStyle: .alert)
        confirmAlertController.addAction(
            UIAlertAction(title: "Yes", style: .default) { _ in
                self.stylizeFor(.currentlyCreatingAnnouncement)
                HIAPI.AnnouncementService.create(title: title, description: description)
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
                            print(error.localizedDescription)
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
}

// MARK: - UIViewController
extension HIAdminAnnouncementViewController {
    override func loadView() {
        super.loadView()

        // Title TextField
        view.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Seperator View
        let separatorView = HIView(style: .separator)
        view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true

        // Description TextField
        view.addSubview(descriptionTextField)
        descriptionTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0).isActive = true
        descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        descriptionTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Create Announcement Button
        view.addSubview(createAnnouncementButton)
        createAnnouncementButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 44).isActive = true
        createAnnouncementButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        createAnnouncementButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        createAnnouncementButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
