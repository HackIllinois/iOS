//
//  HIEditProfileViewController.swift
//  HackIllinois
//
//  Created by alden lamp on 3/28/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIEditProfileViewController: HIBaseViewController {
    
    let profileImageView = HIImageView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.constrain(width: 100, height: 100)
    }
    
    let profileItems: [String] = ["First Name", "Last Name", "Team Status", "Bio", "Discord", "Interests"]

}
// MARK: - UIViewController
extension HIEditProfileViewController {
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let separatorView = HIView(style: nil) { (view) in
            view.backgroundHIColor = \.whiteTagFont
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            view.alpha = 0.5
        }
        
        self.view.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
        separatorView.constrain(to: self.view, trailingInset: 0, leadingInset: 0)
        
        self.tableView = HITableView()
        setupTableView()
        self.view.addSubview(self.tableView!)
        self.tableView!.isScrollEnabled = false
        self.tableView!.translatesAutoresizingMaskIntoConstraints = false
        self.tableView!.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0).isActive = true
        self.tableView!.constrain(to: self.view, trailingInset: 0, bottomInset: 0, leadingInset: 0)

//        let tableView = HITableView()
//        view.addSubview(tableView)
//        tableView.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        tableView.contentInset = UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0)
//        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0)
//        self.tableView = tableView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let profile = HIApplicationStateController.shared.profile else { return }
        if let url = URL(string: profile.avatarUrl) {
            profileImageView.downloadImage(from: url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.image = #imageLiteral(resourceName: "ProfileBackground")
    }
}



// MARK: - UINavigationItem Setup
extension HIEditProfileViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        
//        if !HIApplicationStateController.shared.isGuest {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "MenuUnfavorited"), style: .plain, target: self, action: #selector(didSelectFavoritesIcon(_:)))
//        }
    }

//    override func didMove(toParent parent: UIViewController?) {
//        if let navController = navigationController as? HINavigationController {
//            navController.infoTitleIsHidden = false
//        }
//    }
}

// MARK: - UITableView
extension HIEditProfileViewController {
    override func setupTableView() {
        if let tableView = tableView {
            tableView.register(HIEditProfileCell.self, forCellReuseIdentifier: HIEditProfileCell.identifier)
//            registerForPreviewing(with: self, sourceView: tableView)
        }
        super.setupTableView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let attrHeight = HILabel.heightForView(text: profileItems[indexPath.row], font: HIAppearance.Font.profileUsername, width: self.view.frame.width - 160)
        let infoHeight = HILabel.heightForView(text: getStringFromAttributeIndex(of: indexPath.row), font: HIAppearance.Font.profileDescription, width: self.view.frame.width - 160)
        
        return max(attrHeight, infoHeight) + 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEditProfileCell.identifier, for: indexPath)
        if let cell = cell as? HIEditProfileCell {
            cell <- (profileItems[indexPath.row], getStringFromAttributeIndex(of: indexPath.row))
            if indexPath.row == profileItems.count - 1 {
                cell.useHalfSeparator = false
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
    
}

// MARK: - Helper Functions
extension HIEditProfileViewController {
    func getStringFromAttributeIndex(of attributeIndex: Int) -> String {
        guard let profile = HIApplicationStateController.shared.profile else { return ""}
        
        switch attributeIndex {
        case 0:
            return profile.firstName
        case 1:
            return profile.lastName
        case 2:
            return profile.teamStatus
        case 3:
            return profile.info
        case 4:
            return profile.discord
        case 5:
            var interestString = ""
            for i in profile.interests {
                interestString += "\(i), "
            }
            return String(interestString.dropLast(2))
        default:
            return ""
        }
    }
}
