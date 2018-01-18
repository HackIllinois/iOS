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
        tableView?.register(UINib(nibName: HIEventCell.IDENTIFIER, bundle: nil), forCellReuseIdentifier: HIEventCell.IDENTIFIER)
        tableView?.register(UINib(nibName: HIDateHeader.IDENTIFIER, bundle: nil), forHeaderFooterViewReuseIdentifier: HIDateHeader.IDENTIFIER)
        super.viewDidLoad()

        setupRefreshControl()
        
        try? _fetchedResultsController?.performFetch()
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
            // cell.titleLabel.text = fetchedResultsController.object(at: indexPath).name
            cell.titleLabel.text = "event"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HIDateHeader.IDENTIFIER)
        if let header = header as? HIDateHeader {
            header.titleLabel.text = "\(section + 1):00 PM"
        }
        return header
    }
}

// MARK: - UITableViewDelegate
extension HIEventListViewController {
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
