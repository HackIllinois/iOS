//
//  HIProjectListViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/25/19.
//  Copyright © 2019 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI
import APIManager

class HIProjectListViewController: HIBaseViewController {
    let projectDetailViewController = HIProjectDetailViewController()
}

// MARK: - UITableView Setup
extension HIProjectListViewController {
    override func setupTableView() {
        if let tableView = tableView {
            tableView.register(HIDateHeader.self, forHeaderFooterViewReuseIdentifier: HIDateHeader.identifier)
            tableView.register(HIProjectCell.self, forCellReuseIdentifier: HIProjectCell.identifier)
            registerForPreviewing(with: self, sourceView: tableView)
        }
        super.setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension HIProjectListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIProjectCell.identifier, for: indexPath)
        if let cell = cell as? HIProjectCell, let project = _fetchedResultsController?.object(at: indexPath) as? Project {
            cell <- project
            cell.delegate = self
            cell.indexPath = indexPath
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HIProjectListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let project = _fetchedResultsController?.object(at: indexPath) as? Project else {
            return CGFloat.leastNonzeroMagnitude
        }
        return HIProjectCell.heightForCell(with: project)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        projectDetailViewController.project = _fetchedResultsController?.object(at: indexPath) as? Project
        self.present(projectDetailViewController, animated: true, completion: nil)
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - UIRefreshControl
extension HIProjectListViewController {
    override func refresh(_ sender: UIRefreshControl) {
        super.refresh(sender)
        HIProjectDataSource.refresh(completion: endRefreshing)
    }
}

// MARK: - HIProjectCellDelegate
extension HIProjectListViewController: HIProjectCellDelegate {
    func projectCellDidSelectFavoriteButton(_ projectCell: HIProjectCell) {
        guard let indexPath = projectCell.indexPath,
            let project = _fetchedResultsController?.object(at: indexPath) as? Project else { return }

        let changeFavoriteStatusRequest: APIRequest<ProjectFavorites> =
            projectCell.favoritedButton.isActive ?
                HIAPI.ProjectService.unfavoriteBy(id: project.id) :
                HIAPI.ProjectService.favoriteBy(id: project.id)

        changeFavoriteStatusRequest
        .onCompletion { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    project.favorite.toggle()
                }
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
        .authorize(with: HIApplicationStateController.shared.user)
        .launch()
    }
}

// MARK: - UIViewControllerPreviewingDelegate
extension HIProjectListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let tableView = tableView,
            let indexPath = tableView.indexPathForRow(at: location),
            let project = _fetchedResultsController?.object(at: indexPath) as? Project else {
                return nil
        }
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        projectDetailViewController.project = project
        return projectDetailViewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.present(viewControllerToCommit, animated: true, completion: nil)
    }
}
