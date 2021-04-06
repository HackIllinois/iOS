//
//  HIEditProfileViewController.swift
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

class HIEditProfileViewController: HIBaseViewController {

    private let profileImageView = HIImageView {
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.constrain(width: 100, height: 100)
    }

    private let profileItems: [String] = ["First Name", "Last Name", "Team Status", "Bio", "Discord", "Skills"]
    private let scrollView = UIScrollView(frame: .zero)
    private let contentView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundHIColor = \.clear
    }
    private var tableViewHeight = NSLayoutConstraint()

}
// MARK: - UIViewController
extension HIEditProfileViewController {
    override func loadView() {
        super.loadView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.addSubview(contentView)

        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        let separatorView = HIView(style: nil) { (view) in
            view.backgroundHIColor = \.whiteTagFont
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            view.alpha = 0.5
        }

        contentView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
        separatorView.constrain(to: contentView, trailingInset: 0, leadingInset: 0)

        let tableView = HITableView()
        contentView.addSubview(tableView)
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 0).isActive = true
        tableView.constrain(to: contentView, trailingInset: 0, bottomInset: 0, leadingInset: 0)
        tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeight.isActive = true
        self.tableView = tableView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let profile = HIApplicationStateController.shared.profile else { return }
        if let url = URL(string: profile.avatarUrl), let imgValue = HIConstants.PROFILE_IMAGES[url.absoluteString] {
            profileImageView.changeImage(newImage: imgValue)
        }
        if let tableView = tableView {
            tableView.reloadData()
            tableView.layoutIfNeeded()
            tableView.beginUpdates()
            tableViewHeight.constant = tableView.contentSize.height + 20
            tableView.endUpdates()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.image = #imageLiteral(resourceName: "ProfileBackground")
        if let tableView = tableView {
            tableView.reloadData()
            tableView.layoutIfNeeded()
            tableView.beginUpdates()
            tableViewHeight.constant = tableView.contentSize.height + 20
            tableView.endUpdates()
        }
    }

    override func viewDidLayoutSubviews() {
        if let tableView = tableView {
            tableView.beginUpdates()
            tableViewHeight.constant = tableView.contentSize.height + 20
            tableView.endUpdates()
        }
    }
}

// MARK: - UINavigationItem Setup
extension HIEditProfileViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "Edit Profile"
    }

}

// MARK: - UITableView
extension HIEditProfileViewController {
    override func setupTableView() {
        if let tableView = tableView {
            tableView.register(HIEditProfileCell.self, forCellReuseIdentifier: HIEditProfileCell.identifier)
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

        return max(attrHeight, infoHeight) + 25
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEditProfileCell.identifier, for: indexPath)
        if let cell = cell as? HIEditProfileCell {
            cell <- (profileItems[indexPath.row], getStringFromAttributeIndex(of: indexPath.row))
            cell.selectionStyle = .none
            if indexPath.row == profileItems.count - 1 {
                cell.useHalfSeparator = false
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)

        let editController = HIEditProfileDetailViewController()
        let strValue = getStringFromAttributeIndex(of: indexPath.row)
        if let editingField = HIEditProfileDetailViewController.EditingField(rawValue: profileItems[indexPath.row]), let profile = HIApplicationStateController.shared.profile {
            editController.initializeData(editingField: editingField, textViewValue: strValue, characterLimit: 100, teamStatus: strValue, interests: profile.interests)
        }

        if let navController = self.navigationController as? HINavigationController {
            navController.pushViewController(editController, animated: true)
        }

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
            return profile.teamStatus.capitalized.replacingOccurrences(of: "_", with: " ")
        case 3:
            return profile.info
        case 4:
            return profile.discord
        case 5:
            var interestString = ""
            for interest in profile.interests {
                interestString += "\(interest), "
            }
            return String(interestString.dropLast(2))
        default:
            return ""
        }
    }
}
