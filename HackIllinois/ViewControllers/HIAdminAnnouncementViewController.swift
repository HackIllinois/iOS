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

//        let message = "Create a new announcement with title \"\(title)\", description \"\(description), and topic \"\(topic)\"\"?"
        let message = "Create a new announcement with title \"\(title)\", description \"\(description)\"?"
        let confirmAlertController = UIAlertController(title: "Confirm Announcement", message: message, preferredStyle: .alert)
        confirmAlertController.addAction(
            UIAlertAction(title: "Yes", style: .default) { _ in
                self.stylizeFor(.currentlyCreatingAnnouncement)
//                HIAPI.AnnouncementService.create(title: title, description: description)
//                .onCompletion { result in
//                    switch result {
//                    case .success:
//                        DispatchQueue.main.async { [weak self] in
//                            self?.stylizeFor(.readyToCreateAnnouncement)
//                            self?.titleTextField.text = ""
//                            self?.descriptionTextField.text = ""
//                            let alert = UIAlertController(title: "Announcement Created", message: nil, preferredStyle: .alert)
//                            alert.addAction(
//                                UIAlertAction(title: "OK", style: .default) { _ in
//                                    self?.navigationController?.popViewController(animated: true)
//                                }
//                            )
//                            self?.present(alert, animated: true, completion: nil)
//                        }
//                    case .failure(let error):
//                        DispatchQueue.main.async { [weak self] in
//                            self?.stylizeFor(.readyToCreateAnnouncement)
//                            print(error.localizedDescription)
//                            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                            self?.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                }
//                .authorize(with: HIApplicationStateController.shared.user)
//                .launch()
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
        class PickerData : NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
            let topics = ["Staff", "Mentor", "Attendee", "Sponsor", "User", "Applicant", "Admin"]
            
            func numberOfComponents(in pickerView: UIPickerView) -> Int {
                return 1
            }
            
            func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                return topics.count
            }
            
            func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
                return topics[row]
            }
        }
        
        let pickerData = PickerData()
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.dataSource = pickerData
        pickerView.delegate = pickerData
        pickerView.reloadAllComponents()
        view.addSubview(pickerView)
        pickerView.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 44).isActive = true
//        pickerView.constrain(to: view.safeAreaLayoutGuide, trailingInset: -12, leadingInset: 12)

        
        // Create Announcement Button
        view.addSubview(createAnnouncementButton)
        createAnnouncementButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 44).isActive = true
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
