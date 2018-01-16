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
        tableView?.register(UINib(nibName: HIEventCell.storyboardIdentifier, bundle: nil), forCellReuseIdentifier: HIEventCell.storyboardIdentifier)
        tableView?.register(UINib(nibName: HIDateHeader.storyboardIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: HIDateHeader.storyboardIdentifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEventCell.storyboardIdentifier, for: indexPath)
        if let cell = cell as? HIEventCell {
            // cell.titleLabel.text = fetchedResultsController.object(at: indexPath).name
            cell.titleLabel.text = "event"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HIDateHeader.storyboardIdentifier)
        if let header = header as? HIDateHeader {
            header.titleLabel.text = "\(section + 1):00 PM"
        }
        return header
    }
}

// MARK: - UITableViewDelegate
extension HIEventListViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailViewController = UIStoryboard(.modals).instantiate(HIEventDetailViewController.self) {
            $0.modalPresentationStyle = .overCurrentContext
            $0.modalTransitionStyle = .crossDissolve
//            $0.model = self._fetchedResultsController?.object(at: indexPath) as? Event
        }
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
