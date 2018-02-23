//
//  HIEventListViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/12/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIEventListViewController: HIBaseViewController {
    let eventDetailViewController = HIEventDetailViewController()
}

// MARK: - UITableView Setup
extension HIEventListViewController {
    override func setupTableView() {
        tableView?.register(HIDateHeader.self, forHeaderFooterViewReuseIdentifier: HIDateHeader.identifier)
        tableView?.register(HIEventCell.self, forCellReuseIdentifier: HIEventCell.identifier)
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
            let isFavorite = eventCell.favoritedButton.isActive,
            let event = _fetchedResultsController?.object(at: indexPath) as? Event else { return }

        if isFavorite {
            HIEventService.unfavortieBy(id: Int(event.id))
                .onCompletion { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            HILocalNotificationController.shared.unscheduleNotification(for: event)
                            event.favorite = false
//                            if eventCell.indexPath == indexPath {
//                                eventCell.setActive(event.favorite)
//                            }
                        }
                    case .cancellation:
                        break
                    case .failure(let error):
                        print(error, error.localizedDescription)
                    }
                }
                .authorization(HIApplicationStateController.shared.user)
                .perform()

        } else {
            HIEventService.favortieBy(id: Int(event.id))
            .onCompletion { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        HILocalNotificationController.shared.scheduleNotification(for: event)
                        event.favorite = true
//                        if eventCell.indexPath == indexPath {
//                            eventCell.setActive(event.favorite)
//                        }
                    }
                case .cancellation:
                    break
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
            .authorization(HIApplicationStateController.shared.user)
            .perform()
        }
    }
}
