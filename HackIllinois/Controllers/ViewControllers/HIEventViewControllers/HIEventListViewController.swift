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

    init() {
        super.init(nibName: nil, bundle: nil)
        eventDetailViewController.modalPresentationStyle = .overCurrentContext
        eventDetailViewController.modalTransitionStyle = .crossDissolve
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used.")
    }
}

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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HIEventCell.IDENTIFIER, for: indexPath)
        if let cell = cell as? HIEventCell, let event = _fetchedResultsController?.object(at: indexPath) as? Event {
            cell <- event
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
        eventDetailViewController.model = _fetchedResultsController?.object(at: indexPath) as? Event
        present(eventDetailViewController, animated: true, completion: nil)
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - UIRefreshControl
extension HIEventListViewController {
    override func refresh(_ sender: UIRefreshControl) {
        refreshAnimation.play()
        HIEventDataSource.refresh(completion: endRefreshing)
    }

    func endRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.refreshAnimation.stop()
        }
    }
}
