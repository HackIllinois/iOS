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
        if let cell = cell as? HIGroupCell, let group = _fetchedResultsController?.object(at: indexPath) as? Project {
            cell <- group
            cell.indexPath = indexPath
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HIGroupListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let group = _fetchedResultsController?.object(at: indexPath) as? Project else {
            return CGFloat.leastNonzeroMagnitude
        }
        return HIGroupCell.heightForCell(with: group)
    }
}

// MARK: - HIGroupCellDelegate
// Add HIGroupCellDelegate & func groupCellDidSelectFavoriteButton

// MARK: - UIViewControllerPreviewingDelegate
// Add previewingContext functionality if HIGroupDetailViewController is added
