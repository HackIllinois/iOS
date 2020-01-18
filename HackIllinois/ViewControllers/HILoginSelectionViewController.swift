//
//  HILoginSelectionViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/30/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI

protocol HILoginSelectionViewControllerDelegate: class {
    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController, didMakeLoginSelection selection: HIAPI.AuthService.OAuthProvider)
}

class HILoginSelectionViewController: HIBaseViewController {
    // MARK: - Properties
    weak var delegate: HILoginSelectionViewControllerDelegate?

    // MARK: - Init
    convenience init(delegate: HILoginSelectionViewControllerDelegate) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

// MARK: - UIViewController
extension HILoginSelectionViewController {
    override func loadView() {
        super.loadView()
        let tableView = HITableView()
        tableView.alwaysBounceVertical = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 54).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: 220).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView = tableView
    }
}

// MARK: - UITableView Setup
extension HILoginSelectionViewController {
    override func setupTableView() {
        tableView?.register(HILoginSelectionHeader.self, forHeaderFooterViewReuseIdentifier: HILoginSelectionHeader.identifier)
        tableView?.register(HILoginSelectionCell.self, forCellReuseIdentifier: HILoginSelectionCell.identifier)
        super.setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension HILoginSelectionViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HIAPI.AuthService.OAuthProvider.all.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 1 {
//            let orLabel = HILabel {
//                $0.backgroundHIColor = \.contentBackground
//                $0.textHIColor = \.baseText
//                $0.font = HIAppearance.Font.contentText
//                $0.text = "Warning, this switch allows students that have not RSVP'ed to check in."
//            }
//            let orLabel = HILabel(style: .loginHeader)
//            orLabel.text = "- OR -"
            let orCell = UITableViewCell()
            orCell.backgroundColor = UIColor.clear
            orCell.contentView.backgroundColor = UIColor.clear
            orCell.backgroundView?.backgroundColor = UIColor.clear
            orCell.textLabel?.text = "- OR -"
            orCell.textLabel?.textAlignment = .center
            orCell.textLabel?.backgroundColor = UIColor.clear
            orCell.textLabel?.textColor = UIColor.red //TODO: Replace red with maroon
            orCell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            return orCell
        }

        let increment = indexPath.row > 1 ? 1 : 0

        let cell = tableView.dequeueReusableCell(withIdentifier: HILoginSelectionCell.identifier, for: indexPath)
        if let cell = cell as? HILoginSelectionCell {
            cell.titleLabel.text = HIAPI.AuthService.OAuthProvider.all[indexPath.row - increment].displayName
//            cell.separatorView.isHidden = true
//            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
////                cell.separatorView.isHidden = true
//            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HILoginSelectionHeader.identifier)
        if let header = header as? HILoginSelectionHeader {
            header.titleLabel.text = "LOGIN"
            header.welcomeLabel.text = "WELCOME TO"
        }
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - UITableViewDelegate
extension HILoginSelectionViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let increment = indexPath.row > 1 ? 1 : 0
        if let delegate = delegate {
            let selection = HIAPI.AuthService.OAuthProvider.all[indexPath.row - increment]
            delegate.loginSelectionViewController(self, didMakeLoginSelection: selection)
        }
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}
