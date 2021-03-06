//
//  HIGroupListViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/27/21.
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

class HIGroupListViewController: HIBaseViewController {
    let groupDetailViewController = HIGroupDetailViewController()
    var teamStatusParam: String = ""
    var interestParams: [String] = []
}

// MARK: - UITableView Setup
extension HIGroupListViewController {
    override func setupTableView() {
        if let tableView = tableView {
            tableView.register(HIGroupCell.self, forCellReuseIdentifier: HIGroupCell.identifier)
            registerForPreviewing(with: self, sourceView: tableView)
        }
        super.setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension HIGroupListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIGroupCell.identifier, for: indexPath)
        if let cell = cell as? HIGroupCell, let profile = _fetchedResultsController?.object(at: indexPath) as? Profile {
            cell <- profile
            cell.indexPath = indexPath
        }
        return cell
    }
}

// MARK: - UIRefreshControl
extension HIGroupListViewController {
    override func refresh(_ sender: UIRefreshControl) {
        super.refresh(sender)
        HIProfileDataSource.refresh(teamStatus: teamStatusParam, interests: interestParams, completion: endRefreshing)
    }
}

// MARK: - UITableViewDelegate
extension HIGroupListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let profile = _fetchedResultsController?.object(at: indexPath) as? Profile else {
            return CGFloat.leastNonzeroMagnitude
        }
        return HIGroupCell.heightForCell(with: profile)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        groupDetailViewController.profile = _fetchedResultsController?.object(at: indexPath) as? Profile
        self.present(groupDetailViewController, animated: true, completion: nil)
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - HIGroupCellDelegate
// Add HIGroupCellDelegate & func groupCellDidSelectFavoriteButton

// MARK: - UIViewControllerPreviewingDelegate
extension HIGroupListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let tableView = tableView,
            let indexPath = tableView.indexPathForRow(at: location),
            let profile = _fetchedResultsController?.object(at: indexPath) as? Profile else {
                return nil
        }
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        groupDetailViewController.profile = profile
        return groupDetailViewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.present(viewControllerToCommit, animated: true, completion: nil)
    }
}
