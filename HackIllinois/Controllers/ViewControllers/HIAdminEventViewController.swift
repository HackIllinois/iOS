//
//  HIAdminEventViewController.swift
//  HackIllinois
//
//  Created by Kevin Rajan on 2/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum HIAdminEventViewControllerStyle {
    case currentlyCreatingEvent
    case readyToCreateEvent
}

class HIAdminEventViewController: HIBaseViewController {
    // MARK: - Properties
    var activityIndicator = UIActivityIndicatorView()
    var titleTextField = UITextField()
    var durationTextField = UITextField()
    var createEventButton = UIButton()
}

// MARK: - Actions
extension HIAdminEventViewController {
    @objc func didSelectCreateEvent(_ sender: UIButton) {
        guard let title = titleTextField.text,
              let durationText = durationTextField.text,
              title != "", durationText != "",
              let duration = Int(durationText)
        else { return }

        let message = "Create a new tracked event \"\(title)\" for \(duration) minutes?"
        let confirmAlertController = UIAlertController(title: "Confirm Tracked Event", message: message, preferredStyle: .alert)
        confirmAlertController.addAction(
            UIAlertAction(title: "Yes", style: .default) { _ in
                self.stylizeFor(.currentlyCreatingEvent)
                HITrackingService.create(name: title, duration: duration)
                .onCompletion { result in
                    let alertTitle: String
                    var alertMessage: String?
                    var shouldExitOnCompletion = false

                    switch result {
                    case .success(let successContainer):
 
                        if let error = successContainer.error {
                            alertTitle = error.title
                            alertMessage = error.message
                        } else {
                            alertTitle = "Tracked Event Created"
                            shouldExitOnCompletion = true
                        }

                    case .cancellation:
                        alertTitle = "Cancelled"

                    case .failure(let error):
                        alertTitle = "Error"
                        alertMessage = error.localizedDescription
                    }
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    alert.addAction(
                        UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                            if shouldExitOnCompletion {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                    )
                    DispatchQueue.main.async { [weak self] in
                        self?.stylizeFor(.readyToCreateEvent)
                        self?.titleTextField.text = ""
                        self?.durationTextField.text = ""
                        self?.present(alert, animated: true, completion: nil)
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
extension HIAdminEventViewController {
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
        durationTextField.placeholder = "DURATION (MINUTES)"
        durationTextField.textColor = HIApplication.Color.darkIndigo
        durationTextField.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        durationTextField.tintColor = HIApplication.Color.hotPink
        durationTextField.backgroundColor = UIColor.clear
        durationTextField.keyboardType = .numberPad
        durationTextField.autocorrectionType = .yes
        durationTextField.delegate = self
        durationTextField.enablesReturnKeyAutomatically = true
        durationTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(durationTextField)
        durationTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0).isActive = true
        durationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        durationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        durationTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Create Event Button
        createEventButton.backgroundColor = HIApplication.Color.lightPeriwinkle
        createEventButton.layer.cornerRadius = 8
        createEventButton.setTitle("Create Tracked Event", for: .normal)
        createEventButton.setTitleColor(HIApplication.Color.darkIndigo, for: .normal)
        createEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        createEventButton.addTarget(self, action: #selector(didSelectCreateEvent(_:)), for: .touchUpInside)
        createEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createEventButton)
        createEventButton.topAnchor.constraint(equalTo: durationTextField.bottomAnchor, constant: 44).isActive = true
        createEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        createEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        createEventButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // Activity Indicator
        activityIndicator.tintColor = HIApplication.Color.hotPink
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        createEventButton.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: createEventButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: createEventButton.centerYAnchor).isActive = true
    }
}

// MARK: - Responder Chain
extension HIAdminEventViewController {
    override func nextReponder(current: UIResponder) -> UIResponder? {
        switch current {
        case titleTextField:
            return durationTextField
        case durationTextField:
            return nil
        default:
            return nil
        }
    }
    override func actionForFinalResponder() {
        didSelectCreateEvent(createEventButton)
    }
}

// MARK: - UINavigationItem Setup
extension HIAdminEventViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "CREATE TRACKED EVENT"
    }
}

// MARK: - Styling
extension HIAdminEventViewController {
    func stylizeFor(_ style: HIAdminEventViewControllerStyle) {
        switch style {
        case .currentlyCreatingEvent:
            createEventButton.isEnabled = false
            createEventButton.setTitle(nil, for: .normal)
            createEventButton.backgroundColor = UIColor.gray
            activityIndicator.startAnimating()

        case .readyToCreateEvent:
            createEventButton.isEnabled = true
            createEventButton.setTitle("Create Tracked Event", for: .normal)
            createEventButton.backgroundColor = HIApplication.Color.lightPeriwinkle
            activityIndicator.stopAnimating()
        }
    }
}
