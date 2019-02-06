//
//  HIAdminEventViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/14/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import CoreData
import APIManager
import HIAPI

enum HIAdminEventViewControllerStyle {
    case currentlyCreatingEvent
    case readyToCreateEvent
}

class HIAdminEventViewController: HIBaseViewController {
    // MARK: - Properties
    private let titleTextField = HITextField { $0.placeholder = "TITLE" }
    private let separatorView = HIView(style: .separator)
    private let durationTextField = HITextField { $0.placeholder = "DURATION (MINUTES)" }
    private let createEventButton = HIButton {
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = HIAppearance.Font.button
        $0.backgroundHIColor = \.contentBackground
        $0.titleHIColor = \.action
        $0.title = "Create Tracked Event"
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        titleTextField.delegate = self
        durationTextField.keyboardType = .numberPad
        durationTextField.delegate = self
        createEventButton.addTarget(self, action: #selector(didSelectCreateEvent), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }
}

// MARK: - Actions
extension HIAdminEventViewController {
    @objc func didSelectCreateEvent() {
        guard let title = titleTextField.text,
              let durationText = durationTextField.text,
              title != "", durationText != "",
              let duration = Int(durationText)
        else { return }

        let message = "Create a new tracked event \"\(title)\" for \(duration) minutes?"
        let confirmAlertController = UIAlertController(title: "Confirm Tracked Event", message: message, preferredStyle: .alert)
        confirmAlertController.addAction(confirmAlertActionWith(title: title, duration: duration))
        confirmAlertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(confirmAlertController, animated: true, completion: nil)
    }

    private func confirmAlertActionWith(title: String, duration: Int) -> UIAlertAction {
        return UIAlertAction(title: "Yes", style: .default) { _ in
            self.stylizeFor(.currentlyCreatingEvent)
        }
    }
}

// MARK: - UIViewController
extension HIAdminEventViewController {
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
        view.addSubview(durationTextField)
        durationTextField.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0).isActive = true
        durationTextField.constrain(to: view.safeAreaLayoutGuide, trailingInset: -30, leadingInset: 30)
        durationTextField.constrain(height: 44)

        // Create Event Button
        view.addSubview(createEventButton)
        createEventButton.topAnchor.constraint(equalTo: durationTextField.bottomAnchor, constant: 44).isActive = true
        createEventButton.constrain(to: view.safeAreaLayoutGuide, trailingInset: -12, leadingInset: 12)
        createEventButton.constrain(height: 50)
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
        didSelectCreateEvent()
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
            createEventButton.isRunning = true
        case .readyToCreateEvent:
            createEventButton.isRunning = false
        }
    }
}
