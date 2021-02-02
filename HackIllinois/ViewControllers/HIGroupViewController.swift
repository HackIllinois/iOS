//
//  HIGroupViewController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 1/27/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UIKit
import CoreData

class HIGroupViewController: HIGroupListViewController {
    // MARK: - Properties
    private var currentTab = 0
    private var onlyFavorites = false
    private let onlyFavoritesPredicate = NSPredicate(format: "favorite == YES" )
    
    @objc dynamic override func setUpBackgroundView() {
            super.setUpBackgroundView()
            backgroundView.image = #imageLiteral(resourceName: "GroupMatching")
        }
}

// MARK: - UITabBarItem Setup
extension HIGroupViewController {
    override func setupTabBarItem() {
        tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "project"), tag: 0)
    }
}

// MARK: - Actions
extension HIGroupViewController {
    func animateReload() {
        if let tableView = tableView, !tableView.visibleCells.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}

// MARK: - UIViewController
extension HIGroupViewController {
    override func loadView() {
        super.loadView()
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.alignment = .center
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalStackView)
        horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        horizontalStackView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let sortLabel = HILabel(style: .sortText)
        sortLabel.text = "Sort: "
        horizontalStackView.addSubview(sortLabel)
        
        let skillSortButton = HIButton {
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            $0.titleLabel?.font = HIAppearance.Font.sortingText
            $0.backgroundHIColor = \.buttonViewBackground
            $0.titleHIColor = \.action
            $0.title = "Skills"
        }
        horizontalStackView.addSubview(skillSortButton)
        skillSortButton.centerYAnchor.constraint(equalTo: horizontalStackView.centerYAnchor).isActive = true
        skillSortButton.leadingAnchor.constraint(equalTo: sortLabel.trailingAnchor).isActive = true
        skillSortButton.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor).isActive = true
        skillSortButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        skillSortButton.widthAnchor.constraint(equalToConstant: 73).isActive = true
        
        
        let tableView = HITableView()
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
    }
}

// MARK: - UINavigationItem Setup
extension HIGroupViewController {
    @objc dynamic override func setupNavigationItem() {
        super.setupNavigationItem()
        title = "Group Matching"
    }
}

// MARK: - UITableViewDelegate
extension HIGroupViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
}
