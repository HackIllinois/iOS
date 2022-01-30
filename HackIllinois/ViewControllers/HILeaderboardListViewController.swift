//
//  HILeaderboardViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 11/03/21.
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

class HILeaderboardListViewController: HIBaseViewController {
}

// MARK: - UITableView Setup
extension HILeaderboardListViewController {
    override func setupTableView() {
        if let tableView = tableView {
            tableView.register(HILeaderboardCell.self, forCellReuseIdentifier: HILeaderboardCell.identifier)
        }
        super.setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension HILeaderboardListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        var arr: [LeaderboardProfile] = []
        let jim = LeaderboardProfile()
        jim.firstName = "jim"
        jim.lastName = "smith"
        jim.points = 0
        arr.append(jim)
        let a = LeaderboardProfile()
        a.firstName = "Rohit"
        a.lastName = "Narayanan"
        a.points = 12230
        arr.append(a)
        let b = LeaderboardProfile()
        b.firstName = "kanye"
        b.lastName = "west"
        b.points = 110111
        arr.append(b)
        let c = LeaderboardProfile()
        c.firstName = "Matthew"
        c.lastName = "Davidson"
        c.points = 100
        arr.append(c)
        let d = LeaderboardProfile()
        d.firstName = "Kendrick"
        d.lastName = "Lamar"
        d.points = 280
        arr.append(d)
        let e = LeaderboardProfile()
        e.firstName = "Bartholomew"
        e.lastName = "Octavian"
        e.points = 123120
        arr.append(e)
        let f = LeaderboardProfile()
        f.firstName = "Billy"
        f.lastName = "Cyrus"
        f.points = 333
        arr.append(f)
        let g = LeaderboardProfile()
        g.firstName = "Peterious"
        g.lastName = "Davidson"
        g.points = 7467
        arr.append(g)
        let h = LeaderboardProfile()
        h.firstName = "Carter"
        h.lastName = "smith"
        h.points = 9
        arr.append(h)
        let i = LeaderboardProfile()
        i.firstName = "Joseph"
        i.lastName = "biden"
        i.points = 46
        arr.append(i)
        let cell = tableView.dequeueReusableCell(withIdentifier: HILeaderboardCell.identifier, for: indexPath)
        if let cell = cell as? HILeaderboardCell, let leaderboardProfile = arr[indexPath.row] as? LeaderboardProfile {
            cell <- leaderboardProfile
            cell.indexPath = indexPath
            cell.rankLabel.text = "\((indexPath.row) + 1)"
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9568627451, blue: 0.8274509804, alpha: 1)
            } else {
                cell.backgroundColor =  #colorLiteral(red: 0.9098039216, green: 0.8431372549, blue: 0.6470588235, alpha: 1)
            }
        } */
        let cell = tableView.dequeueReusableCell(withIdentifier: HILeaderboardCell.identifier, for: indexPath)
        if let cell = cell as? HILeaderboardCell, let leaderboardProfile = _fetchedResultsController?.object(at: indexPath) as? LeaderboardProfile {
            cell <- leaderboardProfile
            cell.indexPath = indexPath
            cell.rankLabel.text = "\((indexPath.row) + 1)"
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9568627451, blue: 0.8274509804, alpha: 1)
            } else {
                cell.backgroundColor =  #colorLiteral(red: 0.9098039216, green: 0.8431372549, blue: 0.6470588235, alpha: 1)
            }
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension HILeaderboardListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tHeight = tableView.frame.height
        let temp = tHeight / 10
        return temp > 60 ? temp : 60
    }
}
