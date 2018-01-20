//
//  HILoginSelectionViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/30/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

protocol HILoginSelectionViewControllerDelegate: class {
    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController, didMakeLoginSelection selection: HILoginMethod, withUserInfo info: String?)
    func loginSelectionViewControllerKeychainAccounts(_ loginSelectionViewController: HILoginSelectionViewController) -> [String]
}

class HILoginSelectionViewController: HIBaseViewController {
    // MARK: - Properties
    weak var delegate: HILoginSelectionViewControllerDelegate!

    var staticDataStore: [(loginMethod: HILoginMethod, displayText: String)] = [
        (.github,   "HACKER"),
        (.userPass, "MENTOR"),
        (.userPass, "STAFF"),
        (.userPass, "VOLUNTEER")
    ]
}

// MARK: - UIViewController
extension HILoginSelectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = delegate else {
            fatalError("delegate must not be nil")
        }
    }
}

// MARK: - UITableView Setup
extension HILoginSelectionViewController {
    override func setupTableView() {
        tableView?.register(UINib(nibName: HILoginSelectionCell.storyboardIdentifier, bundle: nil), forCellReuseIdentifier: HILoginSelectionCell.storyboardIdentifier)
        tableView?.register(UINib(nibName: HILoginSelectionHeader.storyboardIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: HILoginSelectionHeader.storyboardIdentifier)
        super.setupTableView()
        tableView?.alwaysBounceVertical = false
    }
}

// MARK: - UITableViewDataSource
extension HILoginSelectionViewController {
    // FIXME: remove after finishing layout debugging
    override func numberOfSections(in tableView: UITableView) -> Int {
        let keychainAccounts = delegate?.loginSelectionViewControllerKeychainAccounts(self).count ?? 0
        return keychainAccounts > 0 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return staticDataStore.count
        default:
            return delegate?.loginSelectionViewControllerKeychainAccounts(self).count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HILoginSelectionCell.storyboardIdentifier, for: indexPath)
        if let cell = cell as? HILoginSelectionCell {
            switch indexPath.section {
            case 0:
                cell.titleLabel.text = staticDataStore[indexPath.row].displayText
            default:
                cell.titleLabel.text = delegate.loginSelectionViewControllerKeychainAccounts(self)[indexPath.row].uppercased()
            }
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                cell.indicatorView.isHidden = true
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HILoginSelectionHeader.storyboardIdentifier)
        if let header = header as? HILoginSelectionHeader {
            switch section {
            case 0:
                header.titleLabel.text = "I AM A"
            default:
                header.titleLabel.text = "ACCOUNTS"
            }
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
        return 45
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let selection = staticDataStore[indexPath.row].loginMethod
            delegate.loginSelectionViewController(self, didMakeLoginSelection: selection, withUserInfo: nil)

        default:
            let info = delegate.loginSelectionViewControllerKeychainAccounts(self)[indexPath.row]
            delegate.loginSelectionViewController(self, didMakeLoginSelection: .existing, withUserInfo: info)

        }
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

