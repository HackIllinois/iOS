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
    private let logoImage = HIImageView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hiImage = \.loginLogo
        $0.contentMode = .scaleAspectFit
    }
    private let welcomeHeader = HILabel(style: .viewTitle)
    private let spacerView = HIView {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
        $0.isUserInteractionEnabled = false
    }

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

    @objc dynamic override func setUpBackgroundView() {
        super.setUpBackgroundView()
        backgroundView.image = #imageLiteral(resourceName: "Login")
    }
}

// MARK: - UIViewController
extension HILoginSelectionViewController {
    override func loadView() {
        super.loadView()
        let tableView = HITableView()
        tableView.alwaysBounceVertical = false
        view.addSubview(welcomeHeader)
        view.addSubview(logoImage)
        view.addSubview(spacerView)
        view.addSubview(tableView)

        welcomeHeader.text = "Welcome to"
        welcomeHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120).isActive = true
        welcomeHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeHeader.heightAnchor.constraint(equalToConstant: 22).isActive = true

        logoImage.topAnchor.constraint(equalTo: welcomeHeader.bottomAnchor, constant: 25).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        spacerView.topAnchor.constraint(equalTo: logoImage.bottomAnchor).isActive = true
        spacerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        tableView.centerYAnchor.constraint(equalTo: spacerView.centerYAnchor).isActive = true

        tableView.isScrollEnabled = false
        self.tableView = tableView
    }
}

// MARK: - UITableView Setup
extension HILoginSelectionViewController {
    override func setupTableView() {
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
        return HIAPI.AuthService.OAuthProvider.all.count + 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Non-interactable text tableviewcells
        if indexPath.row == 0 || indexPath.row == 2 {
            let titleCell = UITableViewCell()
            titleCell.backgroundColor = UIColor.clear
            titleCell.contentView.backgroundColor = UIColor.clear
            titleCell.backgroundView?.backgroundColor = UIColor.clear
            titleCell.textLabel?.textAlignment = .center
            titleCell.textLabel?.backgroundColor = UIColor.clear
            titleCell.textLabel?.textColor = UIColor.white
            titleCell.selectionStyle = .none // Prevents the "- OR -" cell from being clickable
            if indexPath.row == 0 {
                titleCell.textLabel?.text = "Login"
                titleCell.textLabel?.font = HIAppearance.Font.loginTitle
            } else {
                titleCell.textLabel?.text = "- OR -"
                titleCell.textLabel?.font = HIAppearance.Font.loginSelection
            }
            return titleCell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: HILoginSelectionCell.identifier, for: indexPath)
        if let cell = cell as? HILoginSelectionCell {
            cell.titleLabel.textColor = UIColor.white
            cell.activeColor = .clear
            // Attendee cell
            if indexPath.row == 1 {
                cell.titleLabel.text = HIAPI.AuthService.OAuthProvider.all[0].displayName
                cell.defaultColor = (\HIAppearance.attendeeBackground).value
                cell.titleLabel.layer.borderColor = (\HIAppearance.attendeeBackground).value.cgColor
                cell.activeTextColor = (\HIAppearance.attendeeBackground).value
            } else if indexPath.row > 2 { //After "- OR -" cell roles
                cell.titleLabel.text = HIAPI.AuthService.OAuthProvider.all[indexPath.row - 2].displayName
                cell.defaultColor = (\HIAppearance.loginDefault).value
                cell.titleLabel.layer.borderColor = (\HIAppearance.loginDefault).value.cgColor
                cell.activeTextColor = (\HIAppearance.loginDefault).value
            }
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.titleLabel.layer.cornerRadius = cell.frame.height*(3/8)
        }
        return cell
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

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Prevents the "- OR -" cell from being clickable
        if indexPath.row == 0 || indexPath.row == 2 {
            return
        }

        if let delegate = delegate {
            if indexPath.row == 1 {
                let selection = HIAPI.AuthService.OAuthProvider.all[0]
                delegate.loginSelectionViewController(self, didMakeLoginSelection: selection)
            } else if indexPath.row > 2 {
                let selection = HIAPI.AuthService.OAuthProvider.all[indexPath.row - 2]
                delegate.loginSelectionViewController(self, didMakeLoginSelection: selection)
                }
        }
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}
