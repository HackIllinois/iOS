//
//  HIEditProfileDetailViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 3/28/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI
import APIManager

class HIEditProfileDetailViewController: HIBaseViewController {

    // MARK: - Editing Fields
    enum EditingField: String {
        case fName = "First Name"
        case lName = "Last Name"
        case teamStatus = "Team Status"
        case bio = "Bio"
        case discord = "Discord"
        case interests = "Skills"
    }

    let interests = HIInterestDataSource.shared.interestOptions
    let teamStatuses = ["Looking For Team", "Looking For Members", "Not Looking"]
    var activeIndexes = [Int]()

    let inputContainerView = HIView { (view) in
        view.backgroundHIColor = \.clear
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    let descriptionLabel = HILabel(style: .profileDescription) { (label) in
        label.alpha = 0.5
        label.numberOfLines = 0
    }

    let inputTextView = HITextView()

    let characterCountLabel = HILabel(style: .characterCount) { (label) in
        label.constrain(height: 18)
        label.text = "00/00"
    }

    var characterLimit = 100

    var editingField: EditingField?
}

// MARK: - Actions
extension HIEditProfileDetailViewController {
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: - UIViewController
extension HIEditProfileDetailViewController {
    override func loadView() {
        super.loadView()

        self.view.addSubview(inputContainerView)
        inputContainerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        inputContainerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        inputContainerView.constrain(to: self.view, trailingInset: 0, leadingInset: 0)

        inputContainerView.addSubview(descriptionLabel)
        descriptionLabel.constrain(to: inputContainerView, trailingInset: -20, leadingInset: 20)
        descriptionLabel.constrain(height: 50)
        descriptionLabel.topAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: 10).isActive = true

        let countConstrainView: UIView
        constrainInputTextView()
        countConstrainView = inputTextView

        inputContainerView.addSubview(characterCountLabel)
        characterCountLabel.leadingAnchor.constraint(equalTo: countConstrainView.leadingAnchor, constant: 10).isActive = true
        characterCountLabel.trailingAnchor.constraint(equalTo: countConstrainView.trailingAnchor).isActive = true
        characterCountLabel.topAnchor.constraint(equalTo: countConstrainView.bottomAnchor, constant: 10).isActive = true

        let tableView = HITableView()
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.constrain(to: self.view, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true

        if editingField == .interests || editingField == .teamStatus {
            inputContainerView.isHidden = true
        } else {
            tableView.isHidden = true
            let viewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(viewGestureRecognizer)
        }
        self.tableView = tableView
    }

    func constrainInputTextView() {
        inputTextView.isScrollEnabled = false
        inputContainerView.addSubview(inputTextView)
        inputTextView.constrain(to: inputContainerView, trailingInset: -20, leadingInset: 20)
        inputTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30).isActive = true
        inputTextView.delegate = self
        inputTextView.addBottomBorder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = editingField?.rawValue

        let descriptionText: String
        switch editingField {
        case .bio:
            descriptionText = "Add a short description about yourself or your team."
            characterLimit = 400
            updateCharacterCount()
        case .fName:
            descriptionText = "Add your first name."
            updateCharacterCount()
        case .lName:
            descriptionText = "Add your last name."
            updateCharacterCount()
        case .discord:
            descriptionText = "Add your Discord username."
            updateCharacterCount()
        default:
            descriptionText = ""
            updateCharacterCount()
        }
        descriptionLabel.text = descriptionText
    }

    func updateCharacterCount() {
        if let fieldValue = inputTextView.text {
            characterCountLabel.text = "\(fieldValue.count < 10 ? "0" : "")\(fieldValue.count)/\(characterLimit < 10 ? "0" : "")\(characterLimit)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.image = #imageLiteral(resourceName: "ScheduleBackground")
    }
}

// MARK: - Set Up Data
extension HIEditProfileDetailViewController {
    func initializeData(editingField: EditingField, textViewValue: String? = nil, characterLimit: Int? = nil, teamStatus: String? = nil, interests: [String]? = nil) {

        self.editingField = editingField

        if let fieldValue = textViewValue {
            self.inputTextView.text = fieldValue
        }

        if let limit = characterLimit {
            self.characterLimit = limit
        }

        if let status = teamStatus {
            if editingField == .teamStatus {
                if let index = teamStatuses.firstIndex(of: status) {
                    self.activeIndexes = [index]
                }
            }
        }

        if let selectedInterests = interests {
            if editingField == .interests {
                self.activeIndexes = [Int]()
                for index in 0..<self.interests.count {
                    if selectedInterests.contains(self.interests[index]) {
                        self.activeIndexes.append(index)
                    }
                }
            }
        }
    }

}

// MARK: - UINavigationItem Setup
extension HIEditProfileDetailViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()

        if !HIApplicationStateController.shared.isGuest {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didSelectDone(_:)))
        }
    }

}

// MARK: - UITableView
extension HIEditProfileDetailViewController {
    override func setupTableView() {
        if let tableView = tableView {
            tableView.register(HIEditProfileDetailCell.self, forCellReuseIdentifier: HIEditProfileDetailCell.identifier)
//            registerForPreviewing(with: self, sourceView: tableView)
        }
        super.setupTableView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if editingField == .interests {
            return interests.count
        } else {
            return teamStatuses.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEditProfileDetailCell.identifier, for: indexPath)
        if let cell = cell as? HIEditProfileDetailCell {
            if editingField == .interests {
                cell.editType = .interests
                cell <- (interests[indexPath.row], activeIndexes.contains(indexPath.row))
            } else {
                cell.editType = .teamStatus
                cell <- (teamStatuses[indexPath.row], activeIndexes.contains(indexPath.row))
            }
            cell.selectionStyle = .none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)

        if editingField == .interests {
            if let index = activeIndexes.firstIndex(of: indexPath.row) {
                activeIndexes.remove(at: index)
            } else {
                activeIndexes.append(indexPath.row)
            }
        } else {
            if activeIndexes.isEmpty {
                activeIndexes.append(indexPath.row)
            } else {
                let oldRow = IndexPath(row: activeIndexes[0], section: 0)
                activeIndexes[0] = indexPath.row
                tableView.reloadRows(at: [oldRow], with: .automatic)
            }
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITextViewDelegate
extension HIEditProfileDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        let newString = ((textView.text ?? "") as NSString).replacingCharacters(in: range, with: text)
        let newStringComponents = newString.components(separatedBy: "\n").count
        return newString.count <= characterLimit && newStringComponents == 1
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        updateCharacterCount()
    }
}

// MARK: - API Requests
extension HIEditProfileDetailViewController {
    @objc func didSelectDone(_ sender: UIBarButtonItem) {
        guard let profile = HIApplicationStateController.shared.profile else { return }
        guard let user = HIApplicationStateController.shared.user else { return }

        var profileData = [String: Any]()
        profileData["id"] = profile.id
        profileData["firstName"] = profile.firstName
        profileData["lastName"] = profile.lastName
        profileData["points"] = profile.points
        profileData["timezone"] = profile.timezone
        profileData["description"] = profile.info
        profileData["discord"] = profile.discord
        profileData["avatarURL"] = profile.avatarUrl
        profileData["teamStatus"] = profile.teamStatus
        profileData["interests"] = profile.interests

        if let inputText = inputTextView.text {
            switch editingField {
            case .fName:
                profileData["firstName"] = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
            case .lName:
                profileData["lastName"] = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
            case .discord:
                profileData["discord"] = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
            case .bio:
                profileData["description"] = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
            default:
                break
            }
        }

        if editingField == .interests {
            var interests = [String]()
            for index in 0..<activeIndexes.count {
                interests.append(self.interests[activeIndexes[index]])
            }
            profileData["interests"] = interests.sorted { $0.localizedCompare($1) == .orderedAscending }
        } else if editingField == .teamStatus {
            if activeIndexes.count == 1 {
                profileData["teamStatus"] = teamStatuses[activeIndexes[0]].uppercased().replacingOccurrences(of: " ", with: "_")
            }
        }

        HIAPI.ProfileService.updateUserProfile(profileData: profileData).onCompletion { [weak self] result in
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
                    self?.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: .loginProfile, object: nil, userInfo: ["profile": profile])
                }
            } catch {
                DispatchQueue.main.async {
                    self?.presentErrorController(title: "Failed to update profile", dismissParentOnCompletion: true)
                }
                print("Failed to reload profile with error: \(error)")
            }
        }
        .authorize(with: user)
        .launch()
    }
}
