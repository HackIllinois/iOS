//
//  HIEditProfileDetailViewController.swift
//  HackIllinois
//
//  Created by alden lamp on 3/28/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIEditProfileDetailViewController: HIBaseViewController {
    
    // MARK: - Editing Fields
    enum EditingFields: String {
        case fName = "First Name"
        case lName = "Last Name"
        case teamStatus = "Team Status"
        case bio = "Bio"
        case discord = "Discord"
        case interests = "Interests"
    }

    //TODO: Load from HackIllinois API
    let interests = ["AWS", "C++", "Project Management", "Python", "Docker", "Java", "ML", "Swift", "Go", "Javascript", "C", "Typescript"]
    let teamStatuses = ["Looking for team", "Team looking for members"]
    var activeIndexes = [Int]()
    
    let textFieldContainerView = HIView { (view) in
        view.backgroundHIColor = \.clear
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let descriptionLabel = HILabel(style: .profileDescription) { (label) in
        label.alpha = 0.5
        label.numberOfLines = 0
    }
    
    let textField = HITextField(style: .editProfile)
    
    let characterCountLabel = HILabel(style: .characterCount) { (label) in
        label.constrain(height: 18)
        label.text = "00/00"
    }
    
    var characterLimit = 100
    
    var editingField: EditingFields!
}

// MARK: - UIViewController
extension HIEditProfileDetailViewController {
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(textFieldContainerView)
        textFieldContainerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        textFieldContainerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textFieldContainerView.constrain(to: self.view, trailingInset: 0, leadingInset: 0)
        
        textFieldContainerView.addSubview(descriptionLabel)
        descriptionLabel.constrain(to: textFieldContainerView, trailingInset: -20, leadingInset: 20)
        descriptionLabel.constrain(height: 50)
        descriptionLabel.topAnchor.constraint(equalTo: textFieldContainerView.topAnchor, constant: 10).isActive = true
        
        textFieldContainerView.addSubview(textField)
        textField.constrain(to: textFieldContainerView, trailingInset: -20, leadingInset: 20)
        textField.constrain(height: 30)
        textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30).isActive = true
        textField.delegate = self
        
        textFieldContainerView.addSubview(characterCountLabel)
        characterCountLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 10).isActive = true
        characterCountLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor).isActive = true
        characterCountLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        
        self.tableView = HITableView()
        setupTableView()
        self.view.addSubview(self.tableView!)
        self.tableView!.translatesAutoresizingMaskIntoConstraints = false
        self.tableView!.constrain(to: self.view, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        self.tableView!.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        if editingField == .interests || editingField == .teamStatus {
            textFieldContainerView.isHidden = true
        } else {
            self.tableView?.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = editingField.rawValue
        
        if let fieldValue = textField.text {
            characterCountLabel.text = "\(fieldValue.count < 10 ? "0" : "")\(fieldValue.count)/\(characterLimit < 10 ? "0" : "")\(characterLimit)"
        }
        
        let descriptionText: String
        
        switch editingField {
        case .bio:
            descriptionText = "Short description about yourself or your team if you're on a team"
        case .fName:
            descriptionText = "Add your name"
        case .lName:
            descriptionText = "Add your name"
        case .discord:
            descriptionText = "Add your Discord username"
        default:
            descriptionText = ""
        }
        
        descriptionLabel.text = descriptionText
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.image = #imageLiteral(resourceName: "ScheduleBackground")
    }
}

// MARK: - Set Up Data
extension HIEditProfileDetailViewController {
    func initializeData(editingField: EditingFields, textFieldValue: String? = nil, characterLimit: Int? = nil, teamStatus: Int? = nil, interests: [String]? = nil) {
        
        self.editingField = editingField
        
        if let fieldValue = textFieldValue {
            self.textField.text = fieldValue
        }
        
        if let limit = characterLimit{
            self.characterLimit = limit
        }
        
        if let status = teamStatus {
            if editingField == .teamStatus {
                self.activeIndexes = [status]
            }
        }
        
        if let selectedInterests = interests{
            if editingField == .interests {
                self.activeIndexes = [Int]()
                for i in 0..<self.interests.count {
                    if selectedInterests.contains(self.interests[i]) {
                        self.activeIndexes.append(i)
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
            cell <- ((editingField == .interests ? interests : teamStatuses)[indexPath.row], activeIndexes.contains(indexPath.row))
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if editingField == .interests {
            if activeIndexes.contains(indexPath.row) {
                activeIndexes.remove(at: activeIndexes.firstIndex(of: indexPath.row)!)
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

// MARK: - UITextField
extension HIEditProfileDetailViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        return newString.count <= characterLimit
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            characterCountLabel.text = "\(text.count < 10 ? "0" : "")\(text.count)/\(characterLimit < 10 ? "0" : "")\(characterLimit)"
        }
    }
}

// MARK: - Handle updating API
extension HIEditProfileDetailViewController {
    @objc func didSelectDone(_ sender: UIBarButtonItem) {
        
    }
    
}
