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
    var teamStatusParams: [String] = []
    var interestParams: [String] = []
}

// MARK: - UITableView Setup
extension HIGroupListViewController {
    override func setupTableView() {
        if let tableView = tableView {
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
            cell.delegate = self
            cell.indexPath = indexPath
        }
        return cell
    }
}

// MARK: - UIRefreshControl
extension HIGroupListViewController {
    override func refresh(_ sender: UIRefreshControl) {
        super.refresh(sender)
        HIProfileDataSource.refresh(teamStatus: teamStatusParams, interests: interestParams, completion: endRefreshing)
        tableView?.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension HIGroupListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let profile = _fetchedResultsController?.object(at: indexPath) as? Profile else {
            return CGFloat.leastNonzeroMagnitude
        }
        return HIGroupCell.heightForCell(with: profile, width: tableView.frame.width)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let profile = _fetchedResultsController?.object(at: indexPath) as? Profile else { return }
        var interests: [String] = []
        for interest in profile.interests.split(separator: ",") {
            interests.append(String(interest))
        }
        groupDetailViewController.profile = profile
        groupDetailViewController.interests = interests
        groupDetailViewController.profileInterestsView.reloadData()
        self.present(groupDetailViewController, animated: true, completion: nil)
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - HIGroupCellDelegate
extension HIGroupListViewController: HIGroupCellDelegate {
    func groupCellDidSelectFavoriteButton(_ groupCell: HIGroupCell) {
        guard let indexPath = groupCell.indexPath,
            let profile = _fetchedResultsController?.object(at: indexPath) as? Profile else { return }

        let changeFavoriteStatusRequest: APIRequest<ProfileFavorites> =
            groupCell.favoritedButton.isActive ?
                HIAPI.ProfileService.unfavoriteBy(id: profile.id) :
                HIAPI.ProfileService.favoriteBy(id: profile.id)

        changeFavoriteStatusRequest
        .onCompletion { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    profile.favorite.toggle()
                }
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
        .authorize(with: HIApplicationStateController.shared.user)
        .launch()
    }
}
