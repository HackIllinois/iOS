//
//  HIEventListViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/12/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import HIAPI
import APIManager

class HIEventListViewController: HIBaseViewController {
    let eventDetailViewController = HIEventDetailViewController()
}

// MARK: - UITableView Setup
extension HIEventListViewController {
    override func setupTableView() {
        if let tableView = tableView {
            tableView.register(HIDateHeader.self, forHeaderFooterViewReuseIdentifier: HIDateHeader.identifier)
            tableView.register(HIEventCell.self, forCellReuseIdentifier: HIEventCell.identifier)
            registerForPreviewing(with: self, sourceView: tableView)
        }
        super.setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension HIEventListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEventCell.identifier, for: indexPath)
        if let cell = cell as? HIEventCell, let event = _fetchedResultsController?.object(at: indexPath) as? Event {
            cell <- event
            cell.delegate = self
            cell.indexPath = indexPath
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HIEventListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let event = _fetchedResultsController?.object(at: indexPath) as? Event else {
            return CGFloat.leastNonzeroMagnitude
        }
        return HIEventCell.heightForCell(with: event)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventDetailViewController.event = _fetchedResultsController?.object(at: indexPath) as? Event
        navigationController?.pushViewController(eventDetailViewController, animated: true)
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - UIRefreshControl
extension HIEventListViewController {
    override func refresh(_ sender: UIRefreshControl) {
        super.refresh(sender)
        HIEventDataSource.refresh(completion: endRefreshing)
    }
}

// MARK: - HIEventCellDelegate
extension HIEventListViewController: HIEventCellDelegate {
    func eventCellDidSelectFavoriteButton(_ eventCell: HIEventCell) {
        guard let indexPath = eventCell.indexPath,
            let event = _fetchedResultsController?.object(at: indexPath) as? Event else { return }

        let changeFavoriteStatusRequest: APIRequest<Favorite> =
            eventCell.favoritedButton.isActive ?
                HIAPI.EventService.unfavoriteBy(name: event.name) :
                HIAPI.EventService.favoriteBy(name: event.name)

        changeFavoriteStatusRequest
        .onCompletion { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    HILocalNotificationController.shared.unscheduleNotification(for: event)
                    event.favorite = !eventCell.favoritedButton.isActive
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
extension HIEventListViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let tableView = tableView,
            let indexPath = tableView.indexPathForRow(at: location),
            let event = _fetchedResultsController?.object(at: indexPath) as? Event else {
                return nil
        }
        previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
        eventDetailViewController.event = event
        return eventDetailViewController
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
