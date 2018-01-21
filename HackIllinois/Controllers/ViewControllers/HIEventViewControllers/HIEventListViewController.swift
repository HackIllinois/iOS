//
//  HIEventListViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 1/12/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

class HIEventListViewController: HIBaseViewController { }

// MARK: - UIViewController
extension HIEventListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRefreshControl()
        
        try? _fetchedResultsController?.performFetch()
    }
}

// MARK: - UITableView Setup
extension HIEventListViewController {
    override func setupTableView() {
        tableView?.register(HIDateHeader.self, forHeaderFooterViewReuseIdentifier: HIDateHeader.IDENTIFIER)
        tableView?.register(HIEventCell.self, forCellReuseIdentifier: HIEventCell.IDENTIFIER)
        super.setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension HIEventListViewController {
    // FIXME: remove after finishing layout debugging
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEventCell.IDENTIFIER, for: indexPath)
        if let cell = cell as? HIEventCell {
            // cell <- fetchedResultsController.object(at: indexPath)
            cell <- indexPath

        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HIEventListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // FIXME: Remove
        return HIEventCell.heightForCell(with: indexPath.row)
        guard let _ = _fetchedResultsController?.object(at: indexPath) as? Event else {
            return CGFloat.leastNonzeroMagnitude
        }
        return 0 // HIEventCell.heightForCell(displaying: event)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailViewController = HIEventDetailViewController()
        eventDetailViewController.modalPresentationStyle = .overCurrentContext
        eventDetailViewController.modalTransitionStyle = .crossDissolve
        // eventDetailViewController.model = self._fetchedResultsController?.object(at: indexPath) as? Event

        present(eventDetailViewController, animated: true, completion: nil)
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - UIRefreshControl
extension HIEventListViewController {
    override func refresh(_ sender: UIRefreshControl) {
        refreshAnimation.play()
    }
}
