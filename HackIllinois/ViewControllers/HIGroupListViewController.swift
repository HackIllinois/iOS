//
//  HIGroupListViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/27/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//

import Foundation
import UIKit
import HIAPI
import APIManager

class HIGroupListViewController: HIBaseViewController {
    let groupDetailViewController = HIProjectDetailViewController()
}

// MARK: - UITableView Setup
extension HIGroupListViewController {
    override func setupTableView() {
        if let tableView = tableView {
            tableView.register(HIDateHeader.self, forHeaderFooterViewReuseIdentifier: HIDateHeader.identifier)
            tableView.register(HIGroupCell.self, forCellReuseIdentifier: HIGroupCell.identifier)
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
        HIProfileDataSource.refresh(teamStatus: "looking", interests: ["ML"], completion: endRefreshing)
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
}

// MARK: - HIGroupCellDelegate
// Add HIGroupCellDelegate & func groupCellDidSelectFavoriteButton

// MARK: - UIViewControllerPreviewingDelegate
// Add previewingContext functionality if HIGroupDetailViewController is added
