//
//  HIAnnouncementAdminViewController.swift
//  HackIllinois
//
//  Created by Kevin Rajan on 2/1/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum HIAnnouncementAdminViewControllerStyle {
    case currentlyCreatingAnnouncement
    case readyToCreateAnnouncement
}

class HIAdminAnnouncementViewController: HIBaseViewController {
    // MARK: - Properties
    var activityIndicator = UIActivityIndicatorView()
    var titleTextField = UITextField()
    var descriptionTextField = UITextField()
    var createAnnouncementButton = UIButton()
}

// MARK: - Actions
extension HIAdminAnnouncementViewController {
    @objc func didSelectCreateAnnouncement(_ sender: UIButton) {
        guard let title = titleTextField.text, let description = descriptionTextField.text, title != "", description != "" else {
            return
        }

        let message = "Create a new notification with title \"\(title)\" and description \"\(description)\"?"
        let confirmAlertController = UIAlertController(title: "Confirm Notification", message: message, preferredStyle: .alert)
        confirmAlertController.addAction(
            UIAlertAction(title: "Yes", style: .default) { _ in
                self.stylizeFor(.currentlyCreatingAnnouncement)
                HIAnnouncementService.create(title: title, description: description)
                .onCompletion { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async { [weak self] in
                            self?.stylizeFor(.readyToCreateAnnouncement)
                            self?.titleTextField.text = ""
                            self?.descriptionTextField.text = ""
                            let alert = UIAlertController(title: "Notification Created", message: nil, preferredStyle: .alert)
                            alert.addAction(
                                UIAlertAction(title: "OK", style: .default) { _ in
                                    self?.navigationController?.popViewController(animated: true)
                                }
                            )
                            self?.present(alert, animated: true, completion: nil)
                        }
                    case .cancellation:
                        break
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
                .authorization(HIApplicationStateController.shared.user)
                .perform()
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
        titleTextField.placeholder = "TITLE"
        titleTextField.textColor = HIApplication.Color.darkIndigo
        titleTextField.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleTextField.tintColor = HIApplication.Color.hotPink
        titleTextField.autocapitalizationType = .sentences
        titleTextField.autocorrectionType = .yes
        titleTextField.delegate = self
        titleTextField.enablesReturnKeyAutomatically = true
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Seperator View
        let separatorView = UILabel()
        separatorView.backgroundColor = HIApplication.Color.hotPink
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        // Description TextField
        descriptionTextField.placeholder = "DESCRIPTION"
        descriptionTextField.textColor = HIApplication.Color.darkIndigo
        descriptionTextField.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        descriptionTextField.tintColor = HIApplication.Color.hotPink
        descriptionTextField.backgroundColor = UIColor.clear
        descriptionTextField.autocapitalizationType = .sentences
        descriptionTextField.autocorrectionType = .yes
        descriptionTextField.delegate = self
        descriptionTextField.enablesReturnKeyAutomatically = true
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionTextField)
        descriptionTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0).isActive = true
        descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        descriptionTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Create Announcement Button
        createAnnouncementButton.backgroundColor = HIApplication.Color.lightPeriwinkle
        createAnnouncementButton.layer.cornerRadius = 8
        createAnnouncementButton.setTitle("Create Announcement", for: .normal)
        createAnnouncementButton.setTitleColor(HIApplication.Color.darkIndigo, for: .normal)
        createAnnouncementButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        createAnnouncementButton.addTarget(self, action: #selector(HIAdminAnnouncementViewController.didSelectCreateAnnouncement(_:)), for: .touchUpInside)
        createAnnouncementButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createAnnouncementButton)
        createAnnouncementButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 44).isActive = true
        createAnnouncementButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        createAnnouncementButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        createAnnouncementButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // Activity Indicator
        activityIndicator.tintColor = HIApplication.Color.hotPink
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        createAnnouncementButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: createAnnouncementButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: createAnnouncementButton.centerYAnchor).isActive = true
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
        didSelectCreateAnnouncement(createAnnouncementButton)
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
            createAnnouncementButton.isEnabled = false
            createAnnouncementButton.setTitle(nil, for: .normal)
            createAnnouncementButton.backgroundColor = UIColor.gray
            activityIndicator.startAnimating()

        case .readyToCreateAnnouncement:
            createAnnouncementButton.isEnabled = true
            createAnnouncementButton.setTitle("Create Notification", for: .normal)
            createAnnouncementButton.backgroundColor = HIApplication.Color.lightPeriwinkle
            activityIndicator.stopAnimating()
        }
    }
}
